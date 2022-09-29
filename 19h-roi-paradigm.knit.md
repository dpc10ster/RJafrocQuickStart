# ROI paradigm {#roi-paradigm}


---
title: "RJafroc Vignette 8: Analyzing data acquired according to the ROI paradigm"
author: "Dev P. Chakraborty, PhD"
date: "2022-09-29"
output: rmarkdown::html_vignette
bibliography: myRefs.bib
fig_caption: yes
fig.width: 4
vignette: >
  %\VignetteIndexEntry{Analyzing data acquired according to the ROI paradigm}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---
  


## Introduction
* In the region-of-interest (ROI) paradigm [@RN1233,@obuchowski2010data] each case is regarded as consisting of ${{Q}_{k}}$ (${{Q}_{k}}\ge 1$) "quadrants" or "regions-of-interest" or ROIs, where *k* is the case index ($k=1,2,...,K$) and $K$ is the total number of cases (i.e., case-level non-diseased plus case-level diseased cases). Each ROI needs to be classified, by the investigator, as either ROI-level-non-diseased (i.e., it has no lesions) or ROI-level-diseased (i.e., it has at least one lesion). **Note the distinction between case-level and ROI-level truth states.** One can have ROI-level non-diseased regions in a case-level diseased case. A case-level diseased case must contain at least one ROI-level diseased region and a case-level non-diseased case cannot have any ROI-level diseased regions.

* The observer gives a single rating (in fact an ordered label) to each ROI, denoted ${{R}_{kr}}$ ($r$ = 1, 2, ..., ${{Q}_{k}}$). Here $r$ is the ROI index and $k$ is the case index. The rating can be an integer or quasi- continuous (e.g., 0 – 100), or a floating point value, as long as higher numbers represent greater confidence in presence of one or more lesions in the ROI.

* The ROI paradigm is not restricted to 4 or even a constant number of ROIs per case. That is the reason for the *k* subscript in ${{Q}_{k}}$.

* The ROI data structure is a special case of the FROC data structure, the essential difference being that the number of ratings per case is an a-priori known value, equal to ${{Q}_{k}}$.

* ROI-level non-diseased region ratings are stored in the `NL` field and ROI-level diseased region ratings are stored in the `LL` field.  

* One can think of the ROI paradigm as similar to the FROC paradigm, but with localization accuracy restricted to belonging to a region (one cannot distinguish multiple lesions within a region). Unlike the FROC paradigm, a rating *is required* for every ROI.


## An example ROI dataset

An example simulated ROI dataset is included as `datasetROI`.
  

```r
str(datasetROI)
#> List of 3
#>  $ ratings     :List of 3
#>   ..$ NL   : num [1:2, 1:5, 1:90, 1:4] 0.95 0.927 0.556 0.805 1.421 ...
#>   ..$ LL   : num [1:2, 1:5, 1:40, 1:4] 1.57 2.31 2.3 2.34 2.34 ...
#>   ..$ LL_IL: logi NA
#>  $ lesions     :List of 3
#>   ..$ perCase: int [1:40] 2 3 2 2 3 3 1 2 3 3 ...
#>   ..$ IDs    : num [1:40, 1:4] 2 1 1 1 1 2 4 1 1 1 ...
#>   ..$ weights: num [1:40, 1:4] 0.5 0.333 0.5 0.5 0.333 ...
#>  $ descriptions:List of 7
#>   ..$ fileName     : chr "datasetROI"
#>   ..$ type         : chr "ROI"
#>   ..$ name         : chr "SIM-ROI"
#>   ..$ truthTableStr: logi NA
#>   ..$ design       : chr "FCTRL"
#>   ..$ modalityID   : Named chr [1:2] "1" "2"
#>   .. ..- attr(*, "names")= chr [1:2] "1" "2"
#>   ..$ readerID     : Named chr [1:5] "1" "2" "3" "4" ...
#>   .. ..- attr(*, "names")= chr [1:5] "1" "2" "3" "4" ...
datasetROI$ratings$NL[1,1,1,]
#> [1]  0.9498680 -0.0582497 -0.7763780  0.0120730
mean(datasetROI$ratings$NL[,,1:50,])
#> [1] 0.1014348
datasetROI$ratings$NL[1,1,51,]
#> [1] 1.01867 0.34710    -Inf    -Inf
datasetROI$lesions$perCase[1]
#> [1] 2
datasetROI$ratings$LL[1,1,1,]
#> [1] 1.56928 2.05945    -Inf    -Inf
x <- datasetROI$ratings$LL;mean(x[is.finite(x)])
#> [1] 1.815513
```
Examination of the output reveals that:

* This is a 2-treatment 5-reader dataset, with 50 non-diseased cases and 40 diseased cases, and ${{Q}_{k}}=4$ for all *k*.   

* For treatment 1, reader 1, case 1 (the 1st non-diseased case) the 4 ratings are 0.949868, -0.0582497, -0.776378, 0.012073. The mean of all ratings on non-diseased cases is 0.1014348.  

* For treatment 1, reader 1, case 51 (the 1st diseased case) the NL ratings are 1.01867, 0.3471. There are only two finite values because this case has two ROI-level-diseased regions, and 2 plus 2 makes for the assumed 4-regions per case. The corresponding `$lesionVector` field is 2.   
* The ratings of the 2 ROI-level-diseased ROIs on this case are 1.56928, 2.05945. The mean rating over all ROI-level-diseased ROIs is 1.8155127.  

## The ROI  Excel data file
An Excel file in JAFROC format containing simulated ROI data corresponding to `datasetROI`, is included with the distribution. The first command (below) finds the location of the file and the second command reads it and saves it to a dataset object `ds`. !!!DPC!!! 


