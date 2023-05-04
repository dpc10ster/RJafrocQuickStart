# (PART\*) FROC sample size {-}


# FROC sample size estimation {#froc-sample-size}





## How much finished 80 percent {#froc-sample-size-how-much-finished}



## Overview

This chapter is split into two parts: 

* The first part details a step-by-step approach to FROC paradigm sample size estimation; 

* The second part encapsulates most of the details in a function `SsFrocNhRsmModel()`.



## Part 1

### Introduction {#froc-sample-size-intro}

FROC sample size estimation is not fundamentally different from the procedure outlined in Chapter \@ref(roc-sample-size-dbm) for the ROC paradigm. 

**A recapitulation of ROC sample size estimation** 

Based on analysis of a pilot ROC dataset and using a specified FOM, e.g., `FOM = Wilcoxon`, and either `method = "DBM"` or `method = "OR"` for significance testing, one estimates the intrinsic variability of the data expressed in terms of FOM variance components ^[For the DBM method these are the pseudovalue variance components while for OR method these are the FOM treatment-reader variance component and the FOM covariances.]. The second step is to specify a clinically realistic effect-size, e.g., the anticipated AUC difference between the two modalities ^[Resist the temptation to inflate this value, thereby guaranteeing adequate sample size even with few readers and cases and large variability]. 

TBA Given the variance components the sample size functions implemented in `RJafroc` (function names beginning with `Ss`) allow one to estimate the number of readers and cases necessary to detect (i.e., reject the null hypothesis) the modality AUC difference with probability no smaller than the Type II error rate $\beta$, typically chosen to be 20 percent - corresponding to at least 80 percent statistical power - while controlling the Type I error rate to no greater than $\alpha$, typically chosen to be 5 percent. 

>The preceding sentence may be confusing. One can always detect even a very small effect size by always rejecting the NH. However this would imply that almost identical treatments would always be declared different thereby increasing the NH rejection rate to 100 percent. Therefore it is important to control the NH rejection rate at a reasonably low level (e.g., 5 percent) while still maintaining the AG rejection rate at a reasonably high level (e.g., 80 percent).


**Summary of FROC sample size estimation** 

In FROC analysis the only difference, indeed the critical difference, is the choice of FOM; e.g., `FOM = "wAFROC"` instead of the inferred ROC-AUC, `FOM = "HrAuc"`. The FROC dataset is analyzed using the DBM (or the OR) method. This yields the necessary variance components (or the covariance matrix) of the wAFROC-AUC. Next one specifies the effect-size **in wAFROC-AUC units** and this requires care. The ROC-AUC has a historically well-known interpretation, namely it is the classification ability at separating diseased patients from non-diseased patients, while the wAFROC-AUC does not. Needed is a way of relating the effect-size in easily understood ROC-AUC units to one in wAFROC-AUC units. This requires a physical model, e.g., the RSM, that predicts both ROC and wAFROC curves and their corresponding AUCs.


1.	One chooses an ROC-AUC effect-size that is realistic, one that clinicians understand and can therefore participate in, in the effect-size postulation process. Lacking such information I recommend, based on past ROC studies, 0.03 as typical of a small effect size and 0.05 as typical of a moderate effect size.
2.	One converts the ROC effect-size to a wAFROC-AUC effect-size using the method described in the next section.
3.	One uses the sample size tools in `RJafroc` to determine sample size for a desired statistical power. 


>**It is important to recognize is that all quantities have to be in the same units**. When performing ROC analysis, everything (variance components and effect-size) has to be in units of the selected FOM, e.g., `FOM = "Wilcoxon"`. When doing wAFROC analysis, everything has to be in units of the wAFROC-AUC, i.e., `FOM = "wAFROC"`. The variance components and effect-size in wAFROC-AUC units will be different from their corresponding ROC counterparts. In particular, as shown next, an ROC-AUC effect-size of 0.05 generally corresponds to a larger effect-size in wAFROC-AUC units. The reason for this is that the range over which wAFROC-AUC can vary, namely 0 to 1, is twice the corresponding ROC-AUC range (0.5 to 1). For the same reason the wAFROC variance components also tend to be larger than the ROC variance components.


The next section explains the steps used to implement #2 above. 

### Relating an ROC effect-size to a wAFROC effect-size

This chapter uses the *first two* treatments of `dataset04` as defining the NH. This is a 5 treatment, 4 radiologist and 200 case FROC dataset [@zanca2009evaluation] which was acquired on a 5-point scale, i.e., it is already binned. If not one needs to bin the dataset using `DfBinDataset()` before RSM fitting can be performed. 

* If there are more than two treatments in the pilot dataset, as in `dataset04`, one extracts those treatments that represent "almost" null hypothesis data (in the sense of similar ROC-AUCs). For example: 


```
datasetNH <- DfExtractDataset(dataset, trts = c(1,2)) 
```

extracts treatments 1 and 2. The reason for using the first two treatments is that these were found [@zanca2009evaluation] to be "almost" equivalent (more precisely, the NH could not be rejected for the first two treatments). More than two treatments can be used if they have similar AUCs. However, the final sample size predictions are restricted to two treatments in the pivotal study. 


The next two steps are needed since **the RSM can only fit binned ROC data**. 


* If the original data is FROC, one converts it to ROC using:

```

rocDatasetNH <- DfFroc2Roc(datasetNH) 

```

* If the NH dataset uses continuous ratings one bins them as follows: 

```
rocDatasetBin <- DfBinDataset(rocDatasetNH, opChType = "ROC"). 
```

The default number of bins should be used. Unlike binning using arbitrarily set thresholds the thresholds found by `DfBinDataset()` are unique as they maximize the empirical ROC-AUC. 

* For each treatment and reader the ROC data is fitted by `FitRsmRoc()`, see example below, yielding estimates of the RSM *physical* parameters $\mu, \lambda, \nu$.  

The following code calculates the pilot FROC dataset `frocDataNH` and the corresponding inferred ROC dataset `rocDataNH`.


```r
frocDataNH <- DfExtractDataset(dataset04, trts = c(1,2))
rocDataNH <- DfFroc2Roc(frocDataNH)
# Following line is unnecessary as thos dataset is already binned
rocDataBinNH <- DfBinDataset(rocDataNH, opChType = "ROC")
# but it cant hurt
```


Next one determines `lesDistr`, the lesion distribution (the RSM fitting algorithm needs to know how lesion-rich the dataset is as the predicted ROC-AUC depends it). One also needs the lesion weights matrix $\textbf{W}$.



```r
lesDistr <- UtilLesDistr(frocDataNH)
W <- UtilLesWghtsDS(frocDataNH)
```


Note that `lesDistr` and $\textbf{W}$ are determined from the *FROC* NH dataset as this information is lost upon conversion to an ROC dataset. 


For this dataset fraction 0.69 of diseased cases have one lesion, fraction 0.2 of diseased cases have two lesions and fraction 0.11 of diseased cases have three lesions.  


In the next code block for each treatment and reader the fitting algorithm `FitRsmRoc()` is applied (lines 4 - 11). The returned values are `mu`, `lambda` and `nu`, corresponding to the physical RSM parameters ${\mu}$, ${\lambda}$ and ${\nu}$.


```{.r .numberLines}
I <- dim(frocDataNH$ratings$NL)[1]
J <- dim(frocDataNH$ratings$NL)[2]
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


I recommend taking the median (not the mean) of each of the parameters as representing the "average" NH dataset. The median is less sensitive to outliers than the mean.  



```r
muNH <- median(RsmParmsNH[,,1]) 
lambdaNH <- median(RsmParmsNH[,,2])
nuNH <- median(RsmParmsNH[,,3])
```


The defining values of the fitting model are `muNH` = 3.3121519, `lambdaNH` = 1.714368 and `nuNH` = 0.7036564. 

We are now ready to calculate the expected NH FOMs using the ROC-AUC and the wAFROC-AUC.



```r
aucRocNH <- UtilAnalyticalAucsRSM(muNH, lambdaNH, nuNH, lesDistr = lesDistr$Freq)$aucROC
aucwAfrocNH <- UtilAnalyticalAucsRSM(muNH, lambdaNH, nuNH, lesDistr = lesDistr$Freq)$aucwAFROC
```


* The results are: `aucRocNH = 0.8791542` and `aucwAfrocNH = 0.7198615`. Note that the wAFROC-FOM is smaller than the ROC-FOM as it includes detection and localization performance. 

* To define the alternative hypothesis (AH) condition, one increments $\mu_{NH}$ by $\Delta_{\mu}$. The resulting ROC-AUC and wAFROC-AUC are calculated.

* The next step is to calculate the effect size (AH value minus NH value) using ROC and wAFROC FOMs for a series of specified `deltaMu` values. This generates values that can be used to interpolate the wAFROC effect size for a specified ROC effect size. 



```r
deltaMu <- seq(0.01, 0.2, 0.01) # values of deltaMu to scan below
esRoc <- array(dim = length(deltaMu));eswAfroc <- array(dim = length(deltaMu))
for (i in 1:length(deltaMu)) {
  esRoc[i] <- UtilAnalyticalAucsRSM(
    muNH + deltaMu[i], lambdaNH, nuNH, lesDistr = lesDistr$Freq)$aucROC - aucRocNH
  eswAfroc[i] <- UtilAnalyticalAucsRSM(
    muNH+ deltaMu[i], lambdaNH, nuNH, lesDistr = lesDistr$Freq)$aucwAFROC - aucwAfrocNH
}
```


Here is a plot of wAFROC effect size (y-axis) vs. ROC effect size.


<div class="figure" style="text-align: center">
<img src="19-froc-sample-size_files/figure-html/unnamed-chunk-7-1.png" alt="Plot of wAFROC effect size vs. ROC effect size." width="672" />
<p class="caption">(\#fig:unnamed-chunk-7)Plot of wAFROC effect size vs. ROC effect size.</p>
</div>


The plot is linear and the intercept is close to zero. This makes it easy to implement an interpolation function. In the following code line 1 fits `eswAfroc` vs. `esRoc` using a linear model `lm()` function constrained to pass through the origin (the "-1"). One expects this constraint since for `deltaMu = 0` the effect size must be zero no matter how it is measured. 


```{.r .numberLines}
scaleFactor<-lm(eswAfroc~-1+esRoc) # fit values to straight line thru origin
effectSizeROC <- seq(0.01, 0.1, 0.005)
effectSizewAFROC <- effectSizeROC*scaleFactor$coefficients[1]
```


The slope of the zero-intercept constrained straight line fit is `scaleFactor` = 1.2617239 and the squared correlation coefficient is `R2` = 0.9999997 (the fit is very good). Therefore, the conversion from ROC to wAFROC effect size is: 

```

effectSizewAFROC = scaleFactor * effectSizeROC

```

**The wAFROC effect size is 1.26 times the ROC effect size.** It remains to calculate the variance components using the two FOMs.


### Computing variance components

The code block applies `StSignificanceTesting()` to `rocDataNH` and `frocDataNH` (using the appropriate FOM) and extracts the respective variance components.


```r
temp1 <- StSignificanceTesting(rocDataNH, FOM = "Wilcoxon", method = "DBM", analysisOption = "RRRC")
temp2 <- StSignificanceTesting(frocDataNH, FOM = "wAFROC", method = "DBM", analysisOption = "RRRC")
varComp_roc <- temp1$ANOVA$VarCom
varComp_afroc <- temp2$ANOVA$VarCom
```


The observed wAFROC effect-size (on the pilot dataset) is -0.00685625. This is a very small effect size as it represent the "almost" NH condition; the corresponding ROC effect-size is also small: -0.0051. These are not surprising since the study did not find a significant difference between these two treatments.

The ROC and wAFROC variance components are:



```
##                  ROC         wAFROC
## VarR   0.00082773798  0.00185422886
## VarC   0.03812334734  0.06117804981
## VarTR  0.00015265067 -0.00044392794
## VarTC  0.00964432675  0.01016518621
## VarRC  0.00354419640  0.01355883396
## VarErr 0.09484636574  0.09672559908
```



Only terms involving treatment (i.e., TR, TC and Err) are relevant to sample size. The wAFROC values are slightly larger than the corresponding ROC ones. This is expected because the allowed range of the wAFROC FOM is twice that of the ROC FOM. 


### Comparing ROC power to wAFROC power for equivalent effect-sizes

We are now ready to compare ROC and wAFROC random-reader random-case (RRRC) powers for equivalent effect sizes. The following example is for 5 readers (`JPivot`) and 100 cases (`KPivot`) in the **pivotal study**. 





```r
power_roc <- array(dim = length(effectSizeROC))
power_afroc <- array(dim = length(effectSizeROC))

JPivot <- 5;KPivot <- 100
for (i in 1:length(effectSizeROC)) {
  
  # these are pseudovalue based variance components assuming FOM = "Wilcoxon"
  varYTR_roc <- varComp_roc["VarTR","Estimates"]
  varYTC_roc <- varComp_roc["VarTC","Estimates"]
  varYEps_roc <- varComp_roc["VarErr","Estimates"]
  
  # compute ROC power
  ret <- SsPowerGivenJK(
    dataset = NULL, 
    FOM = "Wilcoxon", 
    J = JPivot, 
    K = KPivot, 
    analysisOption = "RRRC", 
    effectSize = effectSizeROC[i], 
    method = "DBM", 
    LegacyCode = TRUE, 
    list(VarTR = varYTR_roc, VarTC = varYTC_roc, VarErr = varYEps_roc))
  power_roc[i] <- ret$powerRRRC
  
  # these are pseudovalue based variance components assuming FOM = "wAFROC"
  varYTR_afroc <- varComp_afroc["VarTR","Estimates"]
  varYTC_afroc <- varComp_afroc["VarTC","Estimates"]
  varYEps_afroc <- varComp_afroc["VarErr","Estimates"]
  
  # compute wAFROC power
  ret <- SsPowerGivenJK(
    dataset = NULL, 
    FOM = "Wilcoxon", 
    J = JPivot, 
    K = KPivot, 
    analysisOption = "RRRC", 
    effectSize = effectSizewAFROC[i], 
    method = "DBM", 
    LegacyCode = TRUE, 
    list(VarTR = varYTR_afroc, VarTC = varYTC_afroc, VarErr = varYEps_afroc))
  power_afroc[i] <- ret$powerRRRC
  
  # cat("ROC-ES = ", effectSizeROC[i], 
  #     ", wAFROC-ES = ", effectSizewAFROC[i], 
  #     ", Power-ROC = ", power_roc[i], 
  #     ", Power-wAFROC = ", power_afroc[i], "\n")
}
```


Since the wAFROC effect size is 1.26 times the ROC effect size, wAFROC power is larger than that for ROC. For example, for ROC effect size = 0.06 the wAFROC effect size is 0.075724872, the ROC power is 0.55738123 while the wAFROC power is 0.79517494. The effect size difference is magnified as it enters as the square in the formula for the power; this overwhelms the increase, noted previously, in variability of wAFROC-AUC relative to ROC-AUC 

The following is a plot of the respective powers.


<div class="figure" style="text-align: center">
<img src="19-froc-sample-size_files/figure-html/unnamed-chunk-12-1.png" alt="Plot of wAFROC power vs. ROC power. For ROC effect size = 0.06 the wAFROC effect size is 0.075724872, the ROC power is 0.55738123 while the wAFROC power is 0.79517494." width="672" />
<p class="caption">(\#fig:unnamed-chunk-12)Plot of wAFROC power vs. ROC power. For ROC effect size = 0.06 the wAFROC effect size is 0.075724872, the ROC power is 0.55738123 while the wAFROC power is 0.79517494.</p>
</div>





## Part 2


### Introduction

This example uses the FED dataset as a pilot FROC study and function `SsFrocNhRsmModel()` to construct the NH model (encapsulating some of the code in the first part).


### Constructing the NH model for the dataset

One starts by extracting the first two treatments from `dataset04`, which represent the NH dataset, see previous part. Next one constructs the NH model - note that the lesion distribution `lesDistr` can be specified here independently of that in the pilot dataset. This allows some control over selection of the diseased cases in the pivotal study.


```r
lesDistr <- c(0.69, 0.20, 0.11) # sic!
frocNhData <- DfExtractDataset(dataset04, trts = c(1,2))
lesDistr <- UtilLesDistr(lesDistr) # sic!
ret <- SsFrocNhRsmModel(frocNhData, lesDistr = lesDistr$Freq)
muNH <- ret$mu
lambdaNH <- ret$lambda
nuNH <- ret$nu
scaleFactor <- ret$scaleFactor
```


The fitting model is defined by `muNH` = 3.31215193,  `lambdaNH` = 1.71436802  and  `nuNH` = 0.70365644 and `lesDistr$Freq` = 0.69, 0.2, 0.11. The effect size scale factor is `scaleFactor` = 1.26172392. All of these values are consistent with the Part I values.



```r
aucRocNH <- UtilAnalyticalAucsRSM(
  muNH, lambdaNH, nuNH, 
  lesDistr = lesDistr$Freq)$aucROC

aucwAfrocNH <- UtilAnalyticalAucsRSM(
  muNH, lambdaNH, nuNH, 
  lesDistr = lesDistr$Freq)$aucwAFROC
```

The null hypothesis ROC AUC is 0.87915418 and the corresponding NH wAFROC AUC is 0.71986145. 

### Extracting the wAFROC variance components

The next code block applies `StSignificanceTesting()` to `frocNhData`, using `FOM = "wAFROC"` and extracts the variance components.


```r
varComp_afroc  <- StSignificanceTesting(
  frocNhData, FOM = "wAFROC", method = "DBM", 
  analysisOption = "RRRC")$ANOVA$VarCom
```


### wAFROC power for specified ROC effect size, number of readers J and number of cases K

The following example is for ROC effect size = 0.05, 5 readers (`J = 5`) and 100 cases (`K = 100`) in the **pivotal study**. 



```r
ROC_ES <- 0.05
effectSizewAFROC <- scaleFactor * ROC_ES
J <- 5;K <- 100

varYTR_afroc <- varComp_afroc["VarTR","Estimates"] 
varYTC_afroc <- varComp_afroc["VarTC","Estimates"]
varYEps_afroc <- varComp_afroc["VarErr","Estimates"]
ret <- SsPowerGivenJK(
  dataset = NULL, FOM = "Wilcoxon", J = J, K = K, analysisOption = "RRRC", 
  effectSize = effectSizewAFROC, method = "DBM", LegacyCode = TRUE, 
  list(VarTR = varYTR_afroc,
  VarTC = varYTC_afroc,
  VarErr = varYEps_afroc))
power_afroc <- ret$powerRRRC

cat("ROC-ES = ", ROC_ES, 
    ", wAFROC-ES = ", ROC_ES * scaleFactor, 
    ", Power-wAFROC = ", power_afroc, "\n")
```

```
## ROC-ES =  0.05 , wAFROC-ES =  0.063086196 , Power-wAFROC =  0.6420946
```


### wAFROC number of cases for 80 percent power for a given number of readers J



```r
VarTR_afroc <- varComp_afroc["VarTR","Estimates"] 
VarTC_afroc <- varComp_afroc["VarTC","Estimates"]
VarErr_afroc <- varComp_afroc["VarErr","Estimates"]
ret2 <- SsSampleSizeKGivenJ(
  dataset = NULL, J = 6, 
  effectSize = effectSizewAFROC, 
  method = "DBM", LegacyCode = TRUE,
  list(VarTR = VarTR_afroc, VarTC = VarTC_afroc, VarErr = VarErr_afroc))

cat("ROC-ES = ", ROC_ES, 
    ", wAFROC-ES = ", ROC_ES * scaleFactor, 
    ", K80RRRC = ", ret2$KRRRC, 
    ", Power-wAFROC = ", ret2$powerRRRC, "\n")
```

```
## ROC-ES =  0.05 , wAFROC-ES =  0.063086196 , K80RRRC =  121 , Power-wAFROC =  0.80022333
```


### wAFROC-FOM power for a given number of readers J and cases K



```r
ret3 <- SsPowerGivenJK(
  dataset = NULL, J = 6, 
  K = ret2$KRRRC, 
  effectSize = effectSizewAFROC, 
  method = "DBM", LegacyCode = TRUE,
  list(VarTR = VarTR_afroc, VarTC = VarTC_afroc, VarErr = VarErr_afroc))

cat("ROC-ES = ", ROC_ES, 
    ", wAFROC-ES = ", ROC_ES * scaleFactor, 
    ", powerRRRC = ", ret3$powerRRRC, "\n")
```

```
## ROC-ES =  0.05 , wAFROC-ES =  0.063086196 , powerRRRC =  0.80022333
```


The estimated power is close to 80 percent as the number of cases (`ret2$KRRRC = 121`) was chosen deliberately from the previous code block.




