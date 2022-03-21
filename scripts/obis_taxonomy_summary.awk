#! /usr/bin/gawk -f
#
###############################################################################
# script name: obis_historical_data.awk
# developed by: Savvas Paragkamian
# framework: EMODnet Biology
###############################################################################
# GOAL:
# Aim of this script is to summarise the taxonomic content of OBIS of 
# historical data. The advantage of AWK here is that
# the dataset can remain in zipped format and also the low requirements of RAM.
###############################################################################
#
# usage: gunzip -c obis_20220114.csv.zip | ./obis_taxonomy_summary.awk - > \
#        obis_taxonomy_summary.tsv
#
###############################################################################

BEGIN{

FS=","

}
(NR>1 && length($8)!=0 && $8<1961){
species_name[$9]++ # scientific name of species as in WoRMS
phyla_species[$9]=$33 #33 column is phyla

}
END{

for (s in phyla_species){

    phyla[phyla_species[s]]++
    phyla_occurrences[phyla_species[s]]+=species_name[s]

    }

for (i in phyla){

        print i "\t" phyla[i] "\t" phyla_occurrences[i]

    }
}
