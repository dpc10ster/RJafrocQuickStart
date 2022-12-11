# (PART\*) Software details {-}

# Dataset object details {#dataset-object-details}

---
output:
  rmarkdown::pdf_document:
    fig_caption: yes        
---



## Introduction
* This vignette explains the data format of the input Excel file for an **ROC SPLIT-PLOT-A** dataset.
* The **A** refers to Table VII, part (a), in [@RN2508].
* In a SPLIT-PLOT-A dataset two distinct groups of readers interpret all cases in two modalities.
* The vignette is illustrated with a toy data file, `inst/extdata/toyFiles/FROC/frocSpA.xlsx` in which readers 1 and 2 interpret 10 cases in the first modality and readers 3 and 4 interpret the same cases in the second modality.
* The Excel file has three worksheets named `Truth`, `NL` (or `FP`) and `LL` (or `TP`). 

![](images/software-details/frocSpATruth.png){width=100%}

## The `Truth` worksheet 
* The `Truth` worksheet contains 6 columns: `CaseID`, `LesionID`, `Weight`, `ReaderID`, `ModalityID` and `Paradigm`. 
* The first five columns contain *twice* as many rows as there are distinct cases in the dataset. The factor of two is coming from the two modalities.
* The normal cases are numbered 6,7,8,9,10; the abnormal cases are numbered 16,17,18,19,20; i.e., `K1` = `K2` = 5 and `K` = 10. The number of rows of data is 2 * K = 20.
* The `ReaderID` field for the first modality has *two values* `1, 2` since readers 1 and 2 interpret all cases in the first modality. The corresponding values for the second modality are '3, 4'.
* `ModalityID`: The first modality is labeled `(4)` and the second is '(2)' . The parentheses follow standard statistical notation for nested factors. In the example readers '(1, 2)' are nested within treatment '(4)' and readers '(3, 4)' are nested within treatment '(2)'. The number of readers in each treatment can differ. At least two readers are needed in each treatment.
* `ReaderID`, the `ModalityID` are *text formatted labels*. 
* `Paradigm`: The contents of this field are `ROC` and `SPLIT-PLOT-A` (case insensitive). 

## The structure of the ROC split-plot-A dataset
This code-chunk reads the data into a split plot dataset: 


```r
frocSpA <- system.file("extdata", "toyFiles/FROC/frocSpA.xlsx",
                        package = "RJafroc", mustWork = TRUE)
x <- DfReadDataFile(frocSpA, newExcelFileFormat = TRUE)
str(x)
#> List of 3
#>  $ ratings     :List of 3
#>   ..$ NL   : num [1:2, 1:5, 1:11, 1:3] 1.5 -Inf 0.9 -Inf -Inf ...
#>   ..$ LL   : num [1:2, 1:5, 1:5, 1:4] 5 -Inf -Inf -Inf -Inf ...
#>   ..$ LL_IL: logi NA
#>  $ lesions     :List of 3
#>   ..$ perCase: int [1:5] 2 4 1 2 3
#>   ..$ IDs    : num [1:5, 1:4] 1 1 1 1 1 ...
#>   ..$ weights: num [1:5, 1:4] 0.5 0.25 1 0.5 0.333 ...
#>  $ descriptions:List of 7
#>   ..$ fileName     : chr "frocSpA"
#>   ..$ type         : chr "FROC"
#>   ..$ name         : logi NA
#>   ..$ truthTableStr: num [1:2, 1:5, 1:11, 1:5] 1 NA 1 NA NA 1 NA 1 NA 1 ...
#>   ..$ design       : chr "SPLIT-PLOT-A"
#>   ..$ modalityID   : Named chr [1:2] "4" "2"
#>   .. ..- attr(*, "names")= chr [1:2] "4" "2"
#>   ..$ readerID     : Named chr [1:5] "1" "2" "3" "4" ...
#>   .. ..- attr(*, "names")= chr [1:5] "1" "2" "3" "4" ...
```

* Flag `newExcelFileFormat` **must** be set to `TRUE` to the read split plot dataset. 
* The dataset object `x` is a `list` variable with 3 members: `x$ratings`, `x$lesions` and `x$descriptions`.
* There are `K2 = 5` diseased cases (the length of the third dimension of `ratings$LL`) and `K1 = 5` non-diseased cases (the length of the third dimension of `ratings$NL` minus `K2`). 
* `x$ratings$NL`, a [2, 4, 10, 1] array, contains the ratings of normal cases. 
* `x$ratings$LL`, a [2, 5, 5, 1] array, contains the ratings of abnormal cases.
* The `dataType` member is  which specifies the data collection method, `"ROC"` in this example. 
* The `x$modalityID` member is a vector with two elements `"4"` and `"2"`, naming the two modalities. 
* The `x$readerID` member is a vector with four elements `"1"`, `"2"`, `"3"`, `"4", labeling the four readers. 
* The `x$design` member is ; specifies the dataset design, "SPLIT-PLOT-A" for this example. 
* The `x$descriptions$truthTableStr` member quantifies the structure of the dataset, as explained next.

## The truthTableStr member 
* This is a `2 x 4 x 10 x 2` array, i.e., `I` x `J` x `K` x (maximum number of lesions per case plus 1). The `plus 1 ` is needed to accommodate normal cases. 
* Each entry in this array is either `1`, meaning the corresponding interpretation exists, or `NA`,  meaning the corresponding interpretation does not exist. 
* The first reader interprets the normal cases in the first modality only: 


```r
x$descriptions$truthTableStr[,1,1:10,1]
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]    1    1    1    1    1    1   NA   NA   NA    NA
#> [2,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA
```

* The first reader interprets the abnormal cases also in the first modality only: 


```r
x$descriptions$truthTableStr[,1,1:10,2]
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]   NA   NA   NA   NA   NA   NA    1    1    1     1
#> [2,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA
```

* Likewise for the second reader: 


```r
x$descriptions$truthTableStr[,2,1:10,1]
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]    1    1    1    1    1    1   NA   NA   NA    NA
#> [2,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA
x$descriptions$truthTableStr[,2,1:10,2]
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]   NA   NA   NA   NA   NA   NA    1    1    1     1
#> [2,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA
```

* The third reader interprets the cases in the second modality only: 


```r
x$descriptions$truthTableStr[,3,1:10,1]
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA
#> [2,]    1    1    1    1    1    1   NA   NA   NA    NA
x$descriptions$truthTableStr[,3,1:10,2]
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA
#> [2,]   NA   NA   NA   NA   NA   NA    1    1    1     1
```

* Likewise for the fourth reader: 


```r
x$descriptions$truthTableStr[,4,1:10,1]
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA
#> [2,]    1    1    1    1    1    1   NA   NA   NA    NA
x$descriptions$truthTableStr[,4,1:10,2]
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]   NA   NA   NA   NA   NA   NA   NA   NA   NA    NA
#> [2,]   NA   NA   NA   NA   NA   NA    1    1    1     1
```

## The false positive (FP) ratings
These are found in the `FP` or `NL` worksheet:

![](images/software-details/frocSpAFp.png){width=100%}

* The common vertical length is 20 in this example (1 modality times 4 readers times 5 non-diseased cases). 
* `ReaderID`: the reader labels: `1`, `2`, `3`, `4`, as declared in the `Truth` worksheet. 
* `ModalityID`: `4` or `2`, as declared in the `Truth` worksheet. 
* `CaseID`: `6`, `7`, `8`, `9`, or `10`, as declared in the `Truth` worksheet  
* `NL_Rating`: the ratings of non-diseased cases.



```r
x$ratings$NL[,1,1:10,1]
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,]  1.5  1.5  1.2  2.1  1.1  3.2  1.9    1  1.1     1
#> [2,] -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf  -Inf
```


## The true positive (TP) ratings
These are found in the `TP` or `LL` worksheet, see below.

![](images/software-details/frocSpATp.png){width=100%}

* This worksheet has the ratings of diseased cases. 
* The common vertical length is 20. 
* `ReaderID`: the reader labels: these must be from `1`, `2`, `3` or `4`, as declared in the `Truth` worksheet. 
* `ModalityID`: `4` or `2`, as declared in the `Truth` worksheet. 
* `CaseID`: `16`, `17`, `18`, `19`, or `20`, as declared in the `Truth` worksheet   
* `LL_Rating`: the ratings of diseased cases.
* The following shows that reader '1' interprets all abnormal cases in the first modality, while reader '3' interprets them in the second modality.


```r
x$ratings$LL[,1,1:5,1]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]    5  5.5  4.9    4  3.7
#> [2,] -Inf -Inf -Inf -Inf -Inf
x$ratings$LL[,3,1:5,1]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,] -Inf -Inf -Inf -Inf -Inf
#> [2,]  5.6  5.1  5.2  4.9  4.7
```

## References  
