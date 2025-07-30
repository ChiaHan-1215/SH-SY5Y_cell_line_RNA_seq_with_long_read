### Goal:

The data is from paper: https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-021-08261-2#availability-of-data-and-materials.

fastq files location: in European Nucleotide Archive (ENA, short reads: PRJEB44501, long reads: PRJEB44502).

Download the 3 replicates of short read RNA-seq and long-read naopore cDNA seq of SH-SY5Y cell line for futher analysis.

Data:

fastq files location: in European Nucleotide Archive (ENA, short reads: PRJEB44501, long reads: PRJEB44502)

BAM files in T-drive Mila's lab
  - Long-read: `/ifs/DCEG/Branches/LTG/Prokunina/Long_read_RNA-seq_hg38/SH-SY5Y_nanopore_RNA-seq_bams`
  - short-read: `/ifs/DCEG/Branches/LTG/Prokunina/CCLE and other RNA-seq Bam files/SH-SY5Y_short_read_RNA_seq_bams_hg38`


### Code:

short read:

  STAR align 
  
  salmon quantifiy isoform TPM by textimport


  
  `plotting_test_rs578.R`: plotting target SNP read count ratio to detect allelic imbalance.

  `Featurecount_junction_count.sh` Featurecount script for counting junction reads. 
  
  `SHSY5Y_featurecount_CHRNA5.R`: plotting featurecount result of CHRNA5 isoform junction counts.
  

long read:
  `minimap2_align.swarm`: The swarm file for aligning Nanopre long-read cDNA to hg38 using minimap2 with samtools to output sorted BAM files
  `flair` :  the scirtpt to run flair to deteting isoform  

