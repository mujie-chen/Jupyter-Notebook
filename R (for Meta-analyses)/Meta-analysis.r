# Make sure XQuartz is running

library(readxl)
Metadata <- read_excel("/Users/mujiechen/Jupyter-Notebook/R/Datasets/Metadata.xlsx")
View(Metadata)

library("meta")

m.cont <- metacont(n.e = Metadata$n1, mean.e = Metadata$m1, sd.e = Metadata$s1, n.c = Metadata$n2, mean.c = Metadata$m2, sd.c = Metadata$s2, studlab = Metadata$Study, data = Metadata, sm = "SMD", method.smd = "Hedges", common = FALSE, random = TRUE, title = ("SSRI versus placebo"))

summary(m.cont)

# Make notes for everything when revisiting this lecture
# Possibly shift to Jupyter Notebook?