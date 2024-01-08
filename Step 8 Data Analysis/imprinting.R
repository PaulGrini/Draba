library(tidyverse)
library(ggplot2)
library(VennDiagram)
library(org.At.tair.db)
library(AnnotationDbi)
library(clusterProfiler)
library(AnnotationHub)
library(tidyverse)
library(enrichplot)

#Read in files and rename columns
AxN <- read.csv("AlaNor.filtered.final.csv", header = FALSE)
names(AxN)[1]<- 'Gene'
names(AxN)[2]<- 'Ala1'
names(AxN)[3]<- 'Ala2'
names(AxN)[4]<- 'Ala3'
names(AxN)[5]<- 'Ala4'
names(AxN)[6]<- 'Nor1'
names(AxN)[7]<- 'Nor2'
names(AxN)[8]<- 'Nor3'
names(AxN)[9]<- 'Nor4'
names(AxN)[10]<- 'Numbers'
names(AxN)[11]<- 'log2FC'
names(AxN)[12]<- 'AveExp'
names(AxN)[13]<- 't'
names(AxN)[14]<- 'P.val'
names(AxN)[15]<- 'Adj.P.Val'
names(AxN)[16]<- 'B'
names(AxN)[17]<- 'x'

#Remove unecessary columns
AxN <- AxN %>% select(-10, -12, -13, -16, -17) 

#Read in files and rename columns
NxA <- read.csv("NorAla.filtered.final.csv", header = FALSE)
names(NxA)[1]<- 'Gene'
names(NxA)[2]<- 'Nor1'
names(NxA)[3]<- 'Nor2'
names(NxA)[4]<- 'Nor3'
names(NxA)[5]<- 'Nor4'
names(NxA)[6]<- 'Ala1'
names(NxA)[7]<- 'Ala2'
names(NxA)[8]<- 'Ala3'
names(NxA)[9]<- 'Ala4'
names(NxA)[10]<- 'Numbers'
names(NxA)[11]<- 'log2FC'
names(NxA)[12]<- 'AveExp'
names(NxA)[13]<- 't'
names(NxA)[14]<- 'P.val'
names(NxA)[15]<- 'Adj.P.Val'
names(NxA)[16]<- 'B'
names(NxA)[17]<- 'x'

#Remove unecessary columns
NxA <- NxA %>% select(-10, -12, -13, -16, -17) 

#Read in Ath orthologs
agi <- read.csv2("Dniva_AGI_orthologs.csv")

#Sort
agi <- agi[order(agi$AGI),]

#Add new column with AGI
AxN$At_Gene <- agi$AGI[match(AxN$Gene, agi$Dniva)]
NxA$At_Gene <- agi$AGI[match(NxA$Gene, agi$Dniva)]

write.csv2(AxN, "AxN.csv")
write.csv2(NxA, "NxA.csv")


AlaNor_MEG <- AxN[order(AxN$log2FC),] %>% .[.$log2FC >= 3, ] %>% .[which(.$Adj.P.Val < 0.05),]
NorAla_MEG <- NxA[order(NxA$log2FC),] %>% .[.$log2FC >= 3, ] %>% .[which(.$Adj.P.Val < 0.05),]

AlaNor_PEG <- AxN[order(AxN$log2FC),] %>% .[.$log2FC <= -1, ] %>% .[which(.$Adj.P.Val < 0.05),]
NorAla_PEG <- NxA[order(NxA$log2FC),] %>% .[.$log2FC <= -1, ] %>% .[which(.$Adj.P.Val < 0.05),]

#Find overlap
AlaNor_NorAla_MEG <- subset(AlaNor_MEG, Gene %in% NorAla_MEG$Gene)
AlaNor_NorAla_PEG <- subset(AlaNor_PEG, Gene %in% NorAla_PEG$Gene)

#Venn diagram PEG
grid.newpage() 
venn.plot <- draw.pairwise.venn(
  area1= nrow(AlaNor_PEG),
  area2= nrow(NorAla_PEG),
  cross.area=nrow(AlaNor_NorAla_PEG),
  cat.pos=(0),
  category=c("Alaska x Norway","Norway x Alaska"),
  fill = c("deepskyblue4","goldenrod"),
  cat.col=c("black", "black"),
  cat.cex=1,
  margin=0.0005,
  ind=TRUE, 
  scale = FALSE, 
  rotation.degree = 180);

#Venn diagram MEG
grid.newpage() 
venn.plot <- draw.pairwise.venn(
  area1= nrow(AlaNor_MEG),
  area2= nrow(NorAla_MEG),
  cross.area=nrow(AlaNor_NorAla_MEG),
  category=c("Alaska x Norway","Norway x Alaska"),
  cat.pos=(0),
  fill = c("deepskyblue4","goldenrod"),
  cat.col=c("black", "black"),
  cat.cex=1,
  margin=0.0005,
  ind=TRUE, 
  scale = FALSE)

#Histogram to check distribution of log2FC
AxN_hist <- hist(AxN$log2FC, xlab = "Histogram of log2FC values of AxN dataset", ylab = "Number of genes", breaks = 20)
text(AxN_hist$mids,AxN_hist$counts,labels=AxN_hist$counts, adj=c(0.5, -0.5))

NxA_hist <- hist(NxA$log2FC, xlab = "Histogram of log2FC values of NxA dataset", ylab = "Number of genes", breaks = 20)
text(NxA_hist$mids,NxA_hist$counts,labels=NxA_hist$counts, adj=c(0.5, -0.5))
