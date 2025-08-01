### Use FLAIR to determine Nanopore SH-SY5Y long read seq CHRNA3 isoform levels in con vs diff

#### Link:

https://flair.readthedocs.io/en/latest/

installation:

in CCAD2 environment

`conda install flair`

Steps:

- alignment

```
#!/bin/bash


source ~/bin/myconda

ml minimap2


REF=../../references_Homo_sapiens_assembly38_noALT_noHLA_noDecoy.fasta


flair.py align -g ${REF} -r U1_PCS_109_2019_06_13_106_REVD.fastq.gz  U2_PCS_109_2019_06_13_106_REVD.fastq.gz  U3_PCS_109_2019_06_13_106_REVD.fastq.gz\
 --threads 12 --quality 30 && echo finned

mv flair.aligned.bed Untreated_SY5Y_aligned.bed

rm flair*

flair.py align -g ${REF} -r D1_PCS_109_2019_06_13_106_REVD.fastq.gz D2_PCS_109_2019_06_13_106_REVD.fastq.gz D3_PCS109_2019_06_17_106_REVD.fastq.gz\
 --threads 12 --quality 30 echo finned

mv flair.aligned.bed Differented_SY5Y_aligned.bed

rm flair*

```

Next do corrected, combined bed files and collpased

```
#!/bin/bash

source ~/bin/myconda
ml minimap2

REF=../../references_Homo_sapiens_assembly38_noALT_noHLA_noDecoy.fasta
GTF=../../gencode.v39.annotation.gtf

## Correct

flair.py correct -q Untreated_SY5Y_aligned.bed -f $GTF -g $REF && echo done
flair.py correct -q Differented_SY5Y_aligned.bed -f $GTF -g $REF && echo done

## Collapse

# combined two group bed file

cat Untreated_SY5Y_aligned.bed Differented_SY5Y_aligned.bed > combined_SY5Y_longread_align.bed

# collapse

flair.py collapse -g $REF --gtf $GTF -q combined_SY5Y_longread_align.bed\
 -r D1_PCS_109_2019_06_13_106_REVD.fastq.gz D2_PCS_109_2019_06_13_106_REVD.fastq.gz D3_PCS109_2019_06_17_106_REVD.fastq.gz U1_PCS_109_2019_06_13_106_REVD.fastq.gz\
 U2_PCS_109_2019_06_13_106_REVD.fastq.gz U3_PCS_109_2019_06_13_106_REVD.fastq.gz --stringent --check_splice --generate_map --annotation_reliant generate && echo finned


```



