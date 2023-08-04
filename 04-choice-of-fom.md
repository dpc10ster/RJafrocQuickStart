# Choosing an appropriate figure of merit {-}






## How much finished 0 percent {#choice-of-fom-hmf}

WARNING: Usage of FOM = HrSe or FOM = HrSp is strongly discouraged. Consider comparing two readers or two treatments using either of these FOMs. The rating is a *subjective ordered label*. It need not be used consistently between readers and treatments. A reader using a strict reporting criteria, who only marks a lesion when he is very confident, will have smaller HrSe and larger HrSp than a reader who adopts a laxer criteria, even though true performance, as measured by ROC AUC or percentage correct in 2AFC task, are identical. This is ROC-101: ROC AUC was recommended by Metz, ca. 1978 instead of sensitivity or specificity. 


## Introduction  {#choice-of-fom-introduction}

Assuming the study has been properly conducted, e.g., ROC or FROC, probably the most important step before beginning to analyze the dataset is to choose an apprpriate figure of merit (i.e., performance metric). 


## ROC dataset  {#choice-of-fom-roc}

In the ROC paradigm every modality-reader-case combination yields a single rating. The appropriate FOM is the Wilcoxon statistic, which is identical to the AUC under the empirical ROC curve.  


## FROC dataset  {#choice-of-fom-froc}

In the FROC paradigm every modality-reader-case combination yields a random number (zero or more) of mark-rating pairs. 

### FOM = wAFROC {#choice-of-fom-froc-wafroc}

For most FROC datasets the appropriate FOM is the AUC under the weighted AFROC plot, as illustrated next for `daset05` which has two modalities and 9 readers.  



```r
fom_wAFROC <- UtilFigureOfMerit(dataset = dataset05, FOM = "wAFROC")
as.data.frame(lapply(fom_wAFROC, format, decimal.mark = ".", digits = 4))
```

```
##     rdr1   rdr2   rdr3   rdr4   rdr5   rdr6   rdr7   rdr8  rdr9
## 1 0.7245 0.8810 0.8096 0.6133 0.5773 0.8493 0.8928 0.8026 0.764
## 2 0.8024 0.9686 0.8460 0.7514 0.7209 0.8719 0.9370 0.8995 0.819
```

### FOM = HrSe {#choice-of-fom-froc-hrse}

Recall that the concepts of sensitivity and specificity are reserved for ROC data - i.e., one rating per case. To compute these from FROC data one needs a method for inferring a single rating from the possibly multiple (zero or more) ratings ocurring on each case (if the case has no marks one assings a rating that is smaller than any the ratings of explicitly marked locations, e.g., minus infinity). The recommended procedure is to assign the rating of the highest rated mark on each case, of $-\infty$ if the case has no marks, as its inferred ROC rating. This has the has the effect of converting the FROC dataset to an inferred ROC dataset. The function `DfFroc2Roc` does exactly this:


```r
dataset05$descriptions$type
```

```
## [1] "FROC"
```

```r
ds <- DfFroc2Roc(dataset05)
ds$descriptions$type
```

```
## [1] "ROC"
```

`HrSe` is the abbreviation for "highest rating sensitivity",  sensitivity derived from the rating of the highest rated mark on each case. Replacing the possibly multiple ratings occurring on each case with the highest rating amounts to an assumption,  a very good one in my opinion. Since the ratings are ordered labels (i.e., non-numeric vaues) any numerical computation, such as the average, would be invalid. It is also common sense: if a case has 3 marks rated 80, 30 and 15, why would the ROC rating be anything but 80. Finally, there is historical precedence for this assumption:  [@bunch1977free; @swensson1996unified]. 



Usage of `FOM = HrSe` is illustrated next for `dataset05`.  



```r
fom_HrSe <- UtilFigureOfMerit(dataset = dataset05, FOM = "HrSe")
as.data.frame(lapply(fom_HrSe, format, decimal.mark = ".", digits = 4))
```

```
##     rdr1   rdr2   rdr3   rdr4   rdr5   rdr6   rdr7   rdr8   rdr9
## 1 0.9362 0.8298 0.8936 0.7021 0.8298 0.9574 0.8723 0.8936 0.8936
## 2 1.0000 0.9574 0.9574 0.8511 0.8511 1.0000 0.9362 0.9149 0.9787
```

Notice that each listed value is greater TBA?? than the corresponding value when using `FOM = "wAFROC"`. This should not come as a surprise as 


```r
for (i in 1:2)
    for (j in 1:9) {
        cat("i = ", i, ", j = ", j, "\n")
        if (fom_HrSe[i,j] > fom_wAFROC[i,j]) cat ("TRUE \n") else cat("FALSE \n") 
}
```

```
## i =  1 , j =  1 
## TRUE 
## i =  1 , j =  2 
## FALSE 
## i =  1 , j =  3 
## TRUE 
## i =  1 , j =  4 
## TRUE 
## i =  1 , j =  5 
## TRUE 
## i =  1 , j =  6 
## TRUE 
## i =  1 , j =  7 
## FALSE 
## i =  1 , j =  8 
## TRUE 
## i =  1 , j =  9 
## TRUE 
## i =  2 , j =  1 
## TRUE 
## i =  2 , j =  2 
## FALSE 
## i =  2 , j =  3 
## TRUE 
## i =  2 , j =  4 
## TRUE 
## i =  2 , j =  5 
## TRUE 
## i =  2 , j =  6 
## TRUE 
## i =  2 , j =  7 
## FALSE 
## i =  2 , j =  8 
## TRUE 
## i =  2 , j =  9 
## TRUE
```
