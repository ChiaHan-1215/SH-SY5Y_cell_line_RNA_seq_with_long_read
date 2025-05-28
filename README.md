Goal:

The data is from paper: https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-021-08261-2#availability-of-data-and-materials
Download the short read and naopore long-read RNA-seq SH-SY5Y cell line for futher analysis.

Data:

fastq files location: in European Nucleotide Archive (ENA, short reads: PRJEB44501, long reads: PRJEB44502)

BAM files in T-drive Mila's lab.


Code:

short read:
  STAR align 
  salmon quantifiy isoform TPM

  

long read:
  Minimap2
  flair 
