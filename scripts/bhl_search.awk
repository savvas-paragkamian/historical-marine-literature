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
# usage: ./scripts/bhl_search.awk bhl/Data/subject.txt bhl/Data/title.txt \
#           bhl/Data/item.txt bhl/Data/page.txt > bhl_search_results.tsv
#
###############################################################################

BEGIN{
    
FS="\t"

IGNORECASE=1
#keywords: marine, sea, ocean, fisheries, fishery..
keywords["sea"]=1
keywords["marine"]=1
keywords["ocean"]=1
keywords["fisheries"]=1

}
# file subject.txt
(NR>1 && ARGIND==1){

    if ($2 ~ /marine/){
        subject_search[$1]=$2
    }
}
#file title.txt
(NR>1 && ARGIND==2){
    
    if ($8<1961 && $8!=""){
        year=$8
        title_year[$1]=$8

        if ($1 in subject_search){
            title_search[$1]=$4
            title_language[$1]=$10
        }
        
        else {
            split($4, title_words, " ")
            for (i in title_words){

                if (tolower(title_words[i]) in keywords){
                    title_search[$1]=$4
                    title_language[$1]=$10
                }
            }
        }
    }
}
#file item.txt, here store the items of each title in BHL. An Item can have 
# multiple title identifiers.
(NR>1 && ARGIND==3){
    if ($2 in title_search){
        items_search[$1]=$2
    }
}
#file page.txt, this is a big file.
(NR>1 && ARGIND==4){
    if ($2 in items_search){
        pages[$2]++
    }
}
END{

print "itemID" FS "titleID" FS "year" FS "title" FS "subject" FS "language" FS "pages"
    for (i in items_search){
    
        print i FS items_search[i] FS title_year[items_search[i]] FS title_search[items_search[i]] \
        FS subject_search[items_search[i]] FS title_language[items_search[i]] FS pages[i]

    }
}
