## Historical marine biodiversity literature

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

### OBIS

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

### BHL

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

Languages

```
gawk -F"\t" '{a[$10]++}END{for (i in a){print i "\t" a[i]}}' title.txt | sort -n -k2
```
#### Summary

BHL hosts 170079 distinct titles assigned to 42212 distinct subjects to a total
65 million pages. 
From these items, the 144300 are published during the period 1472 - 1960. 

#### Queries


