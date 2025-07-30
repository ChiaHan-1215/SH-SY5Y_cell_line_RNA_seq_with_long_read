# Using faturecount to count the jounction counts (similair to samishi plot in IGV)
# in ccad2 system
# BAMs: SHSY5Y RNA-seq BAMs
# saf file: a tab-seq bed file

# saf below:
# CHRNA5_iso	chr15	78588357	78593275	+

ml slurm/
ml subread/

for i in *.bam
do 

featureCounts -t 12  -a Featurecount_CHRNA5_isoform/C5_iso.saf -o Featurecount_CHRNA5_isoform/${i%.hg38.md.bam}_fct ${i} --splitOnly -J -F SAF -p --countReadPairs

done
