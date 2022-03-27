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
we used separate scripts, written in AWK, for some statistics.

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



## Conclusions


