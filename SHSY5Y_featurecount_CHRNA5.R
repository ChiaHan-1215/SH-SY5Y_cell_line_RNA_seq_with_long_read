## Goal: Transform Featurecount result of CHRNA5 to table
## Date: 07242025
## User: ChiaHan

library(dplyr)
library(tidyr)
library(tidyverse)
library(reshape2)
library(ggplot2)


setwd('/Volumes/ifs/DCEG/Branches/LTG/Prokunina/CCLE and other RNA-seq Bam files/SH-SY5Y_short_read_RNA_seq_bams_hg38/Featurecount_CHRNA5_isoform/')

lsf <- list.files('.',pattern = '.jcounts')

# Iso Info
# the target isoform in C5

#chr15:78589849-78593092  R153_V416 Super-short
#chr15:78589982-78593092  Q197_V416 
#chr15:78590098-78593092  W236_V416 
#chr15:78590104-78593092	P238_V416 
#chr15:78590506-78593092  R372_V416 
#chr15:78590636-78593092  E415_V416 Full-length

# the PSAM4_C5 isoform 
# chr15.78546699.78580810 PSAM4_C5
# chr15.78565826.78580810 C5_intron1


df <- data.frame()



for (i in lsf){
  # i <- lsf[5]
  
  set1 <- read.delim(i)
  set1 <- set1 %>% filter(!is.na(PrimaryGene))
  set1 <- set1[,c(3,4,7,9)]
  set1 <- set1 %>% tibble::add_column(id=gsub('_fct.jcounts','',i),.before = 1)
  # filter region
  set1 <- set1 %>% filter(Site1_location > 78589827 & Site2_location < 78593182)
  set1$loc <- paste0(set1$Site1_chr,":",set1$Site1_location,"-",set1$Site2_location)
  set1$isoform <- recode(set1$loc,
                    `chr15:78589849-78593092` = "R153_V416",
                    `chr15:78589982-78593092`="Q197_V416",
                    `chr15:78590098-78593092`="W236_V416",
                    `chr15:78590104-78593092` = "P238_V416",
                    `chr15:78590506-78593092` = "R372_V416",
                    `chr15:78590636-78593092` = "E415_V416")
  
  set1 <- set1[,c(1,6,7,5)]
  names(set1)[4] <- "junction_count"
  
  df <- rbind(df,set1)

}


# remove otehrs noise
df_new <- df[!grepl("chr15:",df$isoform),]
wide <- dcast(df_new, id ~ isoform, value.var = "junction_count", fill = 0)
wide <- wide %>%
  mutate(iso_sum = rowSums(across(2:7)))


for (j in grep('V416',names(wide),value = T)){
  # j <- iso_id[2]
  wide[[paste0('Perc_',j)]] <- round(wide[[j]] / wide$iso_sum * 100,2)
}

wide$group <- gsub('SHSY5Y_|_[1-5]+','',wide$id)
wide_s <- wide[,c(1,9:15)]

# change to long

df_long <- melt(wide_s, id.vars = c("id", "group"), variable.name = "isoform", value.name = "jcount_ratio")


# Now do box dot plot 

ggplot(df_long, aes(x = isoform, y = jcount_ratio, fill = group)) +
  ## boxplots, one per (isoform × group)
  geom_boxplot(width = 0.8,                       # box width
               colour = "black", lwd = 0.3,       # black outline
               outlier.shape = NA,                # hide outliers
               position = position_dodge(width = 0.8)) +
  ## jittered dots, coloured & dodged by group
  geom_point(aes(colour = group),shape=21,colour='black',
             position = position_jitterdodge(dodge.width = 0.8,
                                             jitter.width = 0.05,
                                             jitter.height = 0.01,
                                             seed = 100),size = 1.2) +
  ## per-group medians (red points) sitting on their own boxes
  stat_summary(aes(colour = group), fun = median, geom = "point",
               shape = 20, size = 2,color="#FF0000",
               position = position_dodge(width = 0.8)) +
  scale_fill_manual(values = c("#00AFBB", "#F28D79")) +theme_bw()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

