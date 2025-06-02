### Use FLAIR to determine Nanopore SH-SY5Y long read seq CHRNA3 isoform levels in con vs diff

#### Link:

https://flair.readthedocs.io/en/latest/

installation:

in CCAD2 environment

`conda install flair`

Steps:

- alignment

```
    ml minimap2/

    align sperated by control and differentiated fastqs files

    Control
    
    flair.py align -g ${REF} -r U1_PCS_109_2019_06_13_106_REVD.fastq.gz  U2_PCS_109_2019_06_13_106_REVD.fastq.gz\
 U3_PCS_109_2019_06_13_106_REVD.fastq.gz\
 --threads 12 --quality 30 

    Diff
    
    flair.py align -g ${REF} -r U1_PCS_109_2019_06_13_106_REVD.fastq.gz  U2_PCS_109_2019_06_13_106_REVD.fastq.gz  U3_PCS_109_2019_06_13_106_REVD.fastq.gz --threads 12 --quality 30 


```
