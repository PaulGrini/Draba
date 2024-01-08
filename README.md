<b>Low parental conflict, no endosperm hybrid barriers, and maternal bias in genomic imprinting in selfing Draba species</b>


Renate M. Alling1,2, Katrine N. Bjerkan1,2, Jonathan Bramsiepe1, Michael D. Nowak3, A. Lovisa S. Gustafsson3, Christian Brochmann3, Anne K. Brysting1,2 and Paul E. Grini1,4

1 Section for Genetics and Evolutionary Biology, University of Oslo, 0316 Oslo, Norway. 
2 CEES, Department of Biosciences, University of Oslo, 0316 Oslo, Norway. 
3 Natural History Museum, University of Oslo, 0318 Oslo, Norway
4 Corresponding author, paul.grini@ibv.uio.no

<br><br><br><br>
<b>For Supplementary Data Files, see directory "Supplementary Data Files Alling et al."</b>
<br><br><br><br>
<b>Supporting information for the analysis of imprinting in Draba nivalis. </b>

<b>Step 1</b>: Sequenced reads were trimmed with cutadapt version 1.18 (Martin, 2011) using TrimGalore version 0.6.2 (Krueger et al., 2012) with the following parameters --paired -j 6.
<br><br><b>Step 2</b>: Mapping was performed using bowtie2 version 2.3.5.1 (Langmead & Salzberg, 2012) with the parameters -- no-unal --no-mixed --no-discordant --sensitive --end-to-end --threads 4 -k 1. All subsequent mappings used the same parameters unless otherwise specified. Reads from homozygous crosses were initially mapped to primary transcripts of Draba nivalis Alaska separately (Nowak et al., 2020). Mapping results were used to integrate differences from each of the homozygous sequenced population-specific reads (Alaska and Norway) to the primary transcripts using Pilon version 1.23 --fix all --changes in 16 iterations (Walker et al., 2014). The final polished Alaska and Norway target sequences were concatenated in a single FASTA file.
<br><br><b>Step 3</b>: Reads from homozygous crosses were mapped separately to each population-specific FASTA of polished targets with bowtie2 -k 1. Read counts of genes mapped to the Alaska or Norway allele were summed per population + replicate. Differential gene expression analysis between read counts from Alaska and Norway was performed using DESeq2 version 1.32.0 (Love et al., 2014) and apeglm shrinkage version 1.14.0 (Zhu et al., 2019) in RStudio Version 2023.03.1+446 (RStudio Team, 2023). Differentially expressed genes were visualized with MAplots using ‘ggplot2’ version 3.3.4 (Wickham, 2016) and ‘ggpubr’ version 0.4.0 (Kassambara, 2023). Distribution of log2 fold change (FC) values were visualized using base R hist() function. 
<br><br><b>Step 4</b>: Reads from homozygous crosses were mapped separately to the Alaska and Norway polished targets with bowtie2 using the parameters --no-unal --no-mixed --no-discordant --sensitive --end-to- end --threads 4 -k 2. Reads with population-specific SNPs and/or indels - Informative reads (Hornslien et al., 2019; van Ekelenburg et al., 2023) - were extracted and used to determine which genes can be used for imprinting analysis. Genes with <5 fold mapping preference to the correct parent over the false parent were excluded from downstream analysis. 
<br><br><b>Step 5</b>: In order to obtain informative reads, reads were mapped separately to the Alaska and Norway polished targets using bowtie2 with the parameter -k 2. The Informative reads were extracted with the following requirements: The top two mappings of each read pair must be the same gene of the Alaska and Norway target sequence. Of those, a read pair is informative if: it maps identically to one allele target but not identically to the other; or if it maps indel-free to both alleles and the SNP count to one target sequence is half the SNP count of the other (e.g. 0 vs 1 SNP or 2 vs 5 SNPs); or if it maps to one allele indel-free with at most one SNP while having indels in the other.
<br><br><b>Step 6</b>: Library normalization factors for each biological replicate were determined directly after mapping separately to the Alaska and Norway polished targets using bowtie2 with the parameter -k 2. Mapped read counts per replicate were normalized by the average per replicate.
<br><br><b>Step 7</b>: After informative reads from heterozygous crosses were extracted, filters and normalization factors were applied. This was performed in three rounds.
<br>Round 1: Population-specific genes were removed using the Combined.genes.filter file and normalization factors added.
<br>Round 2: Population-specific genes were removed using the Combined.genes.filter file, genes with less than 48 reads (8 reads are pseudocounts) were removed and normalization factors added.
<br>Round 3: Population-specific genes (Combined.genes.filter), genes with less than 48 reads (8 reads are pseudocounts) and general seed coat genes with fold change of 4 (Hornslien et al., 2019) were removed and normalization factors added.
<br>Afterwards, the R limma package was utilized (Ritchie et al., 2015) to compute fold change and significance. In addition, maternal informative read counts were halved to compensate for the endosperm genotype of two maternal vs one paternal allele. Imprinted genes were identified by selecting for a log2FC < -1 (PEGs) / log2FC > 3 (MEGs) and adjusted p-value < 0.05.


<br>
<b>Supplementary Methods References</b>
<br><br>van Ekelenburg YS, Hornslien KS, Van Hautegem T, Fendrych M, Van Isterdael G, Bjerkan KN, Miller JR, Nowack MK, Grini PE. 2023. Spatial and temporal regulation of parent-of-origin allelic expression in the endosperm. Plant physiology 191: 986–1001.
<br><br>Hornslien KS, Miller JR, Grini PE. 2019. Regulation of Parent-of-Origin Allelic Expression in the Endosperm. Plant physiology 180: 1498 LP – 1519.
<br><br>Kassambara A. 2023. ggpubr: “ggplot2” Based Publication Ready Plots.
<br><br>Krueger FT, Seminowicz D, Goldapple K, Kennedy SH, Mayberg HS, Donegan NH, Sanislow CA, Blumberg HP, Fulbright RK, Lacadie C. 2012. Internet. GitHub Repository.
<br><br>Langmead B, Salzberg SL. 2012. Fast gapped-read alignment with Bowtie 2. Nature methods 9: 357–359.
L<br><br>ove MI, Huber W, Anders S. 2014. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome biology 15: 550.
<br><br>Martin M. 2011. Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet.journal; Vol 17, No 1: Next Generation Sequencing Data Analysis.
<br><br>Nowak MD, Birkeland S, Mandáková T, Roy Choudhury R, Guo X, Gustafsson ALS, Gizaw A, Schrøder-Nielsen A, Fracassetti M, Brysting AK, et al. 2020. The genome of Draba nivalis shows signatures of adaptation to the extreme environmental stresses of the Arctic. Molecular ecology resources n/a.
<br><br>Ritchie ME, Phipson B, Wu D, Hu Y, Law CW, Shi W, Smyth GK. 2015. limma powers differential expression analyses for RNA-sequencing and microarray studies. Nucleic acids research 43: e47–e47.
<br><br>RStudio Team. 2023. RStudio: Integrated Development Environment for R.
<br><br>Walker BJ, Abeel T, Shea T, Priest M, Abouelliel A, Sakthikumar S, Cuomo CA, Zeng Q, Wortman J, Young SK, et al. 2014. Pilon: An Integrated Tool for Comprehensive Microbial Variant Detection and Genome Assembly Improvement. PloS one 9: e112963.
<br><br>Wickham H. 2016. ggplot2: Elegant Graphics for Data Analysis.
<br><br>Zhu A, Ibrahim JG, Love MI. 2019. Heavy-tailed prior distributions for sequence count data: removing the noise and preserving large differences. Bioinformatics  35: 2084–2092.

