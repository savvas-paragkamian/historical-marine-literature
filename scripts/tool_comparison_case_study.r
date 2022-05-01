#!/usr/bin/env Rscript
library(worrms) # for API calls to WoRMS
library(obistools) # Quality control
library(EMODnetBiocheck) # Quality control

# load the files
case_study_event <- read.delim("../dwca-mollusca_forbes-v1.9/event.txt", sep="\t", header=T)
case_study_emof <- read.delim("../dwca-mollusca_forbes-v1.9/extendedmeasurementorfact.txt", sep="\t", header=T)
case_study <- read.delim("../dwca-mollusca_forbes-v1.9/occurrence.txt", sep="\t", header=T)
print("dimensions of the dataset")
print(dim(case_study))

# keep only the taxa IDs
case_study_taxa <- unique(case_study$scientificNameID)
print("taxa")
print(length(case_study_taxa))

# get the complete worms records for each id in order to perform statistics
case_study_aphiaID <- as.numeric(gsub("urn:lsid:marinespecies.org:taxname:", "", case_study_taxa))

# retrieve all data from WoRMS database of each taxon using function wm_record
worms_records <- lapply(case_study_aphiaID, wm_record)

## Merge the list to a dataframe
worms_records_d <- do.call(rbind, worms_records)

# count the ranks of each taxon
print("number of taxa of each rank")
table(worms_records_d[,8])


# Quality control
#loopcheckIPTdataset("http://ipt.medobis.eu/resource?r=mollusca_forbes", tree="yes")
IPTreport <- checkdataset(Occurrence = case_study, eMoF = case_study_emof) #Event = case_study_event)

#)

### debugging function checkdataset for the event

