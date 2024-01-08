library(tidyverse)
library(ggpubr)
library("DESeq2")
library("ggplot2")
library(VennDiagram)

#Import reads
All <- read_tsv("All_counts_merged.tsv",col_names = TRUE)

#Generate a matrix with the first row and first column as column/row names
All <- All %>% remove_rownames %>% column_to_rownames(var="gene")
cts_All <- as.matrix(All[ , ]) 

#Import sample details
All_annotation <- read_csv2("Sample_annotation.csv")
All_annotation <- data.frame(All_annotation, row.names = 1)

#Boxplot of read count distribution per sample
boxplot(log2(cts_All + 1))

#Constructing a generic DESeq Dataset
dds_All <- DESeqDataSetFromMatrix(
  countData = cts_All,
  colData = All_annotation, 
  design= ~ Population)


#Differential expression analysis with Ala as reference
dds_All$Population <- relevel(dds_All$Population, ref="Nor")
dds_All <- DESeq(dds_All)
resultsNames(dds_All)

All_DESeq <- lfcShrink(dds_All, coef=2, type="apeglm")

#Export DESeq2 data
Ala_vs_Nor <- All_DESeq[order(All_DESeq$log2FoldChange),] 
#write.csv(as.data.frame(Ala_vs_Nor), file="Ala_vs_Nor.csv")

summary(All_DESeq, alpha = 0.05)

#Plot how related the samples are to eachother (PCAplot)
vstcounts <- vst(dds_All, blind=TRUE)
#pdf('PCA_Ala_vs_Nor.pdf')
plotPCA(vstcounts, intgroup=c("Population"))
#dev.off()

#Export MAplot
#Export MAplot with only a line at log2FC = 1
maplot_lfc1 <- ggmaplot(
  All_DESeq, 
  top=0,
  fdr = 0.05, fc = 2, size = 0.05, 
  palette = c("#B31B21", "#1465AC", "darkgray"), 
  xlab = "Log2 Mean Expression",  ylab="Log2 FC") +
  guides(colour = guide_legend(override.aes = list(size=2))) +
  theme(legend.position="top") +
  geom_hline(yintercept=c(-1,1), linetype="dotted") +
  annotate("text", x=0.2, y=1.5, label="log2FC = 1", size=2) +
  annotate("text", x=0.2, y=-0.5, label="log2FC = -1", size=2) + 
  scale_x_continuous(breaks = seq(0, 21, by= 2), limits=c(0, 21)) +
  scale_y_continuous(breaks = seq(-22, 22, by = 2), limits=c(-22, 22)) 

maplot_lfc1
#ggsave('Ala_vs_Nor_MAplot.pdf', width=10.6414, height=9, plot=maplot_lfc1, device = "pdf", dpi=1200)

##BARPLOT##
group <- c("UP", "DOWN", "NS")
values <- c(4318, 4123, 19412)

barplot(values, names.arg = group, ylim = c(0,20000))

#Histograms
All_DESeq_hist <- hist(All_DESeq$log2FoldChange, xlab = "Histogram of log2FC values of Homozygous dataset", ylab = "Number of genes", breaks = 20, xlim = c(-18,22), xaxt="n")
text(All_DESeq_hist$mids,All_DESeq_hist$counts,labels=All_DESeq_hist$counts, adj=c(0.5, -0.5))
axis(side=1, at=c(-18, -17, -16, -15, -14, -13, -12, -10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22))

