# (PART\*) Software details {-}

# Excel file and dataset details {#dataset-object-details}

---
output:
  rmarkdown::pdf_document:
    fig_caption: yes        
---



## Introduction

* This chapter is included to document recent Excel file format changes and the new dataset structure.
* We illustrate with a toy FROC data file `images/software-details/frocCr.xlsx`, in which 3 readers interpret 3 non-diseased and 5 diseased cases using the FROC paradigm.
* The Excel file has three worksheets named `Truth`, `NL` (or `FP`) and `LL` (or `TP`). The names are case insensitive. 
* An image of the `Truth` worksheet follows.

![](images/software-details/frocCrTruth.png){width=100%}

## The `Truth` worksheet 

* It contains 6 columns: `CaseID`, `LesionID`, `Weight`, `ReaderID`, `ModalityID` and `Paradigm`. Excepting the first (header) row, the first three columns must contain numbers and the last three columns must be string formatted.
* The `CaseID` field: the non-diseased cases are numbered with integers: `1`, `2`, `3`; the diseased cases are numbered with integers `70`, `71`, `72`, `73`, `74`. It is evident that $K_1 = 3$, $K_2 = 5$ and $K = 8$. The values need not be sequential but they must be unique. 
* The `LesionID` field has *integers*: `0` denotes a non-diseased case, `1` denotes the first lesion on a diseased case, `2` denotes the second lesion on a diseased case, `3` denotes the third lesion on a diseased case. `CaseID` `1`, `2`, `3` are non-diseased cases; `CaseID` `70` is the first diseased case with two lesions, `CaseID` `71` is the second diseased case with one lesion, `CaseID` `72` is the third diseased case with three lesions, `CaseID` `73` is the fourth diseased case with two lesions and `CaseID` `74` is the fifth diseased case with one lesion.
* The `ReaderID` field has a string with *three character values* "0", "1", "2", i.e., `J` = 3.
* The `ModalityID` field has a string with *two character values* "0", "1", i.e., `I` = 2. 
* Note that `ReaderID` and `ModalityID` contain *text formatted labels*. 
* `Paradigm`: The contents of this field are two strings `FROC` and `FCTRL` (case insensitive, FCTRL stands for a factorial - or fully crossed - study design where each reader interprets all cases in all modalities). 

## The structure of a factorial ROC dataset object  {#dataset-object-details-structure-roc-dataset}




`x` is a `list` with 3 members: `ratings`, `lesions` and `descriptions`.



```r
str(x, max.level = 1)
#> List of 3
#>  $ ratings     :List of 3
#>  $ lesions     :List of 3
#>  $ descriptions:List of 7
```


The `x$ratings` member contains 3 sub-lists.


```r
str(x$ratings)
#> List of 3
#>  $ NL   : num [1:2, 1:5, 1:8, 1] 1 3 2 3 2 2 1 2 3 2 ...
#>  $ LL   : num [1:2, 1:5, 1:5, 1] 5 5 5 5 5 5 5 5 5 5 ...
#>  $ LL_IL: logi NA
```

* `x$ratings$NL`, with dimension [2, 5, 8, 1], contains the ratings of normal cases. The first dimension (2) is the number of treatments, the second (5) is the number of readers and the third (8) is the total number of cases. For ROC datasets the fourth dimension is always unity. The five extra values ^[With only 3 non-diseased cases why does one need 8 values?] in the third dimension, of `x$ratings$NL` which are filled with `NAs`, are needed for compatibility with FROC datasets.

* `x$ratings$LL`, with dimension [2, 5, 5, 1], contains the ratings of abnormal cases. The third dimension (5) corresponds to the 5 diseased cases.

* `x$ratings$LL_IL`, equal to NA', is there for compatibility with LROC data, `IL`  denotes incorrect-localizations.


The `x$lesions` member contains 3 sub-lists.



```r
str(x$lesions)
#> List of 3
#>  $ perCase: int [1:5] 1 1 1 1 1
#>  $ IDs    : num [1:5, 1] 1 1 1 1 1
#>  $ weights: num [1:5, 1] 1 1 1 1 1
```


* The `x$lesions$perCase` member is a vector with 5 ones representing the 5 diseased cases in the dataset. 

* The `x$lesions$IDs` member is an array with 5 ones.



```r
x$lesions$weights
#>      [,1]
#> [1,]    1
#> [2,]    1
#> [3,]    1
#> [4,]    1
#> [5,]    1
```

`x$lesions$weights` member is an array with 5 ones. These are irrelevant for ROC datasets. They are there for compatibility with FROC datasets.


`x$descriptions` contains 7 sub-lists.


```r
str(x$descriptions)
#> List of 7
#>  $ fileName     : chr "rocCr"
#>  $ type         : chr "ROC"
#>  $ name         : logi NA
#>  $ truthTableStr: num [1:2, 1:5, 1:8, 1:2] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ design       : chr "FCTRL"
#>  $ modalityID   : Named chr [1:2] "0" "1"
#>   ..- attr(*, "names")= chr [1:2] "0" "1"
#>  $ readerID     : Named chr [1:5] "0" "1" "2" "3" ...
#>   ..- attr(*, "names")= chr [1:5] "0" "1" "2" "3" ...
```


* `x$descriptions$fileName` is intended for internal use. 
* `x$descriptions$type` indicates that this is an `ROC` dataset. 
* `x$descriptions$name` is intended for internal use. 
* `x$descriptions$truthTableStr` is intended for internal use, see Section \@ref(dataset-object-truth-table-str).
* `x$descriptions$design` specifies the dataset design, which is "FCTRL" in the present example ("FCTRL" = a factorial dataset).
* `x$descriptions$modalityID` is a vector with two elements `"0"` and `"1"`, the names of the two modalities. 
* `x$readerID` is a vector with five elements  `"0"`, `"1"`, `"2"`, `"3"` and `"4"`, the names of the five readers. 



## The structure of a factorial FROC dataset {#dataset-object-details-structure-froc-dataset}

The following code reads the Excel file into a dataset object `x`: 


```r
x <- DfReadDataFile("images/software-details/frocCr.xlsx", newExcelFileFormat = TRUE)
```

* Note that `newExcelFileFormat` **must** be set to `TRUE` to read the new Excel format dataset. The default is `FALSE` which reads the original format Excel file with only the first three columns in the `Truth` worksheet.

The structure of `x` is shown below.


```r
str(x, max.level = 1)
#> List of 3
#>  $ ratings     :List of 3
#>  $ lesions     :List of 3
#>  $ descriptions:List of 7
```

* The dataset `x` is a `list` variable with 3 members: `x$ratings`, `x$lesions` and `x$descriptions`.


```r
str(x$ratings)
#> List of 3
#>  $ NL   : num [1:2, 1:3, 1:8, 1:2] 1.02 2.89 2.21 3.01 2.14 ...
#>  $ LL   : num [1:2, 1:3, 1:5, 1:3] 5.28 5.2 5.14 4.77 4.66 4.87 3.01 3.27 3.31 3.19 ...
#>  $ LL_IL: logi NA
```


* There are `K2 = 5` diseased cases (the length of the third dimension of `x$ratings$LL`) and `K1 = 3` non-diseased cases (the length of the third dimension of `x$ratings$NL` minus `K2`). 
* `x$ratings$NL` is a [2, 3, 8, 2] array containing the NL ratings on non-diseased and diseased cases. 
* `x$ratings$LL` is a [2, 3, 5, 3] array containing the ratings of LLs on diseased cases.
* `x$ratings$LL_IL` is `NA`, this field applies to an LROC dataset (contains incorrect localizations on diseased cases).


```r
str(x$lesions)
#> List of 3
#>  $ perCase: int [1:5] 2 1 3 2 1
#>  $ IDs    : num [1:5, 1:3] 1 1 1 1 1 ...
#>  $ weights: num [1:5, 1:3] 0.3 1 0.333 0.1 1 ...
```


* `x$lesions$perCase` is the number of lesions per diseased case vector, i.e., 2, 1, 3, 2, 1.
* `max(x$lesions$perCase)` is the maximum number of lesions per case, i.e., `r `max(x$lesions$perCase)`.
* `x$lesions$weights` is the weights of lesions.



```r
x$lesions$weights
#>           [,1]      [,2]      [,3]
#> [1,] 0.3000000 0.7000000      -Inf
#> [2,] 1.0000000      -Inf      -Inf
#> [3,] 0.3333333 0.3333333 0.3333333
#> [4,] 0.1000000 0.9000000      -Inf
#> [5,] 1.0000000      -Inf      -Inf
```


The weights for the first diseased case are 0.3 and 0.7. The weight for the second diseased case is 1. For the third diseased case the three weights are 1/3 each, etc. For each diseased case the finite weights sum to unity. 



```r
str(x$descriptions)
#> List of 7
#>  $ fileName     : chr "frocCr"
#>  $ type         : chr "FROC"
#>  $ name         : logi NA
#>  $ truthTableStr: num [1:2, 1:3, 1:8, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ design       : chr "FCTRL"
#>  $ modalityID   : Named chr [1:2] "0" "1"
#>   ..- attr(*, "names")= chr [1:2] "0" "1"
#>  $ readerID     : Named chr [1:3] "0" "1" "2"
#>   ..- attr(*, "names")= chr [1:3] "0" "1" "2"
```



* The `x$descriptions$filename` for internal use. 
* The `x$descriptions$type` member is FROC, which specifies the data collection method. 
* The `x$descriptions$name` for internal use. 
* The `x$descriptions$truthTableStr` member, for internal use, quantifies the structure of the dataset; it is explained in the next section.
* The `x$descriptions$design` member is FCTRL; it specifies the study design. 
* The `x$descriptions$modalityID` member is a vector with two elements 0, 1 naming the two modalities. 
* The `x$readerID` member is a vector with three elements 0, 1, 2 naming the three readers. 



## The truthTableStr member {#dataset-object-truth-table-str}

* For this dataset `I` = 2, `J` = 3 and `K` = 8.
* `truthTableStr` is a `2 x 3 x 8 x 4` array, i.e., `I` x `J` x `K` x (maximum number of lesions per case plus 1 - the `plus 1 ` is needed to accommodate non-diseased cases). 
* Each entry in this array is either `1`, meaning the corresponding interpretation happened, or `NA`, meaning the corresponding interpretation did not happen. 

### Explanation for non-diseased cases

Since the fourth index is set to 1, in the following code only non-diseased cases yield ones and all diseased cases yield `NA`. 


```r
all(x$descriptions$truthTableStr[,,1:3,1] ==1)
#> [1] TRUE
all(is.na(x$descriptions$truthTableStr[,,4:8,1]))
#> [1] TRUE
```


### Explanation for diseased cases with one lesion

Since the fourth index is set to 2, in the following code all non-diseased cases yield `NA` and all diseased cases yield 1 as all diseased cases have at least one lesion. 


```r
all(is.na(x$descriptions$truthTableStr[,,1:3,2]))
#> [1] TRUE
all(x$descriptions$truthTableStr[,,4:8,2] == 1)
#> [1] TRUE
```


### Explanation for diseased cases with two lesions

Since the fourth index is set to 3, in the following code all non-diseased cases yield `NA`; the first diseased case `70` yields 1 (this case contains two lesions); the second disease case `71` yields `NA` (this case contains only one lesion); the third disease case `72` yields `NA` (this case contains only two lesions); the fourth disease case `73` yields 1 (this case contains two lesions); the fifth disease case `74` yields `NA` (this case contains one lesion). 


```r
# all non diseased cases
all(is.na(x$descriptions$truthTableStr[,,1:3,3]))
#> [1] TRUE
# first diseased case
all(x$descriptions$truthTableStr[,,4,3] == 1)
#> [1] TRUE
# second diseased case
all(is.na(x$descriptions$truthTableStr[,,5,3]))
#> [1] TRUE
# third diseased case
all(x$descriptions$truthTableStr[,,6,3] == 1)
#> [1] TRUE
# fourth diseased case
all(x$descriptions$truthTableStr[,,7,3] == 1)
#> [1] TRUE
# fifth diseased case
all(is.na(x$descriptions$truthTableStr[,,8,3]))
#> [1] TRUE
```


### Explanation for diseased cases with three lesions

Since the fourth index is set to 4, in the following code all non-diseased cases yield `NA`; the first diseased case `70` yields `NA` (this case contains two lesions); the second disease case `71` yields `NA` (this case contains one lesion); the third disease case `72` yields `NA` (this case contains two lesions); the fourth disease case `73` yields 1 (this case contains three lesions); the fifth disease case `74` yields `NA` (this case contains one lesion). 


```r
# all non diseased cases
all(is.na(x$descriptions$truthTableStr[,,1:3,4]))
#> [1] TRUE
# first diseased case
all(is.na(x$descriptions$truthTableStr[,,4,4]))
#> [1] TRUE
# second diseased case
all(is.na(x$descriptions$truthTableStr[,,5,4]))
#> [1] TRUE
# third diseased case
all(x$descriptions$truthTableStr[,,6,4] == 1)
#> [1] TRUE
# fourth diseased case
all(is.na(x$descriptions$truthTableStr[,,7,4]))
#> [1] TRUE
# fifth diseased case
all(is.na(x$descriptions$truthTableStr[,,8,4]))
#> [1] TRUE
```


## The non-lesion localization (NL or FP) ratings

These are found in the `FP` or `NL` worksheet:

![](images/software-details/frocCrFp.png){width=100%}

* The common vertical length is 22 in this example. 
* `ReaderID`: the reader labels: `0`, 1`, `2`, as declared in the `Truth` worksheet. 
* `ModalityID`: the modality labels: `0` or `1`, as declared in the `Truth` worksheet. 
* `CaseID`: `1`, `2`, `3`, `71`, `72`, `73`, `74`, as declared in the `Truth` worksheet; note that not all cases have NL marks on them.  
* `NL_Rating`: the ratings of non-diseased cases.


## The lesion localization (LL or TP) ratings

These are found in the `TP` or `LL` worksheet, see below.

![](images/software-details/frocCrTp.png){width=100%}

* This worksheet has the ratings of diseased cases. 
* `ReaderID`: the reader labels: these must be from `0`, `1`, `2`, as declared in the `Truth` worksheet. 
* `ModalityID`: `0` or `1`, as declared in the `Truth` worksheet. 
* `CaseID`: these must be from `70`, `71`, `72`, `73`, `74`, as declared in the `Truth` worksheet; not all diseased cases have LL marks.   
* `LL_Rating`: the ratings of diseased cases.

