#This R script merges all individual tsv files for homozygous reads with read counts together

library(tidyverse)

#Import reads
#Combine all replicates in one table
Ala_25_BR1 <- read_tsv("Ala_BR1_count.tsv",col_names = TRUE)
Ala_26_BR2 <- read_tsv("Ala_BR2_count.tsv",col_names = TRUE)
Ala_27_BR3 <- read_tsv("Ala_BR3_count.tsv",col_names = TRUE)
Ala_28_BR4 <- read_tsv("Ala_BR4_count.tsv",col_names = TRUE)
Nor_29_BR1 <- read_tsv("Nor_BR1_count.tsv",col_names = TRUE)
Nor_30_BR2 <- read_tsv("Nor_BR2_count.tsv",col_names = TRUE)
Nor_31_BR3 <- read_tsv("Nor_BR3_count.tsv",col_names = TRUE)
Nor_32_BR4 <- read_tsv("Nor_BR4_count.tsv",col_names = TRUE)

#Remove indel-free and spliced columns
Ala_25_BR1$`indel-free` <- NULL
Ala_25_BR1$spliced <- NULL

Ala_26_BR2$`indel-free` <- NULL
Ala_26_BR2$spliced <- NULL

Ala_27_BR3$`indel-free` <- NULL
Ala_27_BR3$spliced <- NULL

Ala_28_BR4$`indel-free` <- NULL
Ala_28_BR4$spliced <- NULL

Nor_29_BR1$`indel-free` <- NULL
Nor_29_BR1$spliced <- NULL

Nor_30_BR2$`indel-free` <- NULL
Nor_30_BR2$spliced <- NULL

Nor_31_BR3$`indel-free` <- NULL
Nor_31_BR3$spliced <- NULL

Nor_32_BR4$`indel-free` <- NULL
Nor_32_BR4$spliced <- NULL


#Split Ala and Nor
#Filter all reads mapped to a Ala or Nor gene
Ala_25 <- Ala_25_BR1 %>% filter(grepl("Alaska", allele))
Nor_25 <- Ala_25_BR1 %>% filter(grepl("Norway", allele))

Ala_26 <- Ala_26_BR2 %>% filter(grepl("Alaska", allele))
Nor_26 <- Ala_26_BR2 %>% filter(grepl("Norway", allele))

Ala_27 <- Ala_27_BR3 %>% filter(grepl("Alaska", allele))
Nor_27 <- Ala_27_BR3 %>% filter(grepl("Norway", allele))

Ala_28 <- Ala_28_BR4 %>% filter(grepl("Alaska", allele))
Nor_28 <- Ala_28_BR4 %>% filter(grepl("Norway", allele))

Ala_29 <- Nor_29_BR1 %>% filter(grepl("Alaska", allele))
Nor_29 <- Nor_29_BR1 %>% filter(grepl("Norway", allele))

Ala_30 <- Nor_30_BR2 %>% filter(grepl("Alaska", allele))
Nor_30 <- Nor_30_BR2 %>% filter(grepl("Norway", allele))

Ala_31 <- Nor_31_BR3 %>% filter(grepl("Alaska", allele))
Nor_31 <- Nor_31_BR3 %>% filter(grepl("Norway", allele))

Ala_32 <- Nor_32_BR4 %>% filter(grepl("Alaska", allele))
Nor_32 <- Nor_32_BR4 %>% filter(grepl("Norway", allele))

#Remove the column which specifies Col or Tsu
Ala_25$allele <- NULL
Ala_26$allele <- NULL
Ala_27$allele <- NULL
Ala_28$allele <- NULL
Ala_29$allele <- NULL
Ala_30$allele <- NULL
Ala_31$allele <- NULL
Ala_32$allele <- NULL

Nor_25$allele <- NULL
Nor_26$allele <- NULL
Nor_27$allele <- NULL
Nor_28$allele <- NULL
Nor_29$allele <- NULL
Nor_30$allele <- NULL
Nor_31$allele <- NULL
Nor_32$allele <- NULL

#Rename the column with number of read count to the specific ecotype
names(Ala_25)[names(Ala_25) == "pairs"] <- "Ala_25"
names(Ala_26)[names(Ala_26) == "pairs"] <- "Ala_26"
names(Ala_27)[names(Ala_27) == "pairs"] <- "Ala_27"
names(Ala_28)[names(Ala_28) == "pairs"] <- "Ala_28"
names(Ala_29)[names(Ala_29) == "pairs"] <- "Ala_29"
names(Ala_30)[names(Ala_30) == "pairs"] <- "Ala_30"
names(Ala_31)[names(Ala_31) == "pairs"] <- "Ala_31"
names(Ala_32)[names(Ala_32) == "pairs"] <- "Ala_32"

names(Nor_25)[names(Nor_25) == "pairs"] <- "Nor_25"
names(Nor_26)[names(Nor_26) == "pairs"] <- "Nor_26"
names(Nor_27)[names(Nor_27) == "pairs"] <- "Nor_27"
names(Nor_28)[names(Nor_28) == "pairs"] <- "Nor_28"
names(Nor_29)[names(Nor_29) == "pairs"] <- "Nor_29"
names(Nor_30)[names(Nor_30) == "pairs"] <- "Nor_30"
names(Nor_31)[names(Nor_31) == "pairs"] <- "Nor_31"
names(Nor_32)[names(Nor_32) == "pairs"] <- "Nor_32"

#Combine the two ecotypes
Ala_25_BR1 <- full_join(Ala_25, Nor_25, by="gene", copy=FALSE)
Ala_26_BR2 <- full_join(Ala_26, Nor_26, by="gene", copy=FALSE)
Ala_27_BR3 <- full_join(Ala_27, Nor_27, by="gene", copy=FALSE)
Ala_28_BR4 <- full_join(Ala_28, Nor_28, by="gene", copy=FALSE)
Nor_29_BR1 <- full_join(Ala_29, Nor_29, by="gene", copy=FALSE)
Nor_30_BR2 <- full_join(Ala_30, Nor_30, by="gene", copy=FALSE)
Nor_31_BR3 <- full_join(Ala_31, Nor_31, by="gene", copy=FALSE)
Nor_32_BR4 <- full_join(Ala_32, Nor_32, by="gene", copy=FALSE)

#Set NA to 0
Ala_25_BR1[is.na(Ala_25_BR1)] <- 0
Ala_26_BR2[is.na(Ala_26_BR2)] <- 0
Ala_27_BR3[is.na(Ala_27_BR3)] <- 0
Ala_28_BR4[is.na(Ala_28_BR4)] <- 0
Nor_29_BR1[is.na(Nor_29_BR1)] <- 0
Nor_30_BR2[is.na(Nor_30_BR2)] <- 0
Nor_31_BR3[is.na(Nor_31_BR3)] <- 0
Nor_32_BR4[is.na(Nor_32_BR4)] <- 0


#Combine Alaska and Norway for each gene, these are homozygous, so does not make sense anyways
Ala_25_BR1 <- cbind(Ala_25_BR1, Ala_25_BR1=rowSums(Ala_25_BR1[,2:3]))
Ala_25_BR1$Ala_25 <- NULL
Ala_25_BR1$Nor_25 <- NULL

Ala_26_BR2 <- cbind(Ala_26_BR2, Ala_26_BR2=rowSums(Ala_26_BR2[,2:3]))
Ala_26_BR2$Ala_26 <- NULL
Ala_26_BR2$Nor_26 <- NULL

Ala_27_BR3 <- cbind(Ala_27_BR3, Ala_27_BR3=rowSums(Ala_27_BR3[,2:3]))
Ala_27_BR3$Ala_27 <- NULL
Ala_27_BR3$Nor_27 <- NULL

Ala_28_BR4 <- cbind(Ala_28_BR4, Ala_28_BR4=rowSums(Ala_28_BR4[,2:3]))
Ala_28_BR4$Ala_28 <- NULL
Ala_28_BR4$Nor_28 <- NULL

Nor_29_BR1 <- cbind(Nor_29_BR1, Nor_29_BR1=rowSums(Nor_29_BR1[,2:3]))
Nor_29_BR1$Ala_29 <- NULL
Nor_29_BR1$Nor_29 <- NULL

Nor_30_BR2 <- cbind(Nor_30_BR2, Nor_30_BR2=rowSums(Nor_30_BR2[,2:3]))
Nor_30_BR2$Ala_30 <- NULL
Nor_30_BR2$Nor_30 <- NULL

Nor_31_BR3 <- cbind(Nor_31_BR3, Nor_31_BR3=rowSums(Nor_31_BR3[,2:3]))
Nor_31_BR3$Ala_31 <- NULL
Nor_31_BR3$Nor_31 <- NULL

Nor_32_BR4 <- cbind(Nor_32_BR4, Nor_32_BR4=rowSums(Nor_32_BR4[,2:3]))
Nor_32_BR4$Ala_32 <- NULL
Nor_32_BR4$Nor_32 <- NULL



All <- list(Ala_25_BR1, Ala_26_BR2, Ala_27_BR3, Ala_28_BR4, Nor_29_BR1, Nor_30_BR2, Nor_31_BR3, Nor_32_BR4)
All <- All %>% reduce(full_join, by='gene')
All[is.na(All)] <- 0
All <- All[order(All$gene),]
rownames(All) <- 1:nrow(All)

write_tsv(All, "All_counts_merged.tsv")

