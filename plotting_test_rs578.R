library(dplyr)
library(tximport)
library(tidyr)
library(ggplot2)

#
# Plot the SNPs rs578776 in CHRNA3 to see if allelic imbalance exist
# Date: 06092025

# Read counts at the rs578776 position in RNA-seq BAM files were obtained using IGV
df <- data.frame(
  sample_ID=c(paste0('SH_SY5Y_U_',seq(1:5)),paste0('SH_SY5Y_D_',seq(1:5))),
  read_A=c(689,840,727,783,606,1356,1046,1493,545,1010),
  read_G=c(710,972,804,803,614,1114,930,1193,514,878),
  total=c(1400,1813,1531,1587,1220,2474,1980,2687,1060,1889)
)

df$frac_A <- round(df$read_A/df$total * 100,2)
df$frac_G <- round(df$read_G/df$total * 100,2)


df_plot <- df %>%
  # 1. pivot the A/G reads into allele + reads columns
  pivot_longer(
    cols      = c(read_A, read_G),
    names_to  = "allele",
    values_to = "reads"
  ) %>%
  mutate(
    allele   = if_else(allele == "read_A", "A", "G"),
    fraction = reads / total,
    # 3. build your x‐axis label with sample and total reads
    label    = paste0(sample_ID, "\nTotal: ", total)
  )


wanted_order <- c(
paste0("SH_SY5Y_U_", 1:3), paste0("SH_SY5Y_D_", 1:3) )

# change plot order
df_plot <- df_plot %>% mutate(sample_ID = factor(sample_ID, levels = wanted_order))

# plotting
ggplot(df_plot, aes(x = label, y = fraction, fill = allele)) +
  geom_col(position = "dodge", color = "black", na.rm = TRUE) +
  geom_text(aes(label = reads, group = allele),
            position = position_dodge(width = 0.9),
            vjust    = -0.3, size = 3) +
  scale_fill_manual(values = c("A" = "#FBB4AE", "G" = "#B3CDE3")) +
  scale_y_continuous(labels = scales::percent_format(1),
                     expand = expansion(mult = c(0, .1)),
                     limits = c(0, 1.05)) +
  facet_wrap(~ sample_ID, scales = "free_x", ncol = 3) +
  theme_classic() +
  theme(
    axis.text.x     = element_text(angle = 45, hjust = 1, size = 8),
    panel.border    = element_rect(color = "black", fill = NA, size = 0.5),
    strip.text      = element_text(face = "bold"),
    legend.title    = element_blank(),
    plot.margin     = margin(l = 15, t = 5, r = 5, b = 5, unit = "pt")
  ) +
  labs(
    x     = NULL,
    y     = "Allele fraction",
    title = "Allelic fractions of rs578776 in SH-SY5Y cell"
  )
