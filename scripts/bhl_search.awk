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

#keywords: marine, sea, ocean, fisheries, fishery..
keywords["sea"]=1
keywords["marine"]=1
keywords["ocean"]=1
keywords["fisheries"]=1

}
# file subject.txt, $2 is the name of the subject and $1 is the titleID. 
# Multiple subjects can have the same subject.
(NR>1 && ARGIND==1){

    if (tolower($2) ~ /marine/){
        subject_search[$1]=$2
    }
}
# file title.txt. The $1 is the titleID, $3=title name, $8=year, $10=language
# In this file is the main search functionality.
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
# We parse this in order to use it later with the pages.
(NR>1 && ARGIND==3){
    if ($2 in title_search){
        items_search[$1]=$2
        #keep the year of upload to BHL
        creation_year=gensub(/^([0-9]{4})-(.+)/,"\\1","g", $16)
        year_BHL[$1]=creation_year
    }
}
#file page.txt, this is a big file.
# We parse this file to count the number of pages of each item.
(NR>1 && ARGIND==4){
    if ($2 in items_search){
        pages_id[$2][$1]
        page_item[$1]=$2
    }
}
(NR>1 && ARGIND==5){
    if ($3 in page_item){
        item_taxa[page_item[$1]][$2]=1
    }
}
END{

print "itemID" FS "titleID" FS "year" FS "title" FS "subject" FS "taxa_identified" \
      FS "language" FS "pages" FS "BHL_upload"

    for (i in items_search){
    
        print i FS items_search[i] FS title_year[items_search[i]] FS title_search[items_search[i]] \
            FS subject_search[items_search[i]] FS length(item_taxa[i]) FS title_language[items_search[i]] \
            FS length(pages_id[i]) FS year_BHL[i]

    }
}
