Step 2 Population specific gene expression 

Make a folder /reference that contains the polished Alaska and Norway target sequences generated in step 2

Prepare the directories for all replicates which contains softlinks to the trimmed reads using make_map_dir.sh 
Map the trimmed reads to the polished target sequences using grid.bowtie_map.sh which runs bowtie_map.sh in each subdirectory

Extract read counts for each gene using grid.samstats.sh which runs samstats.sh in each subdirectory

Rename the counts.tsv files manually so that they contain the Sample number
Make a directory called '/Counts'
Make another directory called '/Merged_read_counts'

Prepare the read files for differential gene expression with Preparing_homozygous_reads.R 
These scripts do a number of things to prepare the files used for differential gene expression: With bowtie, reads were mapped to either the Alaska or Norway allele, which is removed and therefore read counts of the same gene are summated. 

Make a directory called /Output and run DESeq2 using DESeq2_homozygous_reads.R 
This produces MAplots, PCA, histogram

A population specific gene list is obtained with 'Generating_ecotype_specific_filter.R'
This script merges DESeq2 input + output
