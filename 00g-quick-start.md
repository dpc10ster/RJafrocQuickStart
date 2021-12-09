# OR analysis text output {#quick-start-or-text}





## TBA How much finished {#quick-start-or-text-how-much-finished}
90%


## Introduction {#quick-start-or-text-intro}
This chapter illustrates significance testing using the DBM and OR methods. 


## Analyzing the ROC dataset {#quick-start-or-text-analyze-dataset}

The only change is to specify `method = "OR"` in the significance testing function. The same dataset is used as was used in the previous chapter. 


```r
ret <- StSignificanceTesting(dataset03, FOM = "Wilcoxon", method = "OR")
```

## Explanation of the output {#quick-start-or-text-explanation}
The function returns a list with 5 members.  

* `FOMs`: figures of merit, identical to that in the DBM method. 
* `ANOVA`: ANOVA tables.
* `RRRC`: random-reader random-case analyses results.
* `FRRC`: fixed-reader random-case analyses results.
* `RRFC`" random-reader fixed-case analyses results.

Let us consider the ones that are different from the DBM method. 


* ANOVA is a list of 4
    + `TRanova` is a [3x3] dataframe: the treatment-reader ANOVA table, see below, where SS is the sum of squares, DF is the denominator degrees of freedom and MS is the mean squares, and T = treatment, R = reader, TR = treatment-reader.  
    + `VarCom` is a [6x2] dataframe: the variance components, see below, where `varR` is the reader variance, `varTR` is the treatment-reader variance, `Cov1`, `Cov2`,`Cov3` and `Var` are as defined in the OR model. The second column lists the correlations defined in the OR model.
    + `IndividualTrt` is a [2x4] dataframe: the individual treatment mean-squares, variances and $Cov_2$, averaged over all readers, see below, where `msREachTrt` is the mean square reader, `varEachTrt` is the variance and `cov2EachTrt` is `Cov2EachTrt` in each treatment.
    + `IndividualRdr` is a [2x4] dataframe: the individual reader variance components averaged over treatments, see below, where `msTEachRdr` is the mean square treatment, `varEachRdr` is the variance and `cov1EachRdr` is $Cov_1$ for each reader.
    

```r
ret$ANOVA$TRanova
#>               SS DF            MS
#> T  0.00023565410  1 2.3565410e-04
#> R  0.00205217999  3 6.8406000e-04
#> TR 0.00015060792  3 5.0202641e-05
ret$ANOVA$VarCom
#>            Estimates       Rhos
#> VarR   2.3319942e-05         NA
#> VarTR -6.8389146e-04         NA
#> Cov1   7.9168215e-04 0.51887172
#> Cov2   4.8363767e-04 0.31697811
#> Cov3   5.1250915e-04 0.33590059
#> Var    1.5257762e-03         NA
ret$ANOVA$IndividualTrt
#>           DF    msREachTrt   varEachTrt   cov2EachTrt
#> trtTREAT1  3 0.00049266349 0.0015227779 0.00047229915
#> trtTREAT2  3 0.00024159915 0.0015287746 0.00049497620
ret$ANOVA$IndividualRdr
#>             DF    msTEachRdr   varEachRdr   cov1EachRdr
#> rdrREADER_1  1 7.3897606e-06 0.0014771675 0.00056158020
#> rdrREADER_2  1 2.3077021e-04 0.0015186058 0.00071581326
#> rdrREADER_3  1 1.4769293e-04 0.0013773788 0.00076508897
#> rdrREADER_4  1 4.0912170e-07 0.0017299529 0.00112424616
```

* RRRC, a list of 3 containing results of random-reader random-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below, where `FStat` is the F-statistic and `p` is the p-value. The first row is the treatment effect and the second is the error term.
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different treatments, see below, where `StdErr` is the standard error of the estimate, `t` is the t-statistic and `PrGTt` is the p-value.
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each treatment, see below, where `CILower` is the lower 95% confidence interval and `CIUpper` is the upper 95% confidence interval.
    

```r
ret$RRRC$FTests
#>           DF            MS     FStat          p
#> Treatment  1 2.3565410e-04 4.6940577 0.11883786
#> Error      3 5.0202641e-05        NA         NA
ret$RRRC$ciDiffTrt
#>                        Estimate       StdErr DF         t      PrGTt
#> trtTREAT1-trtTREAT2 0.010854817 0.0050101218  3 2.1665774 0.11883786
#>                           CILower     CIUpper
#> trtTREAT1-trtTREAT2 -0.0050896269 0.026799261
ret$RRRC$ciAvgRdrEachTrt
#>             Estimate      StdErr         DF    CILower    CIUpper          Cov2
#> trtTREAT1 0.84774989 0.024402152  70.121788 0.79908282 0.89641696 0.00047229915
#> trtTREAT2 0.83689507 0.023566416 253.644028 0.79048429 0.88330585 0.00049497620
```

* FRRC, a list of 5 containing results of fixed-reader random-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the chisquare-tests, see below. Here is a difference from DBM: in the OR method for FRRC the denominator degrees of freedom of the F-statistic is infinite, and the test becomes equivalent to a chisquare test with the degrees of freedom equal to $I-1$, where $I$ is the number of treatments.
    + `ciDiffTrt`: is a [1x6] dataframe: the confidence intervals between different treatments, see below. An additional column lists 
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each treatment
    + `ciDiffTrtEachRdr`: is a [4x6] dataframe: the confidence intervals for each different-treatment pairing for each reader. 
   + `IndividualRdrVarCov1`: is a [4x2] dataframe: $Var$ and $Cov_1$ for individual readers. 
    

```r
ret$FRRC$FTests
#>                     MS      Chisq DF          p
#> Treatment 0.0002356541 0.32101347  1 0.57099922
#> Error     0.0007340941         NA NA         NA
ret$FRRC$ciDiffTrt
#>                        Estimate      StdErr          z      PrGTz      CILower
#> trtTREAT1-trtTREAT2 0.010854817 0.019158472 0.56658051 0.57099922 -0.026695098
#>                         CIUpper
#> trtTREAT1-trtTREAT2 0.048404732
ret$FRRC$ciAvgRdrEachTrt
#>             Estimate      StdErr DF    CILower    CIUpper
#> trtTREAT1 0.84774989 0.027109386 99 0.79461647 0.90088331
#> trtTREAT2 0.83689507 0.027448603 99 0.78309680 0.89069334
ret$FRRC$ciDiffTrtEachRdr
#>                                       Estimate      StdErr           z
#> rdrREADER_1::trtTREAT1-trtTREAT2 0.00384441429 0.042792227 0.089839080
#> rdrREADER_2::trtTREAT1-trtTREAT2 0.02148349163 0.040069753 0.536152334
#> rdrREADER_3::trtTREAT1-trtTREAT2 0.01718679331 0.034993994 0.491135520
#> rdrREADER_4::trtTREAT1-trtTREAT2 0.00090456807 0.034805365 0.025989329
#>                                       PrGTz      CILower     CIUpper
#> rdrREADER_1::trtTREAT1-trtTREAT2 0.92841509 -0.080026809 0.087715638
#> rdrREADER_2::trtTREAT1-trtTREAT2 0.59185327 -0.057051781 0.100018765
#> rdrREADER_3::trtTREAT1-trtTREAT2 0.62333060 -0.051400174 0.085773761
#> rdrREADER_4::trtTREAT1-trtTREAT2 0.97926585 -0.067312693 0.069121830
ret$FRRC$IndividualRdrVarCov1
#>               varEachRdr   cov1EachRdr
#> rdrREADER_1 0.0014771675 0.00056158020
#> rdrREADER_2 0.0015186058 0.00071581326
#> rdrREADER_3 0.0013773788 0.00076508897
#> rdrREADER_4 0.0017299529 0.00112424616
```

    
* RRFC, a list of 3 containing results of random-reader fixed-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below. 
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different treatments, see below. 
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each  over each treatment.  

    

```r
ret$RRFC$FTests
#>    DF            MS         F          p
#> T   1 2.3565410e-04 4.6940577 0.11883786
#> TR  3 5.0202641e-05        NA         NA
ret$RRFC$ciDiffTrt
#>                        Estimate       StdErr DF         t      PrGTt
#> trtTREAT1-trtTREAT2 0.010854817 0.0050101218  3 2.1665774 0.11883786
#>                           CILower     CIUpper
#> trtTREAT1-trtTREAT2 -0.0050896269 0.026799261
ret$RRFC$ciAvgRdrEachTrt
#>             Estimate      StdErr DF    CILower    CIUpper
#> TrtTREAT1 0.84774989 0.011098012  3 0.81243106 0.88306871
#> TrtTREAT2 0.83689507 0.007771730  3 0.81216196 0.86162818
```


## References {#quick-start-or-text-references}
