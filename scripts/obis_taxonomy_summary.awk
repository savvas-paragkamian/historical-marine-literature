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
# Columns used in the script:
# $8=year, $9=scientific name, $25=taxonomic rank
# $33 phylum name
#
(NR>1 && length($8)!=0 && $8<1961){

    if ($25=="Species"){

        species_name[$9]++ # count the occurrences
        # of scientific name of species
        phyla_species[$9]=$33 # keep the phylum of species
    }
}
END{

for (s in phyla_species){

    phyla[phyla_species[s]]++ # count species for each phylum
    phyla_occurrences[phyla_species[s]]+=species_name[s] #count occurrencies of
    # phylum species 

    }
    # print a file with fields: 
    # $1=phylum name, $2=number species, $3=number of species occurrencies
for (i in phyla){

        print i "\t" phyla[i] "\t" phyla_occurrences[i]

    }
}
