Step 7 applies filters, normalizations and statistics on the IRP output (Step 5)

This is done in three rounds

Round 1:

Collect all generated .tsv files from step 5 to this location and make sure that the normalization factors are included in AlaNor.model.tsv
Collect the generated filter list files (step 4) - Combined.genes.pass.filter

Make count files using make_count.sh
Perform filtering, normalization and statistics on informative reads using run_stats.sh



Round 2:

Collect all generated .tsv files from step 5 to this location and make sure that the normalization factors are included in AlaNor.model.tsv

Make count files using make_count.sh
Run filter_AlaNor.sh - to remove genes with less than 48 reads mapped (8 reads are pseudocounts)
Run filter_NorAla.sh - to remove genes with less than 48 reads mapped (8 reads are pseudocounts)
Run: rm AlaNor.counts.csv 
Run: rm NorAla.counts.csv 
Run: mv AlaNor.counts_res.csv AlaNor.counts.csv
Run: mv NorAla.counts_res.csv NorAla.counts.csv

Collect the generated filter list files (step 4) - Combined.genes.pass.filter

Perform filtering, normalization and statistics on informative reads using run_stats.sh


Round 3:

Collect all generated .tsv files from step 5 to this location and make sure that the normalization factors are included in AlaNor.model.tsv

Make count files using make_count.sh
Run filter_AlaNor.sh - to remove genes with less than 48 reads mapped (8 reads are pseudocounts)
Run filter_NorAla.sh - to remove genes with less than 48 reads mapped (8 reads are pseudocounts)
Run: rm AlaNor.counts.csv 
Run: rm NorAla.counts.csv 
Run: mv AlaNor.counts_res.csv AlaNor.counts.csv
Run: mv NorAla.counts_res.csv NorAla.counts.csv 

Collect the generated filter list files (step 4) - Combined.genes.pass.filter
Remove general seed coat genes from the Combined.genes.pass.filter file
Run: grep -v -F -f Dniva_GSC.csv Combined.genes.pass.filter > Combined.genes.pass.filter_No_GSC.csv
Run: rm Combined.genes.pass.filter
Run: mv Combined.genes.pass.filter_No_GSC.csv Combined.genes.pass.filter

Perform filtering, normalization and statistics on informative reads using run_stats.sh


The ouputs will be used in Step 8 Data analysis
