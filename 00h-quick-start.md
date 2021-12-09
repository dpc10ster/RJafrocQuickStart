# OR analysis Excel output {#quick-start-or-excel}







## TBA How much finished {#quick-start-or-excel-how-much-finished}
90%


## Introduction {#quick-start-or-excel-intro}
This chapter illustrates significance testing using the OR method. But, instead of the perhaps unwieldy output in Chapter \@ref(quick-start-or-text), it generates an Excel output file containing the following worksheets:

* `Summary`
* `FOMs`
* `ANOVA`
* `RRRC`
* `FRRC`
* `RRFC`


## Generating the Excel output file {#quick-start-or-excel-output}

This illustrates the `UtilOutputReport()` function. The arguments are the embedded dataset, `dataset03`, the same dataset as in the previous two chapters, the report file base name `ReportFileBaseName` is set to `R/quick-start/MyResults`, the report file extension `ReportFileExt` is set to `xlsx`, the `FOM` is set to "Wilcoxon", the `method` of analysis is set to "OR", and the flag `overWrite = TRUE` overwrites any existing file with the same name, as otherwise the program will pause for user input.



```r
ret <- UtilOutputReport(get("dataset03"), 
                        ReportFileBaseName = "R/quick-start/MyResults", 
                        ReportFileExt = "xlsx",  
                        FOM = "Wilcoxon", 
                        method = "OR", 
                        overWrite = TRUE)
```

The following screen shots display the contents of the created file `"R/quick-start/MyResults.xlsx"`.


<div class="figure" style="text-align: center">
<img src="R/quick-start/MyResultsSummary.png" alt="`Summary` and `FOMs` worksheets of Excel file `R/quick-start/MyResults.xlsx`" width="50%" height="20%" /><img src="R/quick-start/MyResultsFOMs.png" alt="`Summary` and `FOMs` worksheets of Excel file `R/quick-start/MyResults.xlsx`" width="50%" height="20%" />
<p class="caption">(\#fig:quick-start-or-xlsx1)`Summary` and `FOMs` worksheets of Excel file `R/quick-start/MyResults.xlsx`</p>
</div>



<div class="figure" style="text-align: center">
<img src="R/quick-start/MyResultsANOVA1.png" alt="`ANOVA` worksheet of Excel file `R/quick-start/MyResults.xlsx`" width="50%" height="20%" /><img src="R/quick-start/MyResultsANOVA2.png" alt="`ANOVA` worksheet of Excel file `R/quick-start/MyResults.xlsx`" width="50%" height="20%" />
<p class="caption">(\#fig:quick-start-or-xlsx2)`ANOVA` worksheet of Excel file `R/quick-start/MyResults.xlsx`</p>
</div>



<div class="figure" style="text-align: center">
<img src="R/quick-start/MyResultsRRRC.png" alt="`RRRC`, `FRRC` and `RRFC` worksheets of Excel file `R/quick-start/MyResults.xlsx`" width="50%" height="20%" /><img src="R/quick-start/MyResultsFRRC.png" alt="`RRRC`, `FRRC` and `RRFC` worksheets of Excel file `R/quick-start/MyResults.xlsx`" width="50%" height="20%" /><img src="R/quick-start/MyResultsRRFC.png" alt="`RRRC`, `FRRC` and `RRFC` worksheets of Excel file `R/quick-start/MyResults.xlsx`" width="50%" height="20%" />
<p class="caption">(\#fig:quick-start-or-xlsx3)`RRRC`, `FRRC` and `RRFC` worksheets of Excel file `R/quick-start/MyResults.xlsx`</p>
</div>



## References {#quick-start-or-excel-references}
