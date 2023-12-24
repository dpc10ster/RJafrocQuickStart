# OR analysis text output {#quick-start-or-text}





## TBA How much finished {#quick-start-or-text-how-much-finished}
90%


## Introduction {#quick-start-or-text-intro}
This chapter illustrates significance testing using the DBM and OR methods. 


## Analyzing the ROC dataset {#quick-start-or-text-analyze-dataset}

The only change is to specify `method = "OR"` in the significance testing function. The same dataset is used as was used in the previous chapter. 


```r
ret <- St(dataset03, FOM = "Wilcoxon", method = "OR")
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
#>              SS DF           MS
#> T  0.0002356541  1 2.356541e-04
#> R  0.0020521800  3 6.840600e-04
#> TR 0.0001506079  3 5.020264e-05
ret$ANOVA$VarCom
#>           Estimates      Rhos
#> VarR   2.331994e-05        NA
#> VarTR -6.838915e-04        NA
#> Cov1   7.916821e-04 0.5188717
#> Cov2   4.836377e-04 0.3169781
#> Cov3   5.125091e-04 0.3359006
#> Var    1.525776e-03        NA
ret$ANOVA$IndividualTrt
#>           DF   msREachTrt  varEachTrt  cov2EachTrt
#> trtTREAT1  3 0.0004926635 0.001522778 0.0004722991
#> trtTREAT2  3 0.0002415991 0.001528775 0.0004949762
ret$ANOVA$IndividualRdr
#>             DF   msTEachRdr  varEachRdr  cov1EachRdr
#> rdrREADER_1  1 7.389761e-06 0.001477168 0.0005615802
#> rdrREADER_2  1 2.307702e-04 0.001518606 0.0007158133
#> rdrREADER_3  1 1.476929e-04 0.001377379 0.0007650890
#> rdrREADER_4  1 4.091217e-07 0.001729953 0.0011242462
```

* RRRC, a list of 3 containing results of random-reader random-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below, where `FStat` is the F-statistic and `p` is the p-value. The first row is the treatment effect and the second is the error term.
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different treatments, see below, where `StdErr` is the standard error of the estimate, `t` is the t-statistic and `PrGTt` is the p-value.
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each treatment, see below, where `CILower` is the lower 95% confidence interval and `CIUpper` is the upper 95% confidence interval.
    

```r
ret$RRRC$FTests
#>           DF           MS    FStat         p
#> Treatment  1 2.356541e-04 4.694058 0.1188379
#> Error      3 5.020264e-05       NA        NA
ret$RRRC$ciDiffTrt
#>                       Estimate      StdErr DF        t     PrGTt      CILower
#> trtTREAT1-trtTREAT2 0.01085482 0.005010122  3 2.166577 0.1188379 -0.005089627
#>                        CIUpper
#> trtTREAT1-trtTREAT2 0.02679926
ret$RRRC$ciAvgRdrEachTrt
#>            Estimate     StdErr        DF   CILower   CIUpper         Cov2
#> trtTREAT1 0.8477499 0.02440215  70.12179 0.7990828 0.8964170 0.0004722991
#> trtTREAT2 0.8368951 0.02356642 253.64403 0.7904843 0.8833058 0.0004949762
```

* FRRC, a list of 5 containing results of fixed-reader random-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the chisquare-tests, see below. Here is a difference from DBM: in the OR method for FRRC the denominator degrees of freedom of the F-statistic is infinite, and the test becomes equivalent to a chisquare test with the degrees of freedom equal to $I-1$, where $I$ is the number of treatments.
    + `ciDiffTrt`: is a [1x6] dataframe: the confidence intervals between different treatments, see below. An additional column lists 
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each treatment
    + `ciDiffTrtEachRdr`: is a [4x6] dataframe: the confidence intervals for each different-treatment pairing for each reader. 
   + `IndividualRdrVarCov1`: is a [4x2] dataframe: $Var$ and $Cov_1$ for individual readers. 
    

```r
ret$FRRC$FTests
#> NULL
ret$FRRC$ciDiffTrt
#> NULL
ret$FRRC$ciAvgRdrEachTrt
#> NULL
ret$FRRC$ciDiffTrtEachRdr
#> NULL
ret$FRRC$IndividualRdrVarCov1
#> NULL
```

    
* RRFC, a list of 3 containing results of random-reader fixed-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below. 
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different treatments, see below. 
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each  over each treatment.  

    

```r
ret$RRFC$FTests
#> NULL
ret$RRFC$ciDiffTrt
#> NULL
ret$RRFC$ciAvgRdrEachTrt
#> NULL
```


