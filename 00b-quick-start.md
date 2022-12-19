# (PART\*) Quick Start {-}


# JAFROC ROC data {#quick-start-roc}





## How much finished {#quick-start-roc-how-much-finished} 

50% (remove duplication)



## Introduction {#quick-start-roc-intro}

* The JAFROC Excel data format was adopted circa. 2006. The purpose of this chapter is to explain the format of this file. 
<!-- * Reading this file into a dataset object suitable for `RJafroc` analysis is the subject of the next chapter.  -->
<!-- * Background on observer performance methods are in my book [@chakraborty2017observer]. -->
<!-- * I will start with Receiver Operating Characteristic (ROC) data [@metz1978rocmethodology] as this is by far the simplest paradigm. -->
<!-- * In the ROC paradigm the observer assigns a rating to each image. A rating is an ordered numeric label, and, in our convention, higher values represent greater certainty or **confidence level** for presence of disease. With human observers, a 5 (or 6) point rating scale is typically used, with 1 representing highest confidence for *absence* of disease and 5 (or 6) representing highest confidence for *presence* of disease. Intermediate values represent intermediate confidence levels for presence or absence of disease.  -->
<!-- * In the ROC paradigm location information, if applicable, associated with the disease, is not collected.  -->
<!-- * There is no restriction to 5 or 6 ratings. With algorithmic observers, e.g., computer aided detection (CAD) algorithms, the rating could be a floating point number and have infinite precision. All that is required is that higher values correspond to greater confidence in presence of disease - termed a *positive-directed* rating scale. If lower numbers correspond to greater confidence a transformation $R \rightarrow \max(R) - R + 1$, where $\max(R)$ is the maximum rating, over all readers, modalities and cases, will convert a negative-directed rating scale to a positive directed rating scale.  -->


## Note to existing users {#quick-start-roc-note}

* The Excel file format has recently undergone changes involving three additional columns in the `Truth` worksheet. The changes are needed for easier generalization to other data collection paradigms (e.g., split plot designs) and for better data entry error control.
* `RJafroc` will work with original format Excel files provided the `NewExcelFileFormat` flag is set to `FALSE`, the default. 
* Going forward, one should use the new format, described below, and use `NewExcelFileFormat = TRUE` to read the file.


## Excel ROC file format {#quick-start-roc-excel}

* The illustrations in this chapter correspond to Excel file `R/quick-start/rocCr.xlsx` in the project directory. See Section \@ref(#quick-start-index-how-to-access-files) for how to get this file, and all other files and code in this `bookdown` book, to your computer. 
* This is a *toy file*, i.e., an artificial small dataset used to illustrate essential features of the data format. 
* The Excel file has three worksheets: `Truth`, `NL` (or `FP`) and `LL` (or `TP`). The worksheet names are case insensitive.

![](images/quick-start/rocCrTruth.png){width=100%}

### The `Truth` worksheet {#quick-start-roc-truth}

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


### The false positive (FP/NL) worksheet {#quick-start-roc-fp}

![](images/quick-start/rocCrFp.png){width=100%}

* It consists of 4 columns, each of length 30 (# of modalities x number of readers x number of non-diseased cases). 
* `ReaderID`: the reader labels: `0`, `1`, `2`, `3` and `4`. Each reader label occurs 6 times (# of modalities x number of non-diseased cases). 
* `ModalityID`: the modality or treatment labels: `0` and `1`. Each label occurs 15 times (# of readers x number of non-diseased cases). 
* `CaseID`: the case labels for non-diseased cases: `1`, `2` and `3`. Each label occurs 10 times (# of modalities x # of readers). 
* The label of a diseased case cannot occur in the FP worksheet. If it does the software generates an error. 
* `FP_Rating`: the floating point ratings of non-diseased cases. Each row of this worksheet contains a rating corresponding to the values of `ReaderID`, `ModalityID` and `CaseID` for that row.  

### The true positive (TP/LL) worksheet {#quick-start-roc-tp}


![](images/quick-start/rocCrTp.png){width=100%}

* It consists of 5 columns, each of length 50 (# of modalities x number of readers x number of diseased cases). 
* `ReaderID`: the reader labels: `0`, `1`, `2`, `3` and `4`. Each reader label occurs 10 times (# of modalities x number of diseased cases). 
* `ModalityID`: the modality or treatment labels: `0` and `1`. Each label occurs 25 times (# of readers x number of diseased cases). 
* `LesionID`: For an ROC dataset this column contains fifty 1's (each diseased case has one lesion). 
* `CaseID`: the case labels for non-diseased cases: `70`, `71`, `72`, `73` and `74`. Each label occurs 10 times (# of modalities x # of readers). For an ROC dataset the label of a non-diseased case cannot occur in the TP worksheet. If it does the software generates an error. 
* `TP_Rating`: the floating point ratings of diseased cases. Each row of this worksheet contains a rating corresponding to the values of `ReaderID`, `ModalityID`, `LesionID` and `CaseID` for that row.   





## Reading the Excel file {#quick-start-roc-read}

The following code reads the Excel file and saves it to object `x`.


```r
x <- DfReadDataFile("R/quick-start/rocCr.xlsx", newExcelFileFormat = TRUE)
```

* `newExcelFileFormat` is set to `TRUE` as otherwise columns D - F in the `Truth` worksheet are ignored and the dataset is assumed to be factorial, with `dataType` "automatically" determined from the contents of the FP and TP worksheets. ^[The assumptions underlying the "automatic" determination could be defeated by data entry errors.]

* Flag `newExcelFileFormat = FALSE`, the default, is for compatibility with the original JAFROC format Excel format, which did not have columns D - F in the `Truth` worksheet. Its usage is deprecated.


## Structure of dataset object {#quick-start-roc-structure-dataset}

Most users will not need to be concerned with the internal structure of the dataset object `x`. For those interested in it, for my reference, and for ease of future maintenance of the software, this is deferred to Section \@ref(dataset-object-details-structure-roc-dataset).
