# DBM analysis text output {#quick-start-dbm-text}





## TBA How much finished {#quick-start-dbm-text-how-much-finished}
50%


## Introduction {#quick-start-dbm-text-intro}
This chapter illustrates significance testing using the DBM method. 


## Analyzing the ROC dataset {#quick-start-dbm-text-analyze-dataset}

This illustrates the `St()` function. The significance testing method is specified as `"DBM"` and the figure of merit `FOM` is specified as "Wilcoxon". The embedded dataset `dataset03` is used.


```r
ret <- St(dataset03, FOM = "Wilcoxon", method = "DBM")
```

## Explanation of the output {#quick-start-dbm-text-explanation}
The function returns a list with 5 members: 

* `FOMs`: figures of merit.
* `ANOVA`: ANOVA tables.
* `RRRC`: random-reader random-case analyses results.
* `FRRC`: fixed-reader random-case analyses results.
* `RRFC`" random-reader fixed-case analyses results.

Let us consider them individually. 


```r
str(ret$FOMs)
#> List of 3
#>  $ foms        : num [1:2, 1:4] 0.853 0.85 0.865 0.844 0.857 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:2] "trtTREAT1" "trtTREAT2"
#>   .. ..$ : chr [1:4] "rdrREADER_1" "rdrREADER_2" "rdrREADER_3" "rdrREADER_4"
#>  $ trtMeans    :'data.frame':	2 obs. of  1 variable:
#>   ..$ Estimate: num [1:2] 0.848 0.837
#>  $ trtMeanDiffs:'data.frame':	1 obs. of  1 variable:
#>   ..$ Estimate: num 0.0109
```

* `FOMs` is a list of 3
    + `foms` is a [2x4] dataframe: the figure of merit for each of of the four observers in the two treatments.
    + `trtMeans` is a [2x1] dataframe: the average figure of merit over all readers for each treatment.
    + `trtMeanDiffs` a [1x1] dataframe: the difference(s) of the reader-averaged figures of merit for all different-treatment pairings. In this example, with only two treatments, there is only one different-treatment pairing.
    

```r
ret$FOMs$foms
#>           rdrREADER_1 rdrREADER_2 rdrREADER_3 rdrREADER_4
#> trtTREAT1   0.8534600   0.8649932   0.8573044   0.8152420
#> trtTREAT2   0.8496156   0.8435097   0.8401176   0.8143374
ret$FOMs$trtMeans
#>            Estimate
#> trtTREAT1 0.8477499
#> trtTREAT2 0.8368951
ret$FOMs$trtMeanDiffs
#>                       Estimate
#> trtTREAT1-trtTREAT2 0.01085482
```



```r
str(ret$ANOVA)
#> List of 4
#>  $ TRCanova     :'data.frame':	8 obs. of  3 variables:
#>   ..$ SS: num [1:8] 0.0236 0.2052 52.5284 0.0151 6.41 ...
#>   ..$ DF: num [1:8] 1 3 99 3 99 297 297 799
#>   ..$ MS: num [1:8] 0.02357 0.06841 0.53059 0.00502 0.06475 ...
#>  $ VarCom       :'data.frame':	6 obs. of  1 variable:
#>   ..$ Estimates: num [1:6] 3.78e-05 5.13e-02 -7.13e-04 -2.89e-03 2.79e-02 ...
#>  $ IndividualTrt:'data.frame':	3 obs. of  3 variables:
#>   ..$ DF       : num [1:3] 3 99 297
#>   ..$ trtTREAT1: num [1:3] 0.0493 0.294 0.105
#>   ..$ trtTREAT2: num [1:3] 0.0242 0.3014 0.1034
#>  $ IndividualRdr:'data.frame':	3 obs. of  5 variables:
#>   ..$ DF         : num [1:3] 1 99 99
#>   ..$ rdrREADER_1: num [1:3] 0.000739 0.203875 0.091559
#>   ..$ rdrREADER_2: num [1:3] 0.0231 0.2234 0.0803
#>   ..$ rdrREADER_3: num [1:3] 0.0148 0.2142 0.0612
#>   ..$ rdrREADER_4: num [1:3] 4.09e-05 2.85e-01 6.06e-02
```

* ANOVA is a list of 4
    + `TRCanova` is a [8x3] dataframe: the treatment-reader-case ANOVA table, see below, where SS is the sum of squares, DF is the denominator degrees of freedom and MS is the mean squares, and T = treatment, R = reader, C = case, TR = treatment-reader, TC = treatment-case, RC = reader-case, TRC = treatment-reader-case.  
    + `VarCom` is a [6x1] dataframe: the variance components, see below, where `varR` is the reader variance, `varC` is the case variance, `varTR` is the treatment-reader variance, `varTC` is the treatment-case variance, `varRC` is the reader-case variance, and `varTRC` is the treatment-reader-case variance.
    + `IndividualTrt` is a [3x3] dataframe: the individual treatment variance components averaged over all readers, see below, where `msR` is the mean square reader, `msC` is the mean square case and `msRC` is the mean square reader-case.
    + `IndividualRdr` is a [3x5] dataframe: the individual reader variance components averaged over treatments, see below, where `msT` is the mean square treatment, `msC` is the mean square case and `msTC` is the mean square treatment-case.
    

```r
ret$ANOVA$TRCanova
#>                 SS  DF          MS
#> T       0.02356541   1 0.023565410
#> R       0.20521800   3 0.068406000
#> C      52.52839868  99 0.530589886
#> TR      0.01506079   3 0.005020264
#> TC      6.41004881  99 0.064747968
#> RC     39.24295381 297 0.132131158
#> TRC    22.66007764 297 0.076296558
#> Total 121.08532315 799          NA
ret$ANOVA$VarCom
#>            Estimates
#> VarR    3.775568e-05
#> VarC    5.125091e-02
#> VarTR  -7.127629e-04
#> VarTC  -2.887147e-03
#> VarRC   2.791730e-02
#> VarErr  7.629656e-02
ret$ANOVA$IndividualTrt
#>       DF  trtTREAT1  trtTREAT2
#> msR    3 0.04926635 0.02415991
#> msC   99 0.29396753 0.30137032
#> msRC 297 0.10504787 0.10337984
ret$ANOVA$IndividualRdr
#>      DF  rdrREADER_1 rdrREADER_2 rdrREADER_3  rdrREADER_4
#> msT   1 0.0007389761  0.02307702  0.01476929 4.091217e-05
#> msC  99 0.2038747746  0.22344191  0.21424677 2.854199e-01
#> msTC 99 0.0915587344  0.08027926  0.06122898 6.057067e-02
```


```r
str(ret$RRRC)
#> List of 3
#>  $ FTests         :'data.frame':	2 obs. of  4 variables:
#>   ..$ DF   : num [1:2] 1 3
#>   ..$ MS   : num [1:2] 0.02357 0.00502
#>   ..$ FStat: num [1:2] 4.69 NA
#>   ..$ p    : num [1:2] 0.119 NA
#>  $ ciDiffTrt      :'data.frame':	1 obs. of  7 variables:
#>   ..$ Estimate: num 0.0109
#>   ..$ StdErr  : num 0.00501
#>   ..$ DF      : num 3
#>   ..$ t       : num 2.17
#>   ..$ PrGTt   : num 0.119
#>   ..$ CILower : num -0.00509
#>   ..$ CIUpper : num 0.0268
#>  $ ciAvgRdrEachTrt:'data.frame':	2 obs. of  5 variables:
#>   ..$ Estimate: num [1:2] 0.848 0.837
#>   ..$ StdErr  : num [1:2] 0.0244 0.0236
#>   ..$ DF      : num [1:2] 70.1 253.6
#>   ..$ CILower : num [1:2] 0.799 0.79
#>   ..$ CIUpper : num [1:2] 0.896 0.883
```

* RRRC, a list of 3 containing results of random-reader random-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below, where `FStat` is the F-statistic and `p` is the p-value. The first row is the treatment effect and the second is the error term. 
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different-treatments, see below, where `StdErr` is the standard error of the estimate, `t` is the t-statistic and `PrGTt` is the p-value.
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for each treatment, averaged over all readers in the treatment, see below, where `CILower` is the lower 95% confidence interval and `CIUpper` is the upper 95% confidence interval.
    

```r
ret$RRRC$FTests
#>           DF          MS    FStat         p
#> Treatment  1 0.023565410 4.694058 0.1188379
#> Error      3 0.005020264       NA        NA
ret$RRRC$ciDiffTrt
#>                       Estimate      StdErr DF        t     PrGTt      CILower
#> trtTREAT1-trtTREAT2 0.01085482 0.005010122  3 2.166577 0.1188379 -0.005089627
#>                        CIUpper
#> trtTREAT1-trtTREAT2 0.02679926
ret$RRRC$ciAvgRdrEachTrt
#>            Estimate     StdErr        DF   CILower   CIUpper
#> trtTREAT1 0.8477499 0.02440215  70.12179 0.7990828 0.8964170
#> trtTREAT2 0.8368951 0.02356642 253.64403 0.7904843 0.8833058
```



```r
str(ret$FRRC)
#>  NULL
```

* FRRC, a list of 4 containing results of fixed-reader random-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below.
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different-treatments, see below.
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each treatment
    + `ciDiffTrtEachRdr`: is a [4x7] dataframe: the confidence intervals for each different-treatment pairing for each reader. 
    

```r
ret$FRRC$FTests
#> NULL
ret$FRRC$ciDiffTrt
#> NULL
ret$FRRC$ciAvgRdrEachTrt
#> NULL
ret$FRRC$ciDiffTrtEachRdr
#> NULL
```


```r
str(ret$RRFC)
#>  NULL
```

* RRFC, a list of 3 containing results of random-reader fixed-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below. 
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different-treatments, see below. 
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each  over each treatment.  

    

```r
ret$RRFC$FTests
#> NULL
ret$RRFC$ciDiffTrt
#> NULL
ret$RRFC$ciAvgRdrEachTrt
#> NULL
```


