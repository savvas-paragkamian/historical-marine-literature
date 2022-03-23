#! /usr/bin/gawk -f
#
###############################################################################
# script name: bhl_search.awk
# developed by: Savvas Paragkamian
# framework: EMODnet Biology
###############################################################################
# GOAL:
# To perform search on the items and subjects of all BHL entities in order to
# estimate how many are related to marine biodiversity
###############################################################################
#
# usage: gunzip -c obis_20220114.csv.zip | ./obis_taxonomy_summary.awk - > \
#        obis_taxonomy_summary.tsv
#
###############################################################################

BEGIN{
    
FS="\t"

IGNORECASE=1

}
#file title.txt
(NR>1 && ARGIND==1){
    
    if ($8<1961 && $8!=""){
        year=$8
        title_year[$1]=$8
        
        if ($4 ~ /\s(marine|sea|ocean)\s/){

            title[$1]=$4

        }
    }
}
# file subject.txt
(NR>1 && ARGIND==2){
    if ($2 ~ /marine/ && ($1 in title_year)){
        subject[$1]=$2
    }
}
END{

for (t in title){
    print t "\t" title_year[t] "\t" title[t] "\t" subject[t]

    }
}
