# DBM analysis text output {#quick-start-dbm-text}





## TBA How much finished {#quick-start-dbm-text-how-much-finished}
50%


## Introduction {#quick-start-dbm-text-intro}
This chapter illustrates significance testing using the DBM method. 


## Analyzing the ROC dataset {#quick-start-dbm-text-analyze-dataset}

This illustrates the `StSignificanceTesting()` function. The significance testing method is specified as `"DBM"` and the figure of merit `FOM` is specified as "Wilcoxon". The embedded dataset `dataset03` is used.


```r
ret <- StSignificanceTesting(dataset03, FOM = "Wilcoxon", method = "DBM")
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
#>  $ foms        :'data.frame':	2 obs. of  4 variables:
#>   ..$ rdrREADER_1: num [1:2] 0.853 0.85
#>   ..$ rdrREADER_2: num [1:2] 0.865 0.844
#>   ..$ rdrREADER_3: num [1:2] 0.857 0.84
#>   ..$ rdrREADER_4: num [1:2] 0.815 0.814
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
#> trtTREAT1  0.85345997  0.86499322  0.85730439  0.81524197
#> trtTREAT2  0.84961556  0.84350972  0.84011759  0.81433740
ret$FOMs$trtMeans
#>             Estimate
#> trtTREAT1 0.84774989
#> trtTREAT2 0.83689507
ret$FOMs$trtMeanDiffs
#>                        Estimate
#> trtTREAT1-trtTREAT2 0.010854817
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
#>   ..$ TrtTREAT1: num [1:3] 0.0493 0.294 0.105
#>   ..$ TrtTREAT2: num [1:3] 0.0242 0.3014 0.1034
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
#>                  SS  DF           MS
#> T       0.023565410   1 0.0235654097
#> R       0.205217999   3 0.0684059998
#> C      52.528398680  99 0.5305898857
#> TR      0.015060792   3 0.0050202641
#> TC      6.410048814  99 0.0647479678
#> RC     39.242953812 297 0.1321311576
#> TRC    22.660077641 297 0.0762965577
#> Total 121.085323149 799           NA
ret$ANOVA$VarCom
#>             Estimates
#> VarR    3.7755679e-05
#> VarC    5.1250915e-02
#> VarTR  -7.1276294e-04
#> VarTC  -2.8871475e-03
#> VarRC   2.7917300e-02
#> VarErr  7.6296558e-02
ret$ANOVA$IndividualTrt
#>       DF   TrtTREAT1   TrtTREAT2
#> msR    3 0.049266349 0.024159915
#> msC   99 0.293967531 0.301370323
#> msRC 297 0.105047872 0.103379843
ret$ANOVA$IndividualRdr
#>      DF   rdrREADER_1 rdrREADER_2 rdrREADER_3   rdrREADER_4
#> msT   1 0.00073897606 0.023077021 0.014769293 0.00004091217
#> msC  99 0.20387477465 0.223441908 0.214246773 0.28541990211
#> msTC 99 0.09155873437 0.080279256 0.061228980 0.06057067104
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
#>           DF           MS     FStat          p
#> Treatment  1 0.0235654097 4.6940577 0.11883786
#> Error      3 0.0050202641        NA         NA
ret$RRRC$ciDiffTrt
#>                        Estimate       StdErr DF         t      PrGTt
#> trtTREAT1-trtTREAT2 0.010854817 0.0050101218  3 2.1665774 0.11883786
#>                           CILower     CIUpper
#> trtTREAT1-trtTREAT2 -0.0050896269 0.026799261
ret$RRRC$ciAvgRdrEachTrt
#>             Estimate      StdErr         DF    CILower    CIUpper
#> trtTREAT1 0.84774989 0.024402152  70.121788 0.79908282 0.89641696
#> trtTREAT2 0.83689507 0.023566416 253.644028 0.79048429 0.88330585
```



```r
str(ret$FRRC)
#> List of 4
#>  $ FTests          :'data.frame':	2 obs. of  4 variables:
#>   ..$ DF   : num [1:2] 1 99
#>   ..$ MS   : num [1:2] 0.0236 0.0647
#>   ..$ FStat: num [1:2] 0.364 NA
#>   ..$ p    : num [1:2] 0.548 NA
#>  $ ciDiffTrt       :'data.frame':	1 obs. of  7 variables:
#>   ..$ Estimate: num 0.0109
#>   ..$ StdErr  : num 0.018
#>   ..$ DF      : num 99
#>   ..$ t       : num 0.603
#>   ..$ PrGTt   : num 0.548
#>   ..$ CILower : num -0.0248
#>   ..$ CIUpper : num 0.0466
#>  $ ciAvgRdrEachTrt :'data.frame':	2 obs. of  5 variables:
#>   ..$ Estimate: num [1:2] 0.848 0.837
#>   ..$ StdErr  : num [1:2] 0.0271 0.0274
#>   ..$ DF      : num [1:2] 99 99
#>   ..$ CILower : num [1:2] 0.794 0.782
#>   ..$ CIUpper : num [1:2] 0.902 0.891
#>  $ ciDiffTrtEachRdr:'data.frame':	4 obs. of  7 variables:
#>   ..$ Estimate: num [1:4] 0.003844 0.021483 0.017187 0.000905
#>   ..$ StdErr  : num [1:4] 0.0428 0.0401 0.035 0.0348
#>   ..$ DF      : num [1:4] 99 99 99 99
#>   ..$ t       : num [1:4] 0.0898 0.5362 0.4911 0.026
#>   ..$ PrGTt   : num [1:4] 0.929 0.593 0.624 0.979
#>   ..$ CILower : num [1:4] -0.0811 -0.058 -0.0522 -0.0682
#>   ..$ CIUpper : num [1:4] 0.0888 0.101 0.0866 0.07
```

* FRRC, a list of 4 containing results of fixed-reader random-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below.
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different-treatments, see below.
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each treatment
    + `ciDiffTrtEachRdr`: is a [4x7] dataframe: the confidence intervals for each different-treatment pairing for each reader. 
    

```r
ret$FRRC$FTests
#>           DF          MS      FStat          p
#> Treatment  1 0.023565410 0.36395597 0.54769704
#> Error     99 0.064747968         NA         NA
ret$FRRC$ciDiffTrt
#>                        Estimate      StdErr DF          t      PrGTt
#> trtTREAT1-trtTREAT2 0.010854817 0.017992772 99 0.60328764 0.54769704
#>                          CILower    CIUpper
#> trtTREAT1-trtTREAT2 -0.024846746 0.04655638
ret$FRRC$ciAvgRdrEachTrt
#>             Estimate      StdErr DF    CILower    CIUpper
#> trtTREAT1 0.84774989 0.027109386 99 0.79395898 0.90154079
#> trtTREAT2 0.83689507 0.027448603 99 0.78243109 0.89135905
ret$FRRC$ciDiffTrtEachRdr
#>                                       Estimate      StdErr DF           t
#> rdrREADER_1::trtTREAT1-trtTREAT2 0.00384441429 0.042792227 99 0.089839080
#> rdrREADER_2::trtTREAT1-trtTREAT2 0.02148349163 0.040069753 99 0.536152334
#> rdrREADER_3::trtTREAT1-trtTREAT2 0.01718679331 0.034993994 99 0.491135520
#> rdrREADER_4::trtTREAT1-trtTREAT2 0.00090456807 0.034805365 99 0.025989329
#>                                       PrGTt      CILower     CIUpper
#> rdrREADER_1::trtTREAT1-trtTREAT2 0.92859660 -0.081064648 0.088753476
#> rdrREADER_2::trtTREAT1-trtTREAT2 0.59305592 -0.058023592 0.100990575
#> rdrREADER_3::trtTREAT1-trtTREAT2 0.62441761 -0.052248882 0.086622469
#> rdrREADER_4::trtTREAT1-trtTREAT2 0.97931817 -0.068156827 0.069965963
```


```r
str(ret$RRFC)
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
#>   ..$ StdErr  : num [1:2] 0.0111 0.00777
#>   ..$ DF      : num [1:2] 3 3
#>   ..$ CILower : num [1:2] 0.812 0.812
#>   ..$ CIUpper : num [1:2] 0.883 0.862
```

* RRFC, a list of 3 containing results of random-reader fixed-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below. 
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different-treatments, see below. 
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each  over each treatment.  

    

```r
ret$RRFC$FTests
#>           DF           MS     FStat          p
#> Treatment  1 0.0235654097 4.6940577 0.11883786
#> Error      3 0.0050202641        NA         NA
ret$RRFC$ciDiffTrt
#>                        Estimate       StdErr DF         t      PrGTt
#> trtTREAT1-trtTREAT2 0.010854817 0.0050101218  3 2.1665774 0.11883786
#>                           CILower     CIUpper
#> trtTREAT1-trtTREAT2 -0.0050896269 0.026799261
ret$RRFC$ciAvgRdrEachTrt
#>             Estimate      StdErr DF    CILower    CIUpper
#> trtTREAT1 0.84774989 0.011098012  3 0.81243106 0.88306871
#> trtTREAT2 0.83689507 0.007771730  3 0.81216196 0.86162818
```



## References {#quick-start-dbm-text-references}
