#Read in libraries

library(dplyr)
library(ggplot2)
library(readr)
library(plyr)
library(tidyverse)
library(DESeq2)
library(VennDiagram)
library(PCAtools)
library(ggpubr)

#Read all tables
Sample_25 <- read_tsv("Sample_25_A1.tsv")
Sample_26 <- read_tsv("Sample_26_A3.tsv")
Sample_27 <- read_tsv("Sample_27_A4.tsv")
Sample_28 <- read_tsv("Sample_28_A5.tsv")
Sample_29 <- read_tsv("Sample_29_N1.tsv")
Sample_30 <- read_tsv("Sample_30_N2.tsv")
Sample_31 <- read_tsv("Sample_31_N3.tsv")
Sample_32 <- read_tsv("Sample_32_N6.tsv")
Sample_33 <- read_tsv("Sample_33_A11xN16.tsv")
Sample_34 <- read_tsv("Sample_34_A13xN16.tsv")
Sample_35 <- read_tsv("Sample_35_A14xN16.tsv")
Sample_36 <- read_tsv("Sample_36_A15xN16.tsv")
Sample_37 <- read_tsv("Sample_37_N8xA11.tsv")
Sample_38 <- read_tsv("Sample_38_N12xA11.tsv")
Sample_39 <- read_tsv("Sample_39_N13xA11.tsv")
Sample_40 <- read_tsv("Sample_40_N14xA11.tsv")

#Sort
Sample_25 <- Sample_25[order(Sample_25$gene),]
Sample_26 <- Sample_26[order(Sample_26$gene),]
Sample_27 <- Sample_27[order(Sample_27$gene),]
Sample_28 <- Sample_28[order(Sample_28$gene),]
Sample_29 <- Sample_29[order(Sample_29$gene),]
Sample_30 <- Sample_30[order(Sample_30$gene),]
Sample_31 <- Sample_31[order(Sample_31$gene),]
Sample_32 <- Sample_32[order(Sample_32$gene),]
Sample_33 <- Sample_33[order(Sample_33$gene),]
Sample_34 <- Sample_34[order(Sample_34$gene),]
Sample_35 <- Sample_35[order(Sample_35$gene),]
Sample_36 <- Sample_36[order(Sample_36$gene),]
Sample_37 <- Sample_37[order(Sample_37$gene),]
Sample_38 <- Sample_38[order(Sample_38$gene),]
Sample_39 <- Sample_39[order(Sample_39$gene),]
Sample_40 <- Sample_40[order(Sample_40$gene),]

#Add _Alaska or _Norway to genes
Sample_25$Gene <- paste(Sample_25$gene, Sample_25$allele, sep="_")
Sample_26$Gene <- paste(Sample_26$gene, Sample_26$allele, sep="_")
Sample_27$Gene <- paste(Sample_27$gene, Sample_27$allele, sep="_")
Sample_28$Gene <- paste(Sample_28$gene, Sample_28$allele, sep="_")
Sample_29$Gene <- paste(Sample_29$gene, Sample_29$allele, sep="_")
Sample_30$Gene <- paste(Sample_30$gene, Sample_30$allele, sep="_")
Sample_31$Gene <- paste(Sample_31$gene, Sample_31$allele, sep="_")
Sample_32$Gene <- paste(Sample_32$gene, Sample_32$allele, sep="_")
Sample_33$Gene <- paste(Sample_33$gene, Sample_33$allele, sep="_")
Sample_34$Gene <- paste(Sample_34$gene, Sample_34$allele, sep="_")
Sample_35$Gene <- paste(Sample_35$gene, Sample_35$allele, sep="_")
Sample_36$Gene <- paste(Sample_36$gene, Sample_36$allele, sep="_")
Sample_37$Gene <- paste(Sample_37$gene, Sample_37$allele, sep="_")
Sample_38$Gene <- paste(Sample_38$gene, Sample_38$allele, sep="_")
Sample_39$Gene <- paste(Sample_39$gene, Sample_39$allele, sep="_")
Sample_40$Gene <- paste(Sample_40$gene, Sample_40$allele, sep="_")

#Remove gene and allele column
Sample_25 <- Sample_25 %>% select(-1, -2, -4) 
Sample_26 <- Sample_26 %>% select(-1, -2, -4) 
Sample_27 <- Sample_27 %>% select(-1, -2, -4) 
Sample_28 <- Sample_28 %>% select(-1, -2, -4) 
Sample_29 <- Sample_29 %>% select(-1, -2, -4) 
Sample_30 <- Sample_30 %>% select(-1, -2, -4) 
Sample_31 <- Sample_31 %>% select(-1, -2, -4) 
Sample_32 <- Sample_32 %>% select(-1, -2, -4) 
Sample_33 <- Sample_33 %>% select(-1, -2, -4) 
Sample_34 <- Sample_34 %>% select(-1, -2, -4) 
Sample_35 <- Sample_35 %>% select(-1, -2, -4) 
Sample_36 <- Sample_36 %>% select(-1, -2, -4) 
Sample_37 <- Sample_37 %>% select(-1, -2, -4) 
Sample_38 <- Sample_38 %>% select(-1, -2, -4) 
Sample_39 <- Sample_39 %>% select(-1, -2, -4) 
Sample_40 <- Sample_40 %>% select(-1, -2, -4) 

#Rename column headers to specify dataset
names(Sample_25)[1]<- 'Sample_25'
names(Sample_26)[1]<- 'Sample_26'
names(Sample_27)[1]<- 'Sample_27'
names(Sample_28)[1]<- 'Sample_28'
names(Sample_29)[1]<- 'Sample_29'
names(Sample_30)[1]<- 'Sample_30'
names(Sample_31)[1]<- 'Sample_31'
names(Sample_32)[1]<- 'Sample_32'
names(Sample_33)[1]<- 'Sample_33'
names(Sample_34)[1]<- 'Sample_34'
names(Sample_35)[1]<- 'Sample_35'
names(Sample_36)[1]<- 'Sample_36'
names(Sample_37)[1]<- 'Sample_37'
names(Sample_38)[1]<- 'Sample_38'
names(Sample_39)[1]<- 'Sample_39'
names(Sample_40)[1]<- 'Sample_40'


All <- list(Sample_25, Sample_26, Sample_27, Sample_28, Sample_29, Sample_30, Sample_31, Sample_32, Sample_33, Sample_34, Sample_35, Sample_36, Sample_37, Sample_38, Sample_39, Sample_40)
All <- All %>% purrr::reduce(dplyr::full_join, by = c("Gene"))
All <- All %>% remove_rownames %>% column_to_rownames(var="Gene")

#Change all values less than 1 into 1 and NAs to 1
All[All < 1 ] <- 1
All[is.na(All)] <- 1


#Create annotation file
All_anno <- data.frame(Sample_name=c("Sample_25", "Sample_26", "Sample_27", "Sample_28", "Sample_29", "Sample_30", "Sample_31", "Sample_32", "Sample_33", "Sample_34", "Sample_35", "Sample_36", "Sample_37", "Sample_38", "Sample_39", "Sample_40"),
                       Population=c("Alaska","Alaska","Alaska", "Alaska", "Norway", "Norway", "Norway", "Norway", "AlaskaxNorway","AlaskaxNorway","AlaskaxNorway", "AlaskaxNorway", "NorwayxAlaska", "NorwayxAlaska", "NorwayxAlaska", "NorwayxAlaska")
)
All_anno <- All_anno %>% remove_rownames %>% column_to_rownames(var="Sample_name")
All_anno$Ecotype <- factor(All_anno$Population)

#Run Deseq2 AxN
dds_All <- DESeqDataSetFromMatrix(countData = round(All),
                                  colData = All_anno,
                                  design = ~ Population)

dds_All$Ecotype <- relevel(dds_All$Population, ref="Alaska")
dds_All <- DESeq(dds_All)

dds_All <- DESeq(dds_All)

DESeq_All <- lfcShrink(dds_All, coef=2, type="apeglm")
DESeq_All <- DESeq_All[order(DESeq_All$log2FoldChange),] 

####PCA plot####
All_vst <- vst(dds_All, blind=TRUE)
All_pca_vst <- pca(assay(All_vst), metadata = colData(dds_All))

biplot(All_pca_vst, title = "Draba nivalis PCA vst")
