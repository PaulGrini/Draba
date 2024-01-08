# Generating ecotype specific filter lists and the raw data from which this was derived

library(tidyverse)
library(writexl)

#Read in count file
All <- read_tsv("All_counts_merged.tsv", col_names=TRUE)
names(All)[names(All) == "gene"] <- "Gene"

#Read in DeSEQ2 file
All_DESeq <- read.csv("Ala_vs_Nor.csv", header=TRUE)
names(All_DESeq)[names(All_DESeq) == "X"] <- "Gene"

#Combine count and deseq2
All_raw <- full_join(All, All_DESeq, by="Gene", copy=FALSE)

write_csv2(All_raw, "DeSeq2_results.csv")
#Remove all columns except counts, log2fc and adj-pval
All_raw <- All_raw[,c(1:9,11,14)]

#Remove all with Adj.pval under 0.05
All <- All_raw[which(All_raw$padj > 0.05),]
All <- All[,c(1)]

write_tsv(All, file = "Population_pass_filter.tsv")

