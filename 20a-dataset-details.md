# (PART\*) Software details {-}

# Excel file and dataset details {#dataset-object-details}

---
output:
  rmarkdown::pdf_document:
    fig_caption: yes        
---



## Introduction
* This chapter is included to document recent Excel file format changes and the new dataset structure.
* We illustrate with a toy FROC data file in the `RJafroc` GitHub repository, `inst/extdata/toyFiles/FROC/frocCr.xlsx`, in which 3 readers interpret 3 non-diseased and 5 diseased cases using the FROC paradigm.
* The Excel file has three worksheets named `Truth`, `NL` (or `FP`) and `LL` (or `TP`). 

![](images/software-details/frocCrTruth.png){width=100%}

## The `Truth` worksheet 
* The `Truth` worksheet contains 6 columns: `CaseID`, `LesionID`, `Weight`, `ReaderID`, `ModalityID` and `Paradigm`. 
* The non-diseased cases are numbered 1,2,3; the diseased cases are numbered 70, 71, 72, 73, 74; i.e., `K1` = 3, `K2` = 5 and `K` = 8. 
* The `ReaderID` field has *three values* `0, 1, 2`.
* `ModalityID`: The first modality is labeled `0` and the second is '1'. 
* Note that `ReaderID` and `ModalityID` are *text formatted labels*. 
* `Paradigm`: The contents of this field are `FROC` and `FCTRL` (case insensitive, FCTRL stands for a factorial - or fully crossed - study design where each reader interprets all cases in all modalities). 

## The structure of the FROC factorial dataset
The following code reads the Excel file into a dataset object `x`: 


```r
frocCr <- system.file("extdata", "toyFiles/FROC/frocCr.xlsx",
                        package = "RJafroc", mustWork = TRUE)
x <- DfReadDataFile(frocCr, newExcelFileFormat = TRUE)
```

* Note that `newExcelFileFormat` **must** be set to `TRUE` to read the new Excel format dataset. The default is `FALSE` which applies to the old format Excel file with only the first three columns present in the `Truth` worksheet.

The structure of `x` is shown below.


```r
str(x)
#> List of 3
#>  $ ratings     :List of 3
#>   ..$ NL   : num [1:2, 1:3, 1:8, 1:2] 1.02 2.89 2.21 3.01 2.14 ...
#>   ..$ LL   : num [1:2, 1:3, 1:5, 1:3] 5.28 5.2 5.14 4.77 4.66 4.87 3.01 3.27 3.31 3.19 ...
#>   ..$ LL_IL: logi NA
#>  $ lesions     :List of 3
#>   ..$ perCase: int [1:5] 2 1 3 2 1
#>   ..$ IDs    : num [1:5, 1:3] 1 1 1 1 1 ...
#>   ..$ weights: num [1:5, 1:3] 0.3 1 0.333 0.1 1 ...
#>  $ descriptions:List of 7
#>   ..$ fileName     : chr "frocCr"
#>   ..$ type         : chr "FROC"
#>   ..$ name         : logi NA
#>   ..$ truthTableStr: num [1:2, 1:3, 1:8, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ design       : chr "FCTRL"
#>   ..$ modalityID   : Named chr [1:2] "0" "1"
#>   .. ..- attr(*, "names")= chr [1:2] "0" "1"
#>   ..$ readerID     : Named chr [1:3] "0" "1" "2"
#>   .. ..- attr(*, "names")= chr [1:3] "0" "1" "2"
```

* The dataset `x` is a `list` variable with 3 members: `x$ratings`, `x$lesions` and `x$descriptions`.
* There are `K2 = 5` diseased cases (the length of the third dimension of `x$ratings$LL`) and `K1 = 3` non-diseased cases (the length of the third dimension of `x$ratings$NL` minus `K2`). 
* `x$ratings$NL` is a [2, 3, 8, 2] array containing the NL ratings on non-diseased and diseased cases. 
* `x$ratings$LL` is a [2, 3, 5, 3] array containing the ratings of LLs on diseased cases.
* The maximum number of lesions per case in the dataset is 3.
* The number of lesions per diseased case is the vector `x$lesions$perCase`, i.e., 2, 1, 3, 2, 1 in this example.
* The `x$descriptions$dataType` member is FROC, which specifies the data collection method. 
* The `x$descriptions$modalityID` member is a vector with two elements 0, 1, naming the two modalities. 
* The `x$readerID` member is a vector with three elements 0, 1, 2, naming the three readers. 
* The `x$descriptions$design` member is FCTRL; specifies the study design. 
* The `x$descriptions$truthTableStr` member quantifies the structure of the dataset, explained next.

## The truthTableStr member 
* For this dataset `I` = 2, `J` = 3 and `K` = 8.
* `truthTableStr` is a `2 x 3 x 8 x 4` array, i.e., `I` x `J` x `K` x (maximum number of lesions per case plus 1). The `plus 1 ` is needed to accommodate non-diseased cases. 
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

