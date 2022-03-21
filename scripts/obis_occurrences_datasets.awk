#! /usr/bin/gawk -f
#
###############################################################################
# script name: obis_historical_data.awk
# developed by: Savvas Paragkamian
# framework: EMODnet Biology
###############################################################################
# GOAL:
# Aim of this script is to export the number of occurrence records of each OBIS
# dataset and the year of the publication. The advantage of AWK here is that
# the dataset can remain in zipped format and also the low requirements of RAM.
###############################################################################
#
# usage: gunzip -c obis_20220114.csv.zip | ./obis_occurrences_datasets.awk - > \
#        obis_dataset_year.tsv
#
###############################################################################

BEGIN{

FS=","

}
(NR>1 && length($8)!=0){
dataset_id_occurrences[$2]++
dataset_id_year[$2]=$8
}
END{
for (i in dataset_id_occurrences){

    print i "\t" dataset_id_occurrences[i] "\t" dataset_id_year[i]

    }
}
