Step 5 extracts informative reads from the marker lines

Make a folder /reference that contains the polished Alaska and Norway target sequences generated in step 2

Prepare the directories for all replicates which contains softlinks to the trimmed reads using make_map_dirs.sh
Map the trimmed reads to the polished target sequences using grid.bowtie_map.sh which runs bowtie_map.sh in each subdirectory
Extract and count informative read counts for each gene using grid.diff.sh which runs run_diff.sh in each subdirectory
The generated .tsv files will be further processed during step 8
