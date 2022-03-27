# Historical marine biodiversity literature

* [Introduction](#introduction)
* [OBIS](#obis)
* [BHL](#bhl)
* [Summary-BHL](#summary)
* [Marine-biodiversity-BHL](#marine-biodiversity-in-bhl)
* [Conclusions](#conclusions)

## Intoduction

This repository hosts scripts and queries in order to quantify the digitised
historical marine literature about biodiversity which hasn't been curated.

The goal is to provide a rough estimate of the work ahead towards the 
marine biodiversity document rescue.

The road to rescue data lies far ahead from digitisation which
still is the first crutial step. Three subsequent but equally hard tasks
remain. The transcription of the text in these documents, the 
recognition of the containing entities and their mapping to standardised
identifiers. 

Lastly, the publication of these data to public repositories, like OBIS 
and GBIF, is the last step for their rescue and their synthesis with 
current data.

## OBIS

OBIS aggragates data from medOBIS and eurOBIS among others. Is the 
realisation of the Census of Marine Life that originated at the late
90s. 

To download the full dataset of OBIS the command is the following:

```
wget https://obis-datasets.ams3.digitaloceanspaces.com/exports/obis_20220114.csv.zip
```

The data used here are `obis_20220114.csv.zip`. For more information
please visit [OBIS Data Access](https://obis.org/manual/access/)

The zipped file is about 8gb in size. For sake of speed and storage
we used separate scripts, written in AWK, for statistics.

Script [obis_occurrences_datasets.awk](https://github.com/savvas-paragkamian/historical-marine-literature/blob/main/scripts/obis_occurrences_datasets.awk)
returns a tab-separeted file with columns : year number_datasets number_occurrences.

So, our analysis showed that in OBIS there are 223 datasets that contain 1600038
in the period 1753-1960. 

Using the script [obis_taxonomy_summary.awk](https://github.com/savvas-paragkamian/historical-marine-literature/blob/main/scripts/obis_taxonomy_summary.awk)
we extract the phylum statistics of OBIS datasets before 1960.

```
phylum          number_species  occurrencies
Amoebozoa       1       1
Bigyra          1       1
Cryptophyta     3       629
Euglenozoa      3       35
Heliozoa        3       55
Xenacoelomorpha 3       3
Priapulida      4       483
Tardigrada      4       9
Phoronida       6       30
Acanthocephala  7       14
Entoprocta      11      49
Cercozoa        13      552
Kinorhyncha     14      35
Gastrotricha    15      55
Ctenophora      17      2809
Rotifera        20      3248
Hemichordata    29      255
Chaetognatha    39      6766
Radiozoa        43      1396
Brachiopoda     44      332
Sipuncula       59      482
Haptophyta      72      7987
Nemertea        95      737
Cyanobacteria   119     2550
Nematoda        126     318
Ciliophora      163     15619
Platyhelminthes 212     499
Myzozoa 488     113907
Ochrophyta      844     125818
Bryozoa 1036    8194
Foraminifera    1275    34453
Annelida        2284    27864
Porifera        2941    11220
Cnidaria        3357    43860
Echinodermata   3368    40842
Arthropoda      8816    252168
Mollusca        8993    101542
Chordata        10564   674700
no-phylum        1298    17034
```

## BHL

In order to amass the historical marine literature that is digitised we 
downloaded content from the Biodiversity Helitage Library.

Here are the data available for 
[download](https://about.biodiversitylibrary.org/tools-and-services/developer-and-data-tools/)

**We downloaded the data on 22/3/2022**
```
wget http://www.biodiversitylibrary.org/data/data.zip
```

From the schema and the BHL [data model](https://github.com/gbhl/bhl-us/tree/master/Documentation/DataModel) 
we perform searches on Title, Items and Subjects.
Items are the bound objects of BHL, so a title can have multiple items. 
The digitised document is the item. Additionaly, each title is assigned with
subjects. The are not standardised. Each Item also has a pages table with 
information per page.

In the BHL schema it is noted that :

> NOTE: This export DOES NOT include all of the pages in the BHL database.
> It only contains pages on which taxonomic names have been identified.

### Summary

**This chapter is about ALL BHL contents**

BHL hosts 170079 distinct titles assigned to 42212 distinct subjects to a total
65 million pages. 
From these items, the 144300 are published during the period 1472 - 1960. 

#### Languages of BHL

```
gawk -F"\t" '{a[$10]++}END{for (i in a){print i "\t" a[i]}}' title.txt | sort -n -k2
```
These are the languages with most titles:
```
RUS     133
DAN     171
SWE     232
POR     280
UND     290
JPN     334
DUT     346
ITA     733
SPA     751
CHI     894
LAT     2148
FRE     5448
GER     5845
ENG     142500
```

#### Digitisation efforts summarised per year

```
gawk -F"\t" '(NR>1){a=gensub(/^([0-9]{4})-(.+)/,"\\1","g", $16); year[a]++}END{for (i in year){print i "\t" year[i]}}' item.txt | sort -n -k1
```

```
Year    #Items
2006    1725
2008    24035
2009    45524
2010    14735
2011    10357
2012    13107
2013    13437
2014    31350
2015    16499
2016    20967
2017    26713
2018    19237
2019    13890
2020    12306
2021    11295
2022    3336
```
#### Taxa

The taxa and the year they where identified using text mining tools TaxonFinder and gnfinder.
```
gawk -F"\t" '(NR>1){a=gensub(/^([0-9]{4})-(.+)/,"\\1","g", $4); year[a]++}END{for (i in year){print i "\t" year[i]}}' pagename.txt
```

```
2007    3603082
2008    25597672
2009    30642203
2010    14481524
2011    9487431
2012    9508568
2013    20241807
2014    7269728
2015    6251942
2016    9055910
2017    7388412
2018    5203641
2019    6020302
2020    34752817
2021    2095996
2022    437725
```

### Marine biodiversity in BHL

We developed the script [bhl_search.awk](https://github.com/savvas-paragkamian/historical-marine-literature/blob/main/scripts/bhl_search.awk)
which outputs a tab-separated file with 9 fields:

```
itemID titleID item_year title subject taxa language pages BHL_upload
```

to run the script :

```
./scripts/bhl_search.awk bhl/Data/subject.txt bhl/Data/title.txt bhl/Data/item.txt bhl/Data/page.txt > bhl_search_results.txt
```
This searches for items (books, reports etc.) that either have a subject that 
contains the keyword *marine* or they contain in their title 
the keywords *marine*, *ocean*, *fisheries*, *sea*. 
In addition, all returned item are published before 1960.

This command on results summarises the subsequent statistics:
```
gawk -F"\t" '(NR>1 && $6>99){item[$1]=1; pages+=$8; lang[$7]++; year_bhl[$9]++}END{print length(item) RS pages; for (i in lang){print i FS lang[i]}; for (y in year_bhl){print y FS year_bhl[y]}}' bhl_search_results.txt
```

This search resulted in 1627 diffent items that contain at least 100 taxa as
identified automaticaly from [gnfinder of Global Names](https://globalnames.org).

These items have 648927 pages and 10 different languages, the 80% being English.

Languages summary:

```
language    number of items
JPN     1
POR     1
SWE     1
DUT     2
SPA     3
DAN     8
NOR     12
ITA     15
LAT     21
FRE     111
GER     153
ENG     1289
no-lang 10
```

The first datasets related to marine biodiversity was uploaded to BHL on 2008.

```
year    number of items
2008    431
2009    568
2010    87
2011    61
2012    114
2013    61
2014    32
2015    43
2016    66
2017    50
2018    79
2019    27
2020    2
2021    5
2022    1
```

## Conclusions

A lot of effort on the digitisation processes of these valuable and indespensable
documents has being realised. Yet the rescue of the marine biodiversity data 
of these documents is far from complete. As the resuts show  OBIS holds around 225 
datasets published before 1960 yet BHL holds more that 1600 digitised documents
containing more than 100 taxa. Of course there are many more datasets that are
still not digitised, thus remaining vulnurable to extiction. 
Hence, substantial effort is required to compile these data to public 
repositories like [OBIS](https://obis.org). The rescue process requires human 
curation, although current development of Information Extraction tools that 
facilitate Named Entity Recognition can accelarate this process.
