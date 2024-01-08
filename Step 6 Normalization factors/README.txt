Step 6 extracts library normalization factors for each replicate

Make a folder /reference that contains the polished Alaska and Norway target sequences generated in step 2
Prepare the directories for all replicates which contains softlinks to the trimmed reads using make_map_dir.sh

Count the mapped reads using grid.samstats.sh which runs samstats.sh in each subdirectory
Rename the counts.tsv files to their respective sample/replicate name using Rename_counts.sh

Proceed to the directory 'Normalization factors'

Copy all renamed counts.tsv files using copy.sh and remove unnecessary columns using Remove_column.sh
Prepare the files for the next step using prepare_heterozygous.sh which collates individual replicates in one file name
Extract Normalization factors using Normalization_factor.sh
Normalization factors need to be manually written inside AlaNor.model.tsv located in 'Step 8 Apply filter, normalization and statistics'
