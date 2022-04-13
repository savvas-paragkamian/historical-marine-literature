#!/usr/bin/env Rscript
library(worrms)

# load the files
case_study <- read.delim("../dwca-mollusca_forbes-v1.9/occurrence.txt", sep="\t", header=T)
print("dimensions of the dataset")
print(dim(case_study))
case_study_taxa <- unique(case_study$scientificNameID)
print("taxa")
print(length(case_study_taxa))

# get the complete worms records for each id in order to perform statistics
case_study_aphiaID <- as.numeric(gsub("urn:lsid:marinespecies.org:taxname:", "", case_study_taxa))
worms_records <- lapply(case_study_aphiaID, wm_record)
