# (PART\*) FROC sample size {-}


# FROC sample size estimation {#froc-sample-size}







## How much finished 90 percent {#froc-sample-size-how-much-finished}

Comments on reason for increased FROC power; discuss idea about separating treatments and using lower half in terms of AUC to compute the NH parameters; does this improve DOBBINS-1 performance - solve the unusually low scale factor for this dataset?

## Overview

This chapter is split into three parts: 

* Part 1 is a step-by-step approach to FROC paradigm sample size estimation; 

* Part 2 encapsulates some of the details in `SsFrocNhRsmModel()`.

* Part 3 uses `SsFrocSampleSize()` which encapsulates the procedure into a single function call which is applied to 7 FROC datasets.


## Part 1

### Introduction {#froc-sample-size-intro}

FROC sample size estimation is not fundamentally different from ROC sample size estimation, Chapter \@ref(roc-sample-size-dbm). 

**A recapitulation of ROC sample size estimation** 

Based on analysis of a pilot ROC dataset and using a specified figure of merit (FOM), e.g., `FOM = Wilcoxon`, and either `method = "DBM"` or `method = "OR"` for significance testing, one estimates the intrinsic variability of the data expressed in terms of FOM variance components. For the DBM method these are the pseudovalue-based variance components while for OR method these are the FOM-based variance and covariances. **In this chapter the OR variance components will be used.** The second step is to specify a clinically realistic effect-size, e.g., the anticipated AUC difference between the two modalities. 

Given the variance components and the anticipated AUC difference the sample size functions (`RJafroc` function names beginning with `Ss`) allow one to estimate the number of readers and cases necessary to detect (i.e., reject the null hypothesis) the modality AUC difference with probability $\beta$, typically chosen to be 20 percent (corresponding to 80 percent statistical power) while maintaining the NH (zero AUC difference) rejection rate probability at $\alpha$, typically chosen to be 5 percent. 


**Summary of FROC sample size estimation** 

In FROC analysis the only difference, indeed the critical difference, is the choice of FOM; e.g., `FOM = "wAFROC"` instead of the ROC-AUC, `FOM = "Wilcoxon"`. The FROC dataset is analyzed using the DBM (or the OR) method. This yields the necessary variance components (or the covariance matrix) of the wAFROC-AUC. Next one specifies the effect-size **in wAFROC-AUC units** and this requires care. The ROC-AUC has a historically well-known interpretation, namely it is the classification ability at separating diseased patients from non-diseased patients, while the wAFROC-AUC does not. Needed is a way of relating the effect-size in easily understood ROC-AUC units to one in wAFROC-AUC units. This requires a physical model, e.g., the RSM, that predicts both ROC and wAFROC curves and their corresponding AUCs.


1.	One chooses an ROC-AUC effect-size that is realistic, one that clinicians understand and can therefore participate in, in the effect-size postulation process. Lacking such information I recommend, based on past ROC studies, 0.03 as typical of a small effect size and 0.05 as typical of a moderate effect size.

2.	One converts the ROC effect-size to a wAFROC-AUC effect-size using the method described in the next section.

3.	One uses the sample size tools in `RJafroc` to determine sample size for a desired statistical power. 


>**It is important to recognize is that all quantities have to be in the same units**. When performing ROC analysis, everything (variance components and effect-size) has to be in units of the selected FOM, e.g., `FOM = "Wilcoxon"`. When doing wAFROC analysis, everything has to be in units of the wAFROC-AUC, i.e., `FOM = "wAFROC"`. The variance components and effect-size in wAFROC-AUC units will be different from their corresponding ROC counterparts. In particular, as shown next, an ROC-AUC effect-size of 0.05 generally corresponds to a larger effect-size in wAFROC-AUC units. The reason for this is that the range over which wAFROC-AUC can vary, namely 0 to 1, is twice the corresponding ROC-AUC range (0.5 to 1). For the same reason the wAFROC variance components also tend to be larger than the ROC variance components.


The next section explains the steps used to implement #2 above. 

### Relating ROC and wAFROC effect-sizes

The steps are illustrated using `dataset04`, a 5 treatment, 4 radiologist and 200 case FROC dataset [@zanca2009evaluation] acquired on a 5-point scale, i.e., the data is already binned. If not binned one needs to bin the dataset using `DfBinDataset()` before RSM fitting can be performed. 

The following code computes `JStar` and `KStar`, the numbers of readers and cases in the pilot dataset. These are needed below for correct scaling of the OR variance components.



```r
JStar <- length(dataset04$ratings$NL[1,,1,1])
KStar <- length(dataset04$ratings$NL[1,1,,1])
```

#### Extract NH treatments

If there are more than two treatments in the pilot dataset, as in `dataset04`, one extracts those treatments that represent "almost" null hypothesis data (in the sense of similar ROC-AUCs): 


```r
frocDataNH <- DfExtractDataset(dataset04, trts = c(1,2))
```

extracts treatments 1 and 2. These treatments were found [@zanca2009evaluation] to be "almost" equivalent (the NH could not be rejected for the wAFROC-AUC difference between these treatments). More than two treatments can be used if they have similar AUCs, as this will improve the stability of the procedure. However, the final sample size predictions are restricted to two treatments in the pivotal study. 


The next two steps are needed since **the RSM can only fit binned ROC data**. 


#### Convert the FROC NH data to ROC

If the original data is FROC, one converts it to ROC:



```r
rocDataNH <- DfFroc2Roc(frocDataNH)
```

#### Bin the data

If the NH dataset uses continuous ratings one bins the ratings: 


```r
# For dataset04 this is unnecessary as it is already binned but it can't hurt
rocDataBinNH <- DfBinDataset(rocDataNH, opChType = "ROC")
```

The default number of bins should be used. Unlike binning using arbitrarily set thresholds the thresholds found by `DfBinDataset()` are unique as they maximize the empirical ROC-AUC. 


#### Determine the lesion distribution and weights of the FROC dataset



`lesDistr` is the lesion distribution, see Section \@ref(quick-start-froc-data-lesion-distribution) and line 1 of the following code. The RSM fitting algorithm needs to know how lesion-rich the dataset is as the predicted ROC-AUC depends it. For this dataset fraction 0.69 of diseased cases have one lesion, fraction 0.2 have two lesions and fraction 0.11 have three lesions. One also needs the lesion weights matrix, $\textbf{W}$, see Section \@ref(quick-start-froc-data-lesion-weights). The call at line 2 to `UtilLesWghtsDS` uses the default argument `relWeights = 0` which assigns equal weights to all lesions.




```{.r .numberLines}
lesDistr <- UtilLesDistr(frocDataNH)
W <- UtilLesWghtsDS(frocDataNH)
W
```

```
##      [,1]      [,2]      [,3]      [,4]
## [1,]    1 1.0000000      -Inf      -Inf
## [2,]    2 0.5000000 0.5000000      -Inf
## [3,]    3 0.3333333 0.3333333 0.3333333
```


Note that `lesDistr` and $\textbf{W}$ are determined from the *FROC* NH dataset as this information is lost upon conversion to an ROC dataset. 

#### Fit the RSM to the ROC data

For each treatment and reader the fitting algorithm `FitRsmRoc()` is applied (lines 4 - 11) to the binned NH ROC dataset. The returned values are `mu`, `lambda` and `nu`, corresponding to the physical RSM parameters ${\mu}$, ${\lambda}$ and ${\nu}$.


```{.r .numberLines}
I <- dim(rocDataBinNH$ratings$NL)[1]
J <- dim(rocDataBinNH$ratings$NL)[2]
RsmParmsNH <- array(dim = c(I,J,3))
for (i in 1:I) {
  for (j in 1:J)  {
    fit <- FitRsmRoc(rocDataBinNH, trt = i, rdr = j, lesDistr$Freq)
    RsmParmsNH[i,j,1] <- fit[[1]] # mu
    RsmParmsNH[i,j,2] <- fit[[2]] # lambda
    RsmParmsNH[i,j,3] <- fit[[3]] # nu
  }
}
```


#### Compute the median values of the RSM parameters

I recommend taking the median (not the mean) of each of the parameters as representing the "average" NH dataset. The median is less sensitive to outliers than the mean.  



```r
muNH <- median(RsmParmsNH[,,1]) 
lambdaNH <- median(RsmParmsNH[,,2])
nuNH <- median(RsmParmsNH[,,3])
```


The defining values of the NH fitting model are `muNH` = 3.3121519, `lambdaNH` = 1.714368 and `nuNH` = 0.7036564. 


#### Compute ROC and wAFROC NH AUCs



```r
aucRocNH <- UtilAnalyticalAucsRSM(muNH, lambdaNH, nuNH, lesDistr = lesDistr$Freq)$aucROC
aucwAfrocNH <- UtilAnalyticalAucsRSM(muNH, lambdaNH, nuNH, lesDistr = lesDistr$Freq)$aucwAFROC
```


The AUCs are: `aucRocNH = 0.8791542` and `aucwAfrocNH = 0.7198615`. Note that the wAFROC-FOM is smaller than the ROC-FOM as it includes detection and localization performance. 

#### Compute ROC and wAFROC AH AUCs for a range of ROC-AUC effect sizes

To define the alternative hypothesis (AH) condition, one increments $\mu_{NH}$ by $\Delta_{\mu}$. It is not enough to simply increase the $\mu$ parameter as increasing it simultaneously decreases $\lambda$ and increase $\nu$. To account for this one extracts the intrinsic parameters $\lambda_i, \nu_i$ at line 7 and then converts back to the physical parameters at line 9 using the incremented $\mu$. Note the usage of the functions The resulting ROC-AUC and wAFROC-AUC are calculated. One calculates the effect size (AH value minus NH value) using ROC and wAFROC FOMs for a series of specified `deltaMu` values. This generates values that can be used to relate the wAFROC effect size for a specified ROC effect size. 



```{.r .numberLines}
deltaMu <- seq(0.01, 0.2, 0.01)
esROC <- array(dim = length(deltaMu))
eswAFROC <- array(dim = length(deltaMu))
for (i in 1:length(deltaMu)) {
  
  # get intrinsic parameters
  par_i <- Util2Intrinsic(muNH, lambdaNH, nuNH) # intrinsic
  # find physical parameters for increased muNH accounting for combined change
  par_p <- Util2Physical(muNH + deltaMu[i], par_i$lambda_i, par_i$nu_i)  # physical
  
  esROC[i] <- UtilAnalyticalAucsRSM(
    muNH + deltaMu[i], par_p$lambda, par_p$nu, lesDistr = lesDistr$Freq)$aucROC - aucRocNH
  
  eswAFROC[i] <- UtilAnalyticalAucsRSM(
    muNH + deltaMu[i], par_p$lambda, par_p$nu, lesDistr = lesDistr$Freq)$aucwAFROC - aucwAfrocNH
  
}
```


Here is a plot of wAFROC effect size (y-axis) vs. ROC effect size.


<div class="figure" style="text-align: center">
<img src="19-froc-sample-size_files/figure-html/unnamed-chunk-12-1.png" alt="Plot of wAFROC effect size vs. ROC effect size. The straight line fit through the origin has slope 2.169." width="672" />
<p class="caption">(\#fig:unnamed-chunk-12)Plot of wAFROC effect size vs. ROC effect size. The straight line fit through the origin has slope 2.169.</p>
</div>


The plot is linear and the intercept is close to zero. This makes it easy to implement an interpolation function. In the following code line 1 fits `eswAFROC` vs. `esROC` using a linear model `lm()` function constrained to pass through the origin (the "-1"). One expects this constraint since for `deltaMu = 0` the effect size must be zero no matter how it is measured. 


```{.r .numberLines}
scaleFactor <- lm(eswAFROC ~ -1 + esROC) # the "-1" fits to straight line through the origin
effectSizeROC <- seq(0.01, 0.0525, 0.0025) 
effectSizewAFROC <- effectSizeROC*scaleFactor$coefficients[1]
```


The slope of the zero-intercept constrained straight line fit is `scaleFactor` = 2.169 and the squared correlation coefficient is `R2` = 0.9999904 (the fit is very good). Therefore, the conversion from ROC to wAFROC effect size is: 

```
effectSizewAFROC = scaleFactor * effectSizeROC
```

**For this dataset the wAFROC effect size is 2.169 times the ROC effect size.** The wAFROC effect size is expected to be larger than the ROC effect size because the range of wAFROC-AUC, $1-0=1$, is twice that of ROC-AUC, $1-0.5=0.5$.


### ROC and wAFROC variance components

The following skeleton code shows the arguments of the function `UtilVarComponentsOR` used to calculate the OR variance components.

```
UtilVarComponentsOR(
  dataset,
  FOM,
  FPFValue = 0.2,
  covEstMethod = "jackknife",
  nBoots = 200,
  seed = NULL
)
```

`UtilVarComponentsOR()` is applied to `rocDataNH` and `frocDataNH` (using "Wilcoxon" and "wAFROC" FOMs respectively) followed by the extraction of the two OR variance components.



```{.r .numberLines}
varComp_roc <- UtilVarComponentsOR(
  rocDataNH, 
  FOM = "Wilcoxon")$VarCom[-2]

varComp_wafroc <- UtilVarComponentsOR(
  frocDataNH, 
  FOM = "wAFROC")$VarCom[-2]
```


VarCom[-2] removes the second column of each dataframe containing the correlations. The ROC and wAFROC variance components are:



```
##                ROC        wAFROC
## VarR  0.0008277380  0.0018542289
## VarTR 0.0001526507 -0.0004439279
## Cov1  0.0002083377  0.0003736844
## Cov2  0.0002388384  0.0003567162
## Cov3  0.0001906167  0.0003058902
## Var   0.0007307912  0.0009081383
```



### ROC and wAFROC power for equivalent effect-sizes

We compare ROC and wAFROC random-reader random-case (RRRC) powers for equivalent effect sizes.  



```{.r .numberLines}
# these are OR variance components assuming FOM = "Wilcoxon"
varR_roc <- varComp_roc["VarR","Estimates"]
varTR_roc <- varComp_roc["VarTR","Estimates"]
Cov1_roc <- varComp_roc["Cov1","Estimates"]
Cov2_roc <- varComp_roc["Cov2","Estimates"]
Cov3_roc <- varComp_roc["Cov3","Estimates"]
Var_roc <- varComp_roc["Var","Estimates"]

# these are OR variance components assuming FOM = "wAFROC"
varR_wafroc <- varComp_wafroc["VarR","Estimates"]
varTR_wafroc <- varComp_wafroc["VarTR","Estimates"]
Cov1_wafroc <- varComp_wafroc["Cov1","Estimates"]
Cov2_wafroc <- varComp_wafroc["Cov2","Estimates"]
Cov3_wafroc <- varComp_wafroc["Cov3","Estimates"]
Var_wafroc <- varComp_wafroc["Var","Estimates"]

power_roc <- array(dim = length(effectSizeROC))
power_wafroc <- array(dim = length(effectSizeROC))

JPivot <- 5;KPivot <- 100
for (i in 1:length(effectSizeROC)) {
  
  # compute ROC power
  ret <- SsPowerGivenJK(
    dataset = NULL, 
    FOM = "Wilcoxon", 
    J = JPivot, 
    K = KPivot, 
    effectSize = effectSizeROC[i], 
    list(JStar = JStar, KStar = KStar, 
         VarTR = varTR_roc,
         Cov1 = Cov1_roc,
         Cov2 = Cov2_roc,
         Cov3 = Cov3_roc,
         Var = Var_roc))
  power_roc[i] <- ret$powerRRRC
  
  # compute wAFROC power
  ret <- SsPowerGivenJK(
    dataset = NULL, 
    FOM = "wAFROC", 
    J = JPivot, 
    K = KPivot, 
    effectSize = effectSizewAFROC[i], 
    list(JStar = JStar, KStar = KStar, 
         VarTR = varTR_wafroc,
         Cov1 = Cov1_wafroc,
         Cov2 = Cov2_wafroc,
         Cov3 = Cov3_wafroc,
         Var = Var_wafroc))
  power_wafroc[i] <- ret$powerRRRC
  
  if (i == 11)
  cat("effectSizeROC[i] = ", effectSizeROC[i],
      "\neffectSizewAFROC[i] = ", effectSizewAFROC[i],
      "\npower_roc[i] = ", power_roc[i],
      "\npower_wafroc[i] = ", power_wafroc[i], "\n")  
}
```

```
## effectSizeROC[i] =  0.035 
## effectSizewAFROC[i] =  0.07592683 
## power_roc[i] =  0.2342887 
## power_wafroc[i] =  0.7972542
```


Lines 2-4 extract the variance components using the ROC-AUC figure of merit. Lines 7-9 extract the variance components using the wAFROC-AUC figure of merit. These are passed to `SsPowerGivenJK` at lines 27 and 30, respectively. Line 14 defines the number of readers and cases in the pivotal study. The for-loop calculates ROC power (line 28) and wAFROC power (line 31).

Since the wAFROC effect size is 2.169 times the ROC effect size, wAFROC power is larger than that for ROC. For example, for ROC effect size = 0.035 the wAFROC effect size is 0.076, the ROC power is 0.234 while the wAFROC power is 0.797. The influence of the increased wAFROC effect size is magnified as it enters as the square in the formula for statistical power: this overwhelms the increase, noted previously, in variability of wAFROC-AUC relative to ROC-AUC 

The following is a plot of the respective powers.


<div class="figure" style="text-align: center">
<img src="19-froc-sample-size_files/figure-html/unnamed-chunk-17-1.png" alt="Plot of wAFROC power vs. ROC power. For ROC effect size = 0.035 the wAFROC effect size is 0.0759, the ROC power is 0.234 while the wAFROC power is 0.797" width="672" />
<p class="caption">(\#fig:unnamed-chunk-17)Plot of wAFROC power vs. ROC power. For ROC effect size = 0.035 the wAFROC effect size is 0.0759, the ROC power is 0.234 while the wAFROC power is 0.797</p>
</div>





## Part 2

### Introduction

This example uses the FED dataset as a pilot FROC study and function `SsFrocNhRsmModel()` to construct the NH model (encapsulating some of the code in the first part).


### Constructing the NH model for the dataset

One starts by extracting the first two treatments from `dataset04`, which represent the NH dataset. Next one constructs the NH model. `lesDistr` can be specified independent of that in the pilot dataset. This allows some control over selection of the diseased cases in the pivotal study. However, in this example it is simply extracted from the pilot dataset (line 2). Line 3 applies the function `SsFrocNhRsmModel` to calculate the NH RSM parameters and the scale factor.


```{.r .numberLines}
frocNhData <- DfExtractDataset(dataset04, trts = c(1,2))
lesDistr <- UtilLesDistr(frocNhData) # this can be replaced by the anticipated lesion distribution
ret <- SsFrocNhRsmModel(frocNhData, lesDistr = lesDistr$Freq)
```

```
## i =  1 , j =  1 , auc_fit =  0.9064227 
## i =  1 , j =  2 , auc_fit =  0.8020747 
## i =  1 , j =  3 , auc_fit =  0.8218974 
## i =  1 , j =  4 , auc_fit =  0.918135 
## i =  2 , j =  1 , auc_fit =  0.8614774 
## i =  2 , j =  2 , auc_fit =  0.8572513 
## i =  2 , j =  3 , auc_fit =  0.8180308 
## i =  2 , j =  4 , auc_fit =  0.8756009 
## i =  1 , j =  1 , auc_emp =  0.90425 
## i =  1 , j =  2 , auc_emp =  0.7982 
## i =  1 , j =  3 , auc_emp =  0.81175 
## i =  1 , j =  4 , auc_emp =  0.86645 
## i =  2 , j =  1 , auc_emp =  0.86425 
## i =  2 , j =  2 , auc_emp =  0.8447 
## i =  2 , j =  3 , auc_emp =  0.8205 
## i =  2 , j =  4 , auc_emp =  0.8716
```

```{.r .numberLines}
muNH <- ret$mu
lambdaNH <- ret$lambda
nuNH <- ret$nu
scaleFactor <- ret$scaleFactor
```


The fitting model is defined by `muNH` = 3.3121519,  `lambdaNH` = 1.714368  and  `nuNH` = 0.7036564 and `lesDistr$Freq` = 0.69, 0.2, 0.11. The effect size scale factor is `scaleFactor` = 2.1693379. All of these are identical to the Part I values.


### Extract the wAFROC variance components  {#froc-sample-size-variance-components}

The code applies `StSignificanceTesting()` to `frocNhData`, using `FOM = "wAFROC"` and extracts the variance components.


```r
varComp_wafroc  <- StSignificanceTesting(
  frocNhData, 
  FOM = "wAFROC", 
  method = "OR", 
  analysisOption = "RRRC")$ANOVA$VarCom
```


### wAFROC power for specified ROC effect size, number of readers and number of cases

The following example is for ROC effect size = 0.05, 5 readers (`J = 5`) and 100 cases (`K = 100`) in the **pivotal study**. 

```
SsPowerGivenJK(
  dataset,
  ...,
  FOM,
  J,
  K,
  effectSize = NULL,
  alpha = 0.05
)
```

The function `SsPowerGivenJK` used below returns the power for specified effect size, numbers of readers and cases, and variance components (supplied as a `list` via the `...` argument   - see TBA lines xx and yy of following code). The default arguments of this function are: 

```
method = "OR" 
analysisOption = "RRRC" 
LegacyCode = FALSE
```



```{.r .numberLines}
effectSizeROC <- 0.05
effectSizewAFROC <- scaleFactor * effectSizeROC

J <- 5;K <- 100 # define pivotal study sample size

ret <- SsPowerGivenJK(
  dataset = NULL, 
  FOM = "wAFROC", 
  J = J, 
  K = K, 
  effectSize = effectSizewAFROC, 
    list(JStar = JStar, KStar = KStar, 
         VarTR = varTR_wafroc,
         Cov1 = Cov1_wafroc,
         Cov2 = Cov2_wafroc,
         Cov3 = Cov3_wafroc,
         Var = Var_wafroc))
power_wafroc <- ret$powerRRRC

cat("ROC-ES = ", effectSizeROC, 
    ", wAFROC-ES = ", effectSizeROC * scaleFactor, 
    ", Power-wAFROC = ", power_wafroc, "\n")
```

```
## ROC-ES =  0.05 , wAFROC-ES =  0.10846689 , Power-wAFROC =  0.97777633
```


### Number of cases for 80 percent power for a given number of readers

```
SsSampleSizeKGivenJ(
  dataset,
  ...,
  J,
  FOM,
  effectSize = NULL,
  alpha = 0.05,
  desiredPower = 0.8,
)
```

The function `SsSampleSizeKGivenJ` returns the number of cases needed for desired power = 0.8 for wAFROC effect size as just listed and wAFROC variance components computed in Section \@ref(froc-sample-size-variance-components).



```{.r .numberLines}
ret2 <- SsSampleSizeKGivenJ(
  dataset = NULL, 
  J = 6, 
  effectSize = effectSizewAFROC, 
  list(JStar = JStar, KStar = KStar, 
       VarTR = varTR_wafroc,
       Cov1 = Cov1_wafroc,
       Cov2 = Cov2_wafroc,
       Cov3 = Cov3_wafroc,
       Var = Var_wafroc))

cat("ROC-ES = ", effectSizeROC, 
    ", wAFROC-ES = ", effectSizeROC * scaleFactor, 
    ", K80RRRC = ", ret2$KRRRC, 
    ", Power-wAFROC = ", ret2$powerRRRC, "\n")
```

```
## ROC-ES =  0.05 , wAFROC-ES =  0.10846689 , K80RRRC =  41 , Power-wAFROC =  0.80087319
```


Here `K80RRRC` is the number of cases needed for 80 percent power under RRRC analysis.

## Part 3


What follows is an application of the method to all my available FROC datasets. If more than two treatments are present two analyses were conducted: one using all treatments and one using NH not-rejecting treatments only (abbreviated to NH-NR). Note that ROC effect sizes were varied between the two analyses to keep the FROC power close to 80 percent. In all reported analyses J = 5 readers and K = 100 cases are assumed in the pivotal study.



### TONY dataset

This dataset has only two treatments; therefore a single analyses using both treatments is reported.



```
## dataset =  dataset01 , Name =  TONY , I =  2 , J =  5
```

```
## i =  1 , j =  1 , auc_fit =  0.81320811 
## i =  1 , j =  2 , auc_fit =  0.89297244 
## i =  1 , j =  3 , auc_fit =  0.85216738 
## i =  1 , j =  4 , auc_fit =  0.86366416 
## i =  1 , j =  5 , auc_fit =  0.85254301 
## i =  2 , j =  1 , auc_fit =  0.67851336 
## i =  2 , j =  2 , auc_fit =  0.75783952 
## i =  2 , j =  3 , auc_fit =  0.79264791 
## i =  2 , j =  4 , auc_fit =  0.88450139 
## i =  2 , j =  5 , auc_fit =  0.74064002 
## i =  1 , j =  1 , auc_emp =  0.79599719 
## i =  1 , j =  2 , auc_emp =  0.86522706 
## i =  1 , j =  3 , auc_emp =  0.84117509 
## i =  1 , j =  4 , auc_emp =  0.83110955 
## i =  1 , j =  5 , auc_emp =  0.84655899 
## i =  2 , j =  1 , auc_emp =  0.66894897 
## i =  2 , j =  2 , auc_emp =  0.72144195 
## i =  2 , j =  3 , auc_emp =  0.78411751 
## i =  2 , j =  4 , auc_emp =  0.79792837 
## i =  2 , j =  5 , auc_emp =  0.70610955
```

```
## $effectSizeROC
## [1] 0.07
## 
## $scaleFactor
## [1] 1.6123687
## 
## $powerRoc
## [1] 0.36353662
## 
## $powerFroc
## [1] 0.7648341
```

### FED dataset, all data and NH-NR treatments only

This dataset has five treatments; therefore two results are reported: one using all treatments and one using NH not-rejecting treatments only, i.e., `DfExtractDataset(ds, trts = c(1,2))`. 


```
## dataset =  dataset04 , Name =  FEDERICA , I =  5 , J =  4
```

```
## All data
```

```
## i =  1 , j =  1 , auc_fit =  0.90642269 
## i =  1 , j =  2 , auc_fit =  0.80207475 
## i =  1 , j =  3 , auc_fit =  0.8218974 
## i =  1 , j =  4 , auc_fit =  0.91813497 
## i =  2 , j =  1 , auc_fit =  0.86147739 
## i =  2 , j =  2 , auc_fit =  0.85725131 
## i =  2 , j =  3 , auc_fit =  0.81803076 
## i =  2 , j =  4 , auc_fit =  0.87560092 
## i =  3 , j =  1 , auc_fit =  0.833631 
## i =  3 , j =  2 , auc_fit =  0.81916445 
## i =  3 , j =  3 , auc_fit =  0.76576686 
## i =  3 , j =  4 , auc_fit =  0.88054732 
## i =  4 , j =  1 , auc_fit =  0.90974249 
## i =  4 , j =  2 , auc_fit =  0.84345538 
## i =  4 , j =  3 , auc_fit =  0.81205624 
## i =  4 , j =  4 , auc_fit =  0.88691319 
## i =  5 , j =  1 , auc_fit =  0.85339208 
## i =  5 , j =  2 , auc_fit =  0.78998846 
## i =  5 , j =  3 , auc_fit =  0.78020812 
## i =  5 , j =  4 , auc_fit =  0.88621727 
## i =  1 , j =  1 , auc_emp =  0.90425 
## i =  1 , j =  2 , auc_emp =  0.7982 
## i =  1 , j =  3 , auc_emp =  0.81175 
## i =  1 , j =  4 , auc_emp =  0.86645 
## i =  2 , j =  1 , auc_emp =  0.86425 
## i =  2 , j =  2 , auc_emp =  0.8447 
## i =  2 , j =  3 , auc_emp =  0.8205 
## i =  2 , j =  4 , auc_emp =  0.8716 
## i =  3 , j =  1 , auc_emp =  0.81295 
## i =  3 , j =  2 , auc_emp =  0.81635 
## i =  3 , j =  3 , auc_emp =  0.75275 
## i =  3 , j =  4 , auc_emp =  0.8573 
## i =  4 , j =  1 , auc_emp =  0.90235 
## i =  4 , j =  2 , auc_emp =  0.8315 
## i =  4 , j =  3 , auc_emp =  0.78865 
## i =  4 , j =  4 , auc_emp =  0.8798 
## i =  5 , j =  1 , auc_emp =  0.8414 
## i =  5 , j =  2 , auc_emp =  0.773 
## i =  5 , j =  3 , auc_emp =  0.77115 
## i =  5 , j =  4 , auc_emp =  0.848
```

```
## $effectSizeROC
## [1] 0.04
## 
## $scaleFactor
## [1] 1.8536914
## 
## $powerRoc
## [1] 0.34678954
## 
## $powerFroc
## [1] 0.80813385
```

```
## Note change in effect size in next analysis
```

```
## NH-NR treatments only: trts = c(1,2)
```

```
## i =  1 , j =  1 , auc_fit =  0.90642269 
## i =  1 , j =  2 , auc_fit =  0.80207475 
## i =  1 , j =  3 , auc_fit =  0.8218974 
## i =  1 , j =  4 , auc_fit =  0.91813497 
## i =  2 , j =  1 , auc_fit =  0.86147739 
## i =  2 , j =  2 , auc_fit =  0.85725131 
## i =  2 , j =  3 , auc_fit =  0.81803076 
## i =  2 , j =  4 , auc_fit =  0.87560092 
## i =  1 , j =  1 , auc_emp =  0.90425 
## i =  1 , j =  2 , auc_emp =  0.7982 
## i =  1 , j =  3 , auc_emp =  0.81175 
## i =  1 , j =  4 , auc_emp =  0.86645 
## i =  2 , j =  1 , auc_emp =  0.86425 
## i =  2 , j =  2 , auc_emp =  0.8447 
## i =  2 , j =  3 , auc_emp =  0.8205 
## i =  2 , j =  4 , auc_emp =  0.8716
```

```
## $effectSizeROC
## [1] 0.035
## 
## $scaleFactor
## [1] 2.1693379
## 
## $powerRoc
## [1] 0.23428872
## 
## $powerFroc
## [1] 0.79725425
```


### THOMPSON dataset

This dataset has only two treatments; therefore a single analyses using both treatments is reported.



```
## dataset =  dataset05 , Name =  THOMPSON , I =  2 , J =  9
```

```
## i =  1 , j =  1 , auc_fit =  0.88272773 
## i =  1 , j =  2 , auc_fit =  0.9062648 
## i =  1 , j =  3 , auc_fit =  0.9037888 
## i =  1 , j =  4 , auc_fit =  0.71060357 
## i =  1 , j =  5 , auc_fit =  0.73045109 
## i =  1 , j =  6 , auc_fit =  0.9470677 
## i =  1 , j =  7 , auc_fit =  0.92420887 
## i =  1 , j =  8 , auc_fit =  0.89485093 
## i =  1 , j =  9 , auc_fit =  0.85862397 
## i =  2 , j =  1 , auc_fit =  0.86139429 
## i =  2 , j =  2 , auc_fit =  0.96800376 
## i =  2 , j =  3 , auc_fit =  0.91156383 
## i =  2 , j =  4 , auc_fit =  0.87547532 
## i =  2 , j =  5 , auc_fit =  0.89362437 
## i =  2 , j =  6 , auc_fit =  0.94049993 
## i =  2 , j =  7 , auc_fit =  0.96654775 
## i =  2 , j =  8 , auc_fit =  0.94004632 
## i =  2 , j =  9 , auc_fit =  0.88440213 
## i =  1 , j =  1 , auc_emp =  0.87777778 
## i =  1 , j =  2 , auc_emp =  0.89361702 
## i =  1 , j =  3 , auc_emp =  0.89101655 
## i =  1 , j =  4 , auc_emp =  0.73900709 
## i =  1 , j =  5 , auc_emp =  0.71678487 
## i =  1 , j =  6 , auc_emp =  0.93427896 
## i =  1 , j =  7 , auc_emp =  0.91985816 
## i =  1 , j =  8 , auc_emp =  0.88345154 
## i =  1 , j =  9 , auc_emp =  0.821513 
## i =  2 , j =  1 , auc_emp =  0.89787234 
## i =  2 , j =  2 , auc_emp =  0.97612293 
## i =  2 , j =  3 , auc_emp =  0.88321513 
## i =  2 , j =  4 , auc_emp =  0.85130024 
## i =  2 , j =  5 , auc_emp =  0.86004728 
## i =  2 , j =  6 , auc_emp =  0.91040189 
## i =  2 , j =  7 , auc_emp =  0.95413712 
## i =  2 , j =  8 , auc_emp =  0.93522459 
## i =  2 , j =  9 , auc_emp =  0.86122931
```

```
## $effectSizeROC
## [1] 0.05
## 
## $scaleFactor
## [1] 1.7822813
## 
## $powerRoc
## [1] 0.36427919
## 
## $powerFroc
## [1] 0.77624968
```


### MAGNUS dataset

This dataset has only two treatments; therefore a single analyses using both treatments is reported.



```
## dataset =  dataset06 , Name =  MAGNUS , I =  2 , J =  4
```

```
## i =  1 , j =  1 , auc_fit =  0.77715868 
## i =  1 , j =  2 , auc_fit =  0.77206487 
## i =  1 , j =  3 , auc_fit =  0.69167096 
## i =  1 , j =  4 , auc_fit =  0.77898683 
## i =  2 , j =  1 , auc_fit =  0.64293651 
## i =  2 , j =  2 , auc_fit =  0.60213318 
## i =  2 , j =  3 , auc_fit =  0.66496703 
## i =  2 , j =  4 , auc_fit =  0.66434528 
## i =  1 , j =  1 , auc_emp =  0.76089159 
## i =  1 , j =  2 , auc_emp =  0.76646403 
## i =  1 , j =  3 , auc_emp =  0.69528875 
## i =  1 , j =  4 , auc_emp =  0.77330294 
## i =  2 , j =  1 , auc_emp =  0.64387031 
## i =  2 , j =  2 , auc_emp =  0.63779129 
## i =  2 , j =  3 , auc_emp =  0.66109422 
## i =  2 , j =  4 , auc_emp =  0.65450861
```

```
## $effectSizeROC
## [1] 0.05
## 
## $scaleFactor
## [1] 2.2393454
## 
## $powerRoc
## [1] 0.26755435
## 
## $powerFroc
## [1] 0.86438847
```

### LUCY dataset, all data and NH-NR treatments only

This dataset has five treatments; therefore two results are reported: one using all treatments and one using NH not-rejecting treatments only, i.e., `DfExtractDataset(ds, trts = c(1,5))`. 


```
## dataset =  dataset07 , Name =  LUCY-WARREN , I =  5 , J =  7
```

```
## All data
```

```
## i =  1 , j =  1 , auc_fit =  0.92443077 
## i =  1 , j =  2 , auc_fit =  0.92662846 
## i =  1 , j =  3 , auc_fit =  0.93035909 
## i =  1 , j =  4 , auc_fit =  0.92240506 
## i =  1 , j =  5 , auc_fit =  0.94115783 
## i =  1 , j =  6 , auc_fit =  0.89202726 
## i =  1 , j =  7 , auc_fit =  0.92725059 
## i =  2 , j =  1 , auc_fit =  0.83222824 
## i =  2 , j =  2 , auc_fit =  0.77120537 
## i =  2 , j =  3 , auc_fit =  0.80143356 
## i =  2 , j =  4 , auc_fit =  0.81258682 
## i =  2 , j =  5 , auc_fit =  0.79528951 
## i =  2 , j =  6 , auc_fit =  0.76957212 
## i =  2 , j =  7 , auc_fit =  0.8380247 
## i =  3 , j =  1 , auc_fit =  0.83956951 
## i =  3 , j =  2 , auc_fit =  0.86330632 
## i =  3 , j =  3 , auc_fit =  0.83736256 
## i =  3 , j =  4 , auc_fit =  0.84918654 
## i =  3 , j =  5 , auc_fit =  0.78596289 
## i =  3 , j =  6 , auc_fit =  0.80997033 
## i =  3 , j =  7 , auc_fit =  0.84255768 
## i =  4 , j =  1 , auc_fit =  0.69665333 
## i =  4 , j =  2 , auc_fit =  0.74881025 
## i =  4 , j =  3 , auc_fit =  0.79628601 
## i =  4 , j =  4 , auc_fit =  0.70853506 
## i =  4 , j =  5 , auc_fit =  0.68957035 
## i =  4 , j =  6 , auc_fit =  0.72654471 
## i =  4 , j =  7 , auc_fit =  0.73037997 
## i =  5 , j =  1 , auc_fit =  0.9275249 
## i =  5 , j =  2 , auc_fit =  0.85723107 
## i =  5 , j =  3 , auc_fit =  0.9136363 
## i =  5 , j =  4 , auc_fit =  0.92429948 
## i =  5 , j =  5 , auc_fit =  0.9313687 
## i =  5 , j =  6 , auc_fit =  0.88742146 
## i =  5 , j =  7 , auc_fit =  0.95761787 
## i =  1 , j =  1 , auc_emp =  0.91327542 
## i =  1 , j =  2 , auc_emp =  0.90230148 
## i =  1 , j =  3 , auc_emp =  0.92363969 
## i =  1 , j =  4 , auc_emp =  0.91327542 
## i =  1 , j =  5 , auc_emp =  0.92546868 
## i =  1 , j =  6 , auc_emp =  0.87806737 
## i =  1 , j =  7 , auc_emp =  0.91243713 
## i =  2 , j =  1 , auc_emp =  0.81153788 
## i =  2 , j =  2 , auc_emp =  0.75247676 
## i =  2 , j =  3 , auc_emp =  0.79279073 
## i =  2 , j =  4 , auc_emp =  0.80262155 
## i =  2 , j =  5 , auc_emp =  0.78875171 
## i =  2 , j =  6 , auc_emp =  0.75765889 
## i =  2 , j =  7 , auc_emp =  0.83180918 
## i =  3 , j =  1 , auc_emp =  0.82708429 
## i =  3 , j =  2 , auc_emp =  0.80140223 
## i =  3 , j =  3 , auc_emp =  0.82616979 
## i =  3 , j =  4 , auc_emp =  0.84484073 
## i =  3 , j =  5 , auc_emp =  0.77922573 
## i =  3 , j =  6 , auc_emp =  0.80483158 
## i =  3 , j =  7 , auc_emp =  0.83737235 
## i =  4 , j =  1 , auc_emp =  0.67390642 
## i =  4 , j =  2 , auc_emp =  0.66468526 
## i =  4 , j =  3 , auc_emp =  0.75605853 
## i =  4 , j =  4 , auc_emp =  0.70583752 
## i =  4 , j =  5 , auc_emp =  0.68602347 
## i =  4 , j =  6 , auc_emp =  0.71574455 
## i =  4 , j =  7 , auc_emp =  0.71848804 
## i =  5 , j =  1 , auc_emp =  0.91624752 
## i =  5 , j =  2 , auc_emp =  0.85322359 
## i =  5 , j =  3 , auc_emp =  0.90900777 
## i =  5 , j =  4 , auc_emp =  0.92386831 
## i =  5 , j =  5 , auc_emp =  0.92691663 
## i =  5 , j =  6 , auc_emp =  0.87882945 
## i =  5 , j =  7 , auc_emp =  0.95534217
```

```
## $effectSizeROC
## [1] 0.06
## 
## $scaleFactor
## [1] 1.6842733
## 
## $powerRoc
## [1] 0.56994854
## 
## $powerFroc
## [1] 0.73874483
```

```
## Note change in effect size in next analysis
```

```
## NH-NR treatments only: trts = c(1,5)
```

```
## i =  1 , j =  1 , auc_fit =  0.92443077 
## i =  1 , j =  2 , auc_fit =  0.92662846 
## i =  1 , j =  3 , auc_fit =  0.93035909 
## i =  1 , j =  4 , auc_fit =  0.92240506 
## i =  1 , j =  5 , auc_fit =  0.94115783 
## i =  1 , j =  6 , auc_fit =  0.89202726 
## i =  1 , j =  7 , auc_fit =  0.92725059 
## i =  2 , j =  1 , auc_fit =  0.9275249 
## i =  2 , j =  2 , auc_fit =  0.85723107 
## i =  2 , j =  3 , auc_fit =  0.9136363 
## i =  2 , j =  4 , auc_fit =  0.92429948 
## i =  2 , j =  5 , auc_fit =  0.9313687 
## i =  2 , j =  6 , auc_fit =  0.88742146 
## i =  2 , j =  7 , auc_fit =  0.95761787 
## i =  1 , j =  1 , auc_emp =  0.91327542 
## i =  1 , j =  2 , auc_emp =  0.90230148 
## i =  1 , j =  3 , auc_emp =  0.92363969 
## i =  1 , j =  4 , auc_emp =  0.91327542 
## i =  1 , j =  5 , auc_emp =  0.92546868 
## i =  1 , j =  6 , auc_emp =  0.87806737 
## i =  1 , j =  7 , auc_emp =  0.91243713 
## i =  2 , j =  1 , auc_emp =  0.91624752 
## i =  2 , j =  2 , auc_emp =  0.85322359 
## i =  2 , j =  3 , auc_emp =  0.90900777 
## i =  2 , j =  4 , auc_emp =  0.92386831 
## i =  2 , j =  5 , auc_emp =  0.92691663 
## i =  2 , j =  6 , auc_emp =  0.87882945 
## i =  2 , j =  7 , auc_emp =  0.95534217
```

```
## $effectSizeROC
## [1] 0.04
## 
## $scaleFactor
## [1] 1.5780687
## 
## $powerRoc
## [1] 0.50730142
## 
## $powerFroc
## [1] 0.79668794
```

### DOBBINS-1 dataset, all data and NH-NR treatments only

Note: this dataset revealed issues with the RSM fitting program, namely the number of ROC operating points sometimes falls below 3, the minimum required. 

<div class="figure" style="text-align: center">
<img src="images/froc-sample-size/ds11trt1rdr3.png" alt="RSM fitted ROC plot for dataset11, treatment 1 and reader 3. Note the two defining operating points near the origin. " width="50%" height="20%" />
<p class="caption">(\#fig:froc-sample-size-dataset11)RSM fitted ROC plot for dataset11, treatment 1 and reader 3. Note the two defining operating points near the origin. </p>
</div>


This dataset has four treatments; therefore two results are reported: one using all treatments and one using NH not-rejecting treatments only, i.e., `DfExtractDataset(ds, trts = c(1,3,4))`. 


```
## dataset =  dataset11 , Name =  DOBBINS-1 , I =  4 , J =  5
```

```
## All data
```

```
## i =  1 , j =  1 , auc_fit =  0.67439464 
## i =  1 , j =  2 , auc_fit =  0.57216533 
## i =  1 , j =  3 , auc_fit =  0.76551521 
## i =  1 , j =  4 , auc_fit =  0.62336712 
## i =  1 , j =  5 , auc_fit =  0.63074583 
## i =  2 , j =  1 , auc_fit =  0.65292326 
## i =  2 , j =  2 , auc_fit =  0.5839868 
## i =  2 , j =  3 , auc_fit =  0.72767107 
## i =  2 , j =  4 , auc_fit =  0.6267011 
## i =  2 , j =  5 , auc_fit =  0.65878672 
## i =  3 , j =  1 , auc_fit =  0.76377503 
## i =  3 , j =  2 , auc_fit =  0.72222439 
## i =  3 , j =  3 , auc_fit =  0.81858627 
## i =  3 , j =  4 , auc_fit =  0.74488181 
## i =  3 , j =  5 , auc_fit =  0.88485947 
## i =  4 , j =  1 , auc_fit =  0.72950846 
## i =  4 , j =  2 , auc_fit =  0.72674767 
## i =  4 , j =  3 , auc_fit =  0.81921867 
## i =  4 , j =  4 , auc_fit =  0.69733661 
## i =  4 , j =  5 , auc_fit =  0.88512912 
## i =  1 , j =  1 , auc_emp =  0.65267947 
## i =  1 , j =  2 , auc_emp =  0.56744186 
## i =  1 , j =  3 , auc_emp =  0.6008089 
## i =  1 , j =  4 , auc_emp =  0.57633974 
## i =  1 , j =  5 , auc_emp =  0.63185035 
## i =  2 , j =  1 , auc_emp =  0.64944388 
## i =  2 , j =  2 , auc_emp =  0.58078868 
## i =  2 , j =  3 , auc_emp =  0.63043478 
## i =  2 , j =  4 , auc_emp =  0.59373104 
## i =  2 , j =  5 , auc_emp =  0.67623862 
## i =  3 , j =  1 , auc_emp =  0.73892821 
## i =  3 , j =  2 , auc_emp =  0.72072801 
## i =  3 , j =  3 , auc_emp =  0.74368049 
## i =  3 , j =  4 , auc_emp =  0.72750253 
## i =  3 , j =  5 , auc_emp =  0.73993933 
## i =  4 , j =  1 , auc_emp =  0.71466127 
## i =  4 , j =  2 , auc_emp =  0.72659252 
## i =  4 , j =  3 , auc_emp =  0.75642063 
## i =  4 , j =  4 , auc_emp =  0.68058645 
## i =  4 , j =  5 , auc_emp =  0.73973711
```

```
## $effectSizeROC
## [1] 0.07
## 
## $scaleFactor
## [1] 1.2364946
## 
## $powerRoc
## [1] 0.57062501
## 
## $powerFroc
## [1] 0.82193932
```

```
## NH-NR treatments only: trts = c(1,3,4)
```

```
## i =  1 , j =  1 , auc_fit =  0.67439464 
## i =  1 , j =  2 , auc_fit =  0.57216533 
## i =  1 , j =  3 , auc_fit =  0.76551521 
## i =  1 , j =  4 , auc_fit =  0.62336712 
## i =  1 , j =  5 , auc_fit =  0.63074583 
## i =  2 , j =  1 , auc_fit =  0.76377503 
## i =  2 , j =  2 , auc_fit =  0.72222439 
## i =  2 , j =  3 , auc_fit =  0.81858627 
## i =  2 , j =  4 , auc_fit =  0.74488181 
## i =  2 , j =  5 , auc_fit =  0.88485947 
## i =  3 , j =  1 , auc_fit =  0.72950846 
## i =  3 , j =  2 , auc_fit =  0.72674767 
## i =  3 , j =  3 , auc_fit =  0.81921867 
## i =  3 , j =  4 , auc_fit =  0.69733661 
## i =  3 , j =  5 , auc_fit =  0.88512912 
## i =  1 , j =  1 , auc_emp =  0.65267947 
## i =  1 , j =  2 , auc_emp =  0.56744186 
## i =  1 , j =  3 , auc_emp =  0.6008089 
## i =  1 , j =  4 , auc_emp =  0.57633974 
## i =  1 , j =  5 , auc_emp =  0.63185035 
## i =  2 , j =  1 , auc_emp =  0.73892821 
## i =  2 , j =  2 , auc_emp =  0.72072801 
## i =  2 , j =  3 , auc_emp =  0.74368049 
## i =  2 , j =  4 , auc_emp =  0.72750253 
## i =  2 , j =  5 , auc_emp =  0.73993933 
## i =  3 , j =  1 , auc_emp =  0.71466127 
## i =  3 , j =  2 , auc_emp =  0.72659252 
## i =  3 , j =  3 , auc_emp =  0.75642063 
## i =  3 , j =  4 , auc_emp =  0.68058645 
## i =  3 , j =  5 , auc_emp =  0.73973711
```

```
## $effectSizeROC
## [1] 0.07
## 
## $scaleFactor
## [1] 1.4194065
## 
## $powerRoc
## [1] 0.59643607
## 
## $powerFroc
## [1] 0.90850449
```

### DOBBINS-3 dataset, all data and NH-NR treatments only


This dataset has four treatments; therefore two results are reported: one using all treatments and one using NH not-rejecting treatments only, i.e., `DfExtractDataset(ds, trts = c(3,4))`. 



```
## dataset =  dataset13 , Name =  DOBBINS-3 , I =  4 , J =  5
```

```
## All data
```

```
## i =  1 , j =  1 , auc_fit =  0.6286507 
## i =  1 , j =  2 , auc_fit =  0.50151767 
## i =  1 , j =  3 , auc_fit =  0.65441117 
## i =  1 , j =  4 , auc_fit =  0.58280829 
## i =  1 , j =  5 , auc_fit =  0.55034173 
## i =  2 , j =  1 , auc_fit =  0.5412335 
## i =  2 , j =  2 , auc_fit =  0.51912707 
## i =  2 , j =  3 , auc_fit =  0.60167519 
## i =  2 , j =  4 , auc_fit =  0.55377877 
## i =  2 , j =  5 , auc_fit =  0.5945155 
## i =  3 , j =  1 , auc_fit =  0.72457545 
## i =  3 , j =  2 , auc_fit =  0.63958975 
## i =  3 , j =  3 , auc_fit =  0.67463262 
## i =  3 , j =  4 , auc_fit =  0.65551867 
## i =  3 , j =  5 , auc_fit =  0.81562973 
## i =  4 , j =  1 , auc_fit =  0.62871077 
## i =  4 , j =  2 , auc_fit =  0.65208483 
## i =  4 , j =  3 , auc_fit =  0.7144378 
## i =  4 , j =  4 , auc_fit =  0.5999756 
## i =  4 , j =  5 , auc_fit =  0.67920293 
## i =  1 , j =  1 , auc_emp =  0.57011974 
## i =  1 , j =  2 , auc_emp =  0.49619013 
## i =  1 , j =  3 , auc_emp =  0.54653483 
## i =  1 , j =  4 , auc_emp =  0.54889332 
## i =  1 , j =  5 , auc_emp =  0.55478955 
## i =  2 , j =  1 , auc_emp =  0.53120464 
## i =  2 , j =  2 , auc_emp =  0.49718795 
## i =  2 , j =  3 , auc_emp =  0.56685414 
## i =  2 , j =  4 , auc_emp =  0.53782656 
## i =  2 , j =  5 , auc_emp =  0.57148041 
## i =  3 , j =  1 , auc_emp =  0.63588534 
## i =  3 , j =  2 , auc_emp =  0.63724601 
## i =  3 , j =  3 , auc_emp =  0.67035559 
## i =  3 , j =  4 , auc_emp =  0.64350508 
## i =  3 , j =  5 , auc_emp =  0.64214441 
## i =  4 , j =  1 , auc_emp =  0.62490929 
## i =  4 , j =  2 , auc_emp =  0.62799347 
## i =  4 , j =  3 , auc_emp =  0.66736212 
## i =  4 , j =  4 , auc_emp =  0.58653846 
## i =  4 , j =  5 , auc_emp =  0.62626996
```

```
## $effectSizeROC
## [1] 0.07
## 
## $scaleFactor
## [1] 1.5820231
## 
## $powerRoc
## [1] 0.54481091
## 
## $powerFroc
## [1] 0.84284099
```

```
## Note change in effect size in next analysis
```

```
## NH-NR treatments only: trts = c(3,4)
```

```
## i =  1 , j =  1 , auc_fit =  0.72457545 
## i =  1 , j =  2 , auc_fit =  0.63958975 
## i =  1 , j =  3 , auc_fit =  0.67463262 
## i =  1 , j =  4 , auc_fit =  0.65551867 
## i =  1 , j =  5 , auc_fit =  0.81562973 
## i =  2 , j =  1 , auc_fit =  0.62871077 
## i =  2 , j =  2 , auc_fit =  0.65208483 
## i =  2 , j =  3 , auc_fit =  0.7144378 
## i =  2 , j =  4 , auc_fit =  0.5999756 
## i =  2 , j =  5 , auc_fit =  0.67920293 
## i =  1 , j =  1 , auc_emp =  0.63588534 
## i =  1 , j =  2 , auc_emp =  0.63724601 
## i =  1 , j =  3 , auc_emp =  0.67035559 
## i =  1 , j =  4 , auc_emp =  0.64350508 
## i =  1 , j =  5 , auc_emp =  0.64214441 
## i =  2 , j =  1 , auc_emp =  0.62490929 
## i =  2 , j =  2 , auc_emp =  0.62799347 
## i =  2 , j =  3 , auc_emp =  0.66736212 
## i =  2 , j =  4 , auc_emp =  0.58653846 
## i =  2 , j =  5 , auc_emp =  0.62626996
```

```
## $effectSizeROC
## [1] 0.03
## 
## $scaleFactor
## [1] 1.5437708
## 
## $powerRoc
## [1] 0.41346102
## 
## $powerFroc
## [1] 0.86247586
```



## Discussion

This chapter has described the procedure for FROC sample size estimation.

