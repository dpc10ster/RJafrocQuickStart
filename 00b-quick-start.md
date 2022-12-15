# (PART\*) Quick Start {-}


# JAFROC ROC data format {#quick-start-data-format}





## TBA How much finished {#quick-start-data-format-how-much-finished} 

50% (remove duplication)



## Introduction {#quick-start-data-format-intro}

* The JAFROC Excel data format was adopted circa. 2006. The purpose of this chapter is to explain the format. 
<!-- * Reading this file into a dataset object suitable for `RJafroc` analysis is the subject of the next chapter.  -->
<!-- * Background on observer performance methods are in my book [@chakraborty2017observer]. -->
<!-- * I will start with Receiver Operating Characteristic (ROC) data [@metz1978rocmethodology] as this is by far the simplest paradigm. -->
<!-- * In the ROC paradigm the observer assigns a rating to each image. A rating is an ordered numeric label, and, in our convention, higher values represent greater certainty or **confidence level** for presence of disease. With human observers, a 5 (or 6) point rating scale is typically used, with 1 representing highest confidence for *absence* of disease and 5 (or 6) representing highest confidence for *presence* of disease. Intermediate values represent intermediate confidence levels for presence or absence of disease.  -->
<!-- * In the ROC paradigm location information, if applicable, associated with the disease, is not collected.  -->
<!-- * There is no restriction to 5 or 6 ratings. With algorithmic observers, e.g., computer aided detection (CAD) algorithms, the rating could be a floating point number and have infinite precision. All that is required is that higher values correspond to greater confidence in presence of disease - termed a *positive-directed* rating scale. If lower numbers correspond to greater confidence a transformation $R \rightarrow \max(R) - R + 1$, where $\max(R)$ is the maximum rating, over all readers, modalities and cases, will convert a negative-directed rating scale to a positive directed rating scale.  -->


## Note to existing users {#quick-start-data-format-note-to-existing-users}

* The Excel file format has recently undergone changes involving three additional columns in the `Truth` worksheet. The changes are needed for easier generalization to other data collection paradigms (e.g., split plot designs) and for better data entry error control.
* `RJafroc` will work with original format Excel files provided the `NewExcelFileFormat` flag is set to `FALSE`, the default. 
* Going forward, one should use the new format, described below, and use `NewExcelFileFormat = TRUE` to read the file.


## The Excel file {#quick-start-data-format-contents}

* The illustrations in this chapter correspond to Excel file `R/quick-start/rocCr.xlsx` in the project directory. See Section \@ref(#quick-start-index-how-to-access-files) for how to get this file, and all other files and code in this `bookdown` book, to your computer. This is a *toy file*, i.e., an artificial small dataset used to illustrate essential features of the data format. 
* The Excel file has three worksheets: `Truth`, `NL` (or `FP`) and `LL` (or `TP`). The worksheet names are case insensitive.

### The `Truth` worksheet {#quick-start-data-format-truth-worksheet}
![](images/quick-start/rocCrTruth.png){width=100%}

* The `Truth` worksheet contains 6 columns: `CaseID`, `LesionID`, `Weight`, `ReaderID`, `ModalityID` and `Paradigm`. 
* `CaseID`: **unique integers**, one per case, representing the cases in the dataset. In the current dataset, the non-diseased cases are labeled `1`, `2` and `3`, while the diseased cases are labeled `70`, `71`, `72`, `73` and `74`. The values do not have to be consecutive integers; they need not be ordered; the only requirement is that they be **unique integers**.
* `LesionID`: integers 0 or 1, with each 0 representing a non-diseased case and each 1 representing a diseased case. 
* `Weight`: this field is not used for ROC data. 
* `ReaderID`: a **comma-separated** string containing the reader labels, each represented by a **unique integer**, that have interpreted the case. In the example shown below each cell has the value `0, 1, 2, 3, 4` meaning that each of these readers has interpreted all cases. 
    + **With multiple readers each cell in this column has to be text formatted as otherwise Excel will not accept it.**
    + Select the worksheet, then `Format` - `Cells` - `Number` - `Text` - `OK`.
* `ModalityID`: a comma-separated string containing the modality labels, each represented by a **unique integer**. In the example each cell has the value `0, 1`. 
    + **With multiple modalities each cell has to be text formatted as otherwise Excel will not accept it.**
    + Format the cells as described above.
* `Paradigm`: this column contains two cells, `ROC` and `factorial`. It informs the software that this is an ROC dataset, and the design is factorial, meaning each reader has interpreted each case in each modality. 
* There are 5 diseased cases in the dataset (the number of 1's in the `LesionID` column of the `Truth` worksheet). 
* There are 3 non-diseased cases in the dataset (the number of 0's in the `LesionID` column).
* There are 5 readers in the dataset (each cell in the `ReaderID` column contains the string `0, 1, 2, 3, 4`).
* There are 2 modalities in the dataset (each cell in the `ModalityID` column contains the string `0, 1`).

### The false positive (FP) ratings {#quick-start-data-fp-worksheet}
These are found in the `FP` or `NL` worksheet, see below.

![](images/quick-start/rocCrFp.png){width=100%}

* It consists of 4 columns, each of length 30 (# of modalities X number of readers X number of non-diseased cases). 
* `ReaderID`: the reader labels: `0`, `1`, `2`, `3` and `4`. Each reader label occurs 6 times (# of modalities X number of non-diseased cases). 
* `ModalityID`: the modality or treatment labels: `0` and `1`. Each label occurs 15 times (# of readers X number of non-diseased cases). 
* `CaseID`: the case labels for non-diseased cases: `1`, `2` and `3`. Each label occurs 10 times (# of modalities X # of readers). 
* The label of a diseased case cannot occur in the FP worksheet. If it does the software generates an error. 
* `FP_Rating`: the floating point ratings of non-diseased cases. Each row of this worksheet contains a rating corresponding to the values of `ReaderID`, `ModalityID` and `CaseID` for that row.  

### The true positive (TP) ratings {#quick-start-data-format-tp-worksheet}
These are found in the `TP` or `LL` worksheet, see below.

![](images/quick-start/rocCrTp.png){width=100%}

* It consists of 5 columns, each of length 50 (# of modalities X number of readers X number of diseased cases). 
* `ReaderID`: the reader labels: `0`, `1`, `2`, `3` and `4`. Each reader label occurs 10 times (# of modalities X number of diseased cases). 
* `ModalityID`: the modality or treatment labels: `0` and `1`. Each label occurs 25 times (# of readers X number of diseased cases). 
* `LesionID`: For an ROC dataset this column contains fifty 1's (each diseased case has one lesion). 
* `CaseID`: the case labels for non-diseased cases: `70`, `71`, `72`, `73` and `74`. Each label occurs 10 times (# of modalities X # of readers). For an ROC dataset the label of a non-diseased case cannot occur in the TP worksheet. If it does the software generates an error. 
* `TP_Rating`: the floating point ratings of diseased cases. Each row of this worksheet contains a rating corresponding to the values of `ReaderID`, `ModalityID`, `LesionID` and `CaseID` for that row.   





## Reading the Excel file {#quick-start-read-datafile-structure-roc-dataset}

The following code reads the Excel file and saves it to object `x`.


```r
x <- DfReadDataFile("R/quick-start/rocCr.xlsx", newExcelFileFormat = TRUE)
```

* `newExcelFileFormat` is set to `TRUE` as otherwise columns D - F in the `Truth` worksheet are ignored and the dataset is assumed to be factorial, with `dataType` "automatically" determined from the contents of the FP and TP worksheets. ^[The assumptions underlying the "automatic" determination could be defeated by data entry errors.]

* Flag `newExcelFileFormat = FALSE`, the default, is for compatibility with the original JAFROC format Excel format, which did not have columns D - F in the `Truth` worksheet. Its usage is deprecated.

Most users will not need to be concerned with the internal structure of the dataset object `x`. For those interested in it, for my reference, and for ease of future maintenance of the software, this is deferred to Section \@ref(dataset-object-details-structure-roc-dataset).

## Correspondence between `NL` member of dataset and the `FP` worksheet {#quick-start-read-datafile-correspondence-nl-fp}

![](images/quick-start/rocCrFp.png){width=100%}

* The list member `x$ratings$NL` is an array with `dim = c(2,5,8,1)`. 
    + The first dimension (2) comes from the number of modalities. 
    + The second dimension (5) comes from the number of readers. 
    + The third dimension (8) comes from the **total** number of cases. 
    + The fourth dimension is always 1 for an ROC dataset. 
* The value of `x$ratings$NL[1,5,2,1]`, i.e., 5, corresponds to row 15 of the FP table, i.e., to `ModalityID` = 0, `ReaderID` = 4 and `CaseID` = 2.
* The value of `x$ratings$NL[2,3,2,1]`, i.e., 4, corresponds to row 24 of the FP table, i.e., to `ModalityID` 1, `ReaderID` 2 and `CaseID` 2.
* All values for case index > 3 and case index <= 8 are `-Inf`. For example the value of `x$ratings$NL[2,3,4,1]` is `-Inf`. This is because there are only 3 non-diseased cases. The extra length is needed for compatibility with FROC datasets.


## caseIndex vs. caseID {#quick-start-read-datafile-correspondence-case-index-vs-case-id}

* The `caseIndex` is the array index used to access elements in the NL and LL arrays. The case-index is always an integer in the range 1, 2, ..., up to the array length. Remember that unlike C++, R indexing starts from 1.
* The `caseID` is any integer value, including zero, used to uniquely label the cases.
* Regardless of what order they occur in the worksheet, the non-diseased cases are always ordered first. In the current example the case indices are 1, 2 and 3, corresponding to the three non-diseased cases with `caseIDs` equal to 1, 2 and 3.
* Regardless of what order they occur in the worksheet, in the NL array the diseased cases are always ordered *after* the last non-diseased case. In the current example the case indices in the `NL` array are 4, 5, 6, 7 and 8, corresponding to the five diseased cases with `caseIDs` equal to 70, 71, 72, 73, and 74. In the `LL` array they are indexed 1, 2, 3, 4 and 5. Some examples follow:
* `x$ratings$NL[1,3,2,1]`, a FP rating, refers to `ModalityID` 0, `ReaderID` 2 and `CaseID` 2 (since the modality and reader IDs start with 0).
* `x$ratings$NL[2,5,4,1]`, a FP rating, refers to `ModalityID` 1, `ReaderID` 4 and `CaseID` 70, the first diseased case; this is `-Inf`.
* `x$ratings$NL[1,4,8,1]`, a FP rating, refers to `ModalityID` 0, `ReaderID` 3 and `CaseID` 74, the last diseased case; this is `-Inf`.
* `x$ratings$NL[1,3,9,1]`, a FP rating, is an illegal value, as the third index cannot exceed 8.
* `x$ratings$NL[1,3,8,2]`, a FP rating, is an illegal value, as the fourth index cannot exceed 1 for an ROC dataset.
* `x$ratings$LL[1,3,1,1]`, a TP rating, refers to `ModalityID` 0, `ReaderID` 2 and `CaseID` 70, the first diseased case.
* `x$ratings$LL[2,5,4,1]`, a TP rating, refers to `ModalityID` 1, `ReaderID` 4 and `CaseID` 73, the fourth diseased case.

## Correspondence between `LL` member of dataset and the `TP` worksheet {#quick-start-read-datafile-correspondence-ll-tp}

![](images/quick-start/rocCrTp.png){width=100%}

* The list member `x$ratings$LL` is an array with `dim = c(2,5,5,1)`. 
    + The first dimension (2) comes from the number of modalities. 
    + The second dimension (5) comes from the number of readers. 
    + The third dimension (5) comes from the number of diseased cases. 
    + The fourth dimension is always 1 for an ROC dataset. 
* The value of `x$ratings$LL[1,1,5,1]`, i.e., 4, corresponds to row 6 of the TP table, i.e., to `ModalityID` = 0, `ReaderID` = 0 and `CaseID` = 74.
* The value of `x$ratings$LL[1,2,2,1]`, i.e., 3, corresponds to row 8 of the TP table, i.e., to `ModalityID` = 0, `ReaderID` = 1 and `CaseID` = 71.
* The value of `x$ratings$LL[1,4,4,1]`, i.e., 5, corresponds to row 21 of the TP table, i.e., to `ModalityID` = 0, `ReaderID` = 3 and `CaseID` = 74.
* The value of `x$ratings$LL[1,5,2,1]`, i.e., 2, corresponds to row 23 of the TP table, i.e., to `ModalityID` = 0, `ReaderID` = 4 and `CaseID` = 71.
* There are no `-Inf` values in `x$ratings$LL`: `any(x$ratings$LL == -Inf)` = FALSE. This is true for any ROC dataset.

