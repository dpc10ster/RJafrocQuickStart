# (PART\*) OR method {-}


# Introduction to the Obuchowski-Rockette method {#or-method-intro}



## TBA How much finished {#or-method-intro-how-much-finished}

70%

## Locations of helper functions {#or-method-intro-helper-functions}


```r
source(here("R/CH10-OR/Wilcoxon.R"))
source(here("R/CH10-OR/VarCov1FomInput.R"))
source(here("R/CH10-OR/VarCov1Bs.R"))
source(here("R/CH10-OR/VarCov1Jk.R")) 
source(here("R/CH10-OR/VarCovMtrxDLStr.R"))
source(here("R/CH10-OR/VarCovs.R"))
```

## Introduction {#or-method-intro-intro}

-   This chapter starts with a gentle introduction to the Obuchowski and Rockette method. The reason is that the method was rather opaque to me, and I suspect most non-statistician users. Part of the problem, in my opinion, is the notation, namely lack of the *case-set* index $\{c\}$. While this may seem like a trivial point to statisticians, it did present a conceptual problem for me.

-   A key difference of the Obuchowski and Rockette method from DBM is in how the error term is modeled by a non-diagonal covariance matrix. Therefore, the structure of the covariance matrix is examined in some detail.

-   To illustrate the covariance matrix, a single reader interpreting a case-set in multiple treatments is analyzed and the results compared to that using DBM fixed-reader analysis described in previous chapters.

## Single-reader multiple-treatment {#or-method-intro-single-reader}

### Overview {#or-method-intro-single-reader-overview}

Consider a single-reader interpreting a common case-set $\{c\}$ in multiple-treatments $i$ ($i$ = 1, 2, ..., $I$).

*In the OR method one models the figure-of-merit, not the pseudovalues; indeed this is a key differences from the DBM method.* The figure of merit $\theta$ is modeled as:

```{=tex}
\begin{equation}
\theta_{i\{c\}}=\mu+\tau_i+\epsilon_{i\{c\}}
(\#eq:or-sampling-model-multiple-treatments)
\end{equation}
```
Eqn. \@ref(eq:or-sampling-model-multiple-treatments) models the observed figure-of-merit $\theta_{i\{c\}}$ as a constant term $\mu$, a treatment dependent term $\tau_i$ (the treatment-effect), and a random term $\epsilon_{i\{c\}}$. The term $\tau_i$ has the constraint:

```{=tex}
\begin{equation}
\sum_{i=1}^{I}\tau_i=0
(\#eq:ConstraintTau)
\end{equation}
```
The left hand side of Eqn. \@ref(eq:or-sampling-model-multiple-treatments) is the figure-of-merit $\theta_i\{c\}$ for treatment $i$ and case-set index $\{c\}$, where $c$ = 1, 2, ..., $C$ denotes different independent case-sets sampled from the population, i.e., different *collections* of $K_1$ non-diseased and $K_2$ diseased cases.

*The case-set index is essential for clarity. Without it* $\theta_i$ is a fixed quantity - the figure of merit estimate for treatment $i$ - lacking an index allowing for sampling related variability. Obuchowski and Rockette define a *k-index*, the:

> $k^{th}$ repetition of the study involving the same diagnostic test, reader and patient (sic)".

Needed is a *case-set* index rather than a *repetition* index. Repeating a study with the same treatment, reader and cases yields *within-reader* variability, when what is needed, for significance testing, is *case-sampling plus within-reader* variability.

*It is shown below that usage of the case-set index interpretation yields the same results using the DBM or the OR methods (for empirical AUC).*

Eqn. \@ref(eq:or-sampling-model-multiple-treatments) has an additive random error term $\epsilon_{i\{c\}}$ whose sampling behavior is described by a multivariate normal distribution with an I-dimensional zero mean vector and an $I \times I$ dimensional covariance matrix $\Sigma$:

```{=tex}
\begin{equation}
\epsilon_{i\{c\}} \sim N_I\left ( \vec{0} ,  \Sigma\right )
(\#eq:DefinitionEpsilon)
\end{equation}
```
Here $N_I$ is the I-variate normal distribution (i.e., each sample yields $I$ random numbers). For the single-reader model Eqn. \@ref(eq:or-sampling-model-multiple-treatments), the covariance matrix has the following structure :

```{=tex}
\begin{equation}
\Sigma_{ii'}=Cov\left ( \epsilon_{i\{c\}}, \epsilon_{i'\{c\}} \right )=\left\{\begin{matrix}
\text{Var} \qquad (i=i')\\ 
Cov_1 \qquad (i\neq i')
\end{matrix}\right.
(\#eq:DefinitionSigma)
\end{equation}
```

The reason for the subscript "1" in $Cov_1$ will become clear when we extend this model to multiple- treatments and multiple-readers. The $I \times I$ covariance matrix $\Sigma$ is:

```{=tex}
\begin{equation}
\Sigma=
\begin{pmatrix}
\text{Var} & Cov_1   & \ldots & Cov_1 & Cov_1 \\
Cov_1 & \text{Var}   & \ldots &Cov_1 & Cov_1 \\
\vdots & \vdots & \vdots & \vdots & \vdots \\
Cov_1 & Cov_1 & \ldots & \text{Var} & Cov_1 \\
Cov_1 & Cov_1 & \ldots & Cov_1 & \text{Var}
\end{pmatrix}
(\#eq:ExampleSigma)
\end{equation}
```
If $I$ = 2 then $\Sigma$ is a symmetric 2 x 2 matrix, whose diagonal terms are the common variances in the two treatments (each assumed equal to $\text{Var}$) and whose off-diagonal terms (each assumed equal to $Cov_1$) are the co-variances. With $I$ = 3 one has a 3 x 3 symmetric matrix with all diagonal elements equal to $\text{Var}$ and all off-diagonal terms are equal to $Cov_1$, etc.

*An important aspect of the Obuchowski and Rockette model is that the variances and co-variances are assumed to be treatment independent. This implies that* $\text{Var}$ estimates need to be averaged over all treatments. Likewise, $Cov_1$ estimates need to be averaged over all distinct treatment-treatment pairings.

[^a-or-analysis-introduction-1]

[^a-or-analysis-introduction-1]: A more complex model, with more parameters and therefore more difficult to work with, would allow the variances to be treatment dependent, and the covariances to depend on the specific treatment pairings. For obvious reasons ("Occam's Razor" or the law of parsimony ) one wishes to start with the simplest model that, one hopes, captures essential characteristics of the data.

Some elementary statistical results are presented in the Appendix.

### Significance testing {#st-or-multiple-treatment}

The covariance matrix is needed for significance testing. Define the mean square corresponding to the treatment effect, denoted $MS(T)$, by:

```{=tex}
\begin{equation}
MS(T)=\frac{1}{I-1}\sum_{i=1}^{I}(\theta_i-\theta_\bullet)^2
(\#eq:def-mst)
\end{equation}
```
*Unlike the previous DBM related chapters, all mean square quantities in this chapter are based on FOMs, not pseudovalues.*

It can be shown that under the null hypothesis that all treatments have identical performances, the test statistic $\chi_{1R}$ defined below (the $1R$ subscript denotes single-reader analysis) is distributed approximately as a $\chi^2$ distribution with $I-1$ degrees of freedom, i.e.,

```{=tex}
\begin{equation}
\chi_{\text{1R}} \equiv \frac{(I-1)MS(T)}{\text{Var}-\text{Cov1}} \sim \chi_{I-1}^{2}
(\#eq:F-1RMT)
\end{equation}
```
Eqn. \@ref(eq:F-1RMT) is from §5.4 in [@RN1865] with two covariance terms "zeroed out" because they are multiplied by $J-1 = 0$ (since we are restricting to $J=1$).

Or equivalently, in terms of the F-distribution [@RN1772]:

```{=tex}
\begin{equation}
F_{\text{1R}} \equiv \frac{MS(T)}{\text{Var}-\text{Cov1}} \sim F_{I-1, \infty}
(\#eq:or-sampling-model-def-f-single-reader)
\end{equation}
```
### p-value and confidence interval {#or-method-intro-pvalue-ci}

The p-value is the probability that a sample from the $F_{I-1,\infty}$ distribution is greater than the observed value of the test statistic, namely:

```{=tex}
\begin{equation}
p\equiv \Pr(f>F_{1R} \mid f \sim F_{I-1,\infty})
(\#eq:pValue1RMT)
\end{equation}
```

The $(1-\alpha)$ confidence interval for the inter-treatment FOM difference is given by:

```{=tex}
\begin{equation}
CI_{1-\alpha,1R} = (\theta_{i\bullet} - \theta_{i'\bullet}) \pm t_{\alpha/2,\infty} \sqrt{2(\text{Var}-\text{Cov1})}
(\#eq:CIalpha1R)
\end{equation}
```

Comparing Eqn. \@ref(eq:CIalpha1R) to Eqn. \@ref(eq:UsefulTheorem) shows that the term $\sqrt{2(\text{Var}-\text{Cov1})}$ is the standard error of the inter-treatment FOM difference, whose square root is the standard deviation. The term $t_{\alpha/2,\infty}$ is -1.96. Therefore, the confidence interval is constructed by adding and subtracting 1.96 times the standard deviation of the difference from the central value. [One has probably encountered the rule that a 95% confidence interval is plus or minus two standard deviations from the central value. The "2" comes from rounding up 1.96.]

### Null hypothesis validation {#or-method-intro-single-reader-nh-validation}

It is important to validate the significance testing method just outlined above. If the testing procedure is valid, then, when the NH is true, the procedure should reject it with probability $\alpha$. In the following, as is usual, we set $\alpha = 0.05$.


```{.r .numberLines}
set.seed(seed = 201)
mu <- 0.8
vc <- UtilORVarComponentsFactorial(dataset02, FOM = "Wilcoxon")
trueVar <- vc$IndividualRdr$varEachRdr[1]
trueCov1 <- vc$IndividualRdr$cov1EachRdr[1]
sigma <- matrix(c(trueVar, 
                  trueCov1, 
                  trueCov1, 
                  trueVar), 
                  ncol = 2)
I <- 2
S <-  2000
# simulate foms for two modalities, S times
# using the sampling model
theta_i <- t(rmvnorm(n=S, mean=c(0,0), sigma=sigma) + mu)
# estimated variance covariances
vc <- VarCov1_FomInput(theta_i)
Var <- vc$Var
Cov1 <- vc$Cov1

# conduct NH testing
reject <- 0
for(s in 1:S) {

  MS_T <- 0
  for (i in 1:I) {
    MS_T <- MS_T + (theta_i[i,s]-mean(theta_i[,s]))^2
  }
  MS_T <- MS_T/(I-1)
  
  F_1R <- MS_T/(Var - Cov1)
  pValue <- 1 - pf(F_1R, I-1, Inf)
  if (pValue < 0.05) reject <- reject + 1
}
alphaObs <- reject/S
```


```
## True, estimated diagonal elements =  0.000699,   0.000695
```

```
## True, estimated off-diagonal elements =  0.000373,   0.000351
```

```
## NH rejection fraction =    0.0515
```

The `seed` variable, set to 201 at line 1, is equivalent to the case sample index $c$ in Eqn. \@ref(eq:or-sampling-model-multiple-treatments). Different values of `seed` correspond to different case samples. 

Line 2 sets the value of $\mu$ to 0.8, the average figure of merit, appearing in Eqn. \@ref(eq:or-sampling-model-multiple-treatments). 

Lines 3-4 set the values of true $Var$ and true $Cov_1$ to values characterizing `dataset02` for reader one, as determined by function `UtilORVarComponentsFactorial`. 

Lines 5-9 initializes the covariance matrix $\Sigma$. The diagonal contains the variance and the off-diagonal contains $Cov_1$. These are the *true* values.

Lines 10-11 initializes $I = 2$, the number of treatments, and $S = 2000$, the number of simulations.

Line 14 generates 2000 samples from the two dimensional multivariate normal distribution with zero mean vector (**this is the null hypothesis**) and covariance equal to $\Sigma$. 

Lines 16-18 computes the *estimates* of the means and covariances. The helper function used `VarCov1_FomInput` (the name stands for $Var$ and $Cov_1$ using FOM input) is included in the distribution. The locations of helper functions are shown in Section \@ref(or-method-intro-helper-functions).

Lines 21-33 performs the NH testing. It starts by setting the counter variable `reject` to zero. A for-loop is set up to repeat 2000 times. For each iteration line 24-28 computes the treatment mean-square `MS_T`. Note the use, at line 25, of the two values of $theta_i$ corresponding to the s-th sample from the multivariate norrmal distribution (at line 14). Line 30 computes the F-statistic - compare to Eqn. \@ref(eq:or-sampling-model-def-f-single-reader). Line 31 computes the p-values and, if the p-value is less than $\alpha = 0.05$, line 32 increments `reject` by one. The observed NH rejection rate, `alphaObs`, is the final value of `reject` divided by 2000, line 34. For a valid test it is expected to be in the range (0.04, 0.06). The actual value, for the chosen value of `seed`, is 0.0515. 



### Application 1 {#or-method-intro-single-reader-application-roc}

Here is an application of the method for an ROC dataset, `dataset02`, which consists of two treatments and five readers.


```{.r .numberLines}
ds <- DfExtractDataset(dataset02, rdrs = 1)
fom <- as.vector(unlist(UtilFigureOfMerit(ds, FOM = "Wilcoxon")), mode = "numeric")
vc <- UtilORVarComponentsFactorial(ds, FOM = "Wilcoxon")
Cov1 <- vc$IndividualRdr$cov1EachRdr
Var <- vc$IndividualRdr$varEachRdr
msT <- vc$IndividualRdr$msTEachRdr
I <- length(ds$ratings$NL[,1,1,1])
chiObs <- (I-1)*msT/(Var-Cov1)
pval <- pchisq(chiObs,I-1,lower.tail = F)
ci <- array(dim = 2)
ci[1] <- (fom[1] - fom[2]) + qt(0.025, Inf, lower.tail = F) * sqrt(2*(Var - Cov1))
ci[2] <- (fom[1] - fom[2]) - qt(0.025, Inf, lower.tail = F) * sqrt(2*(Var - Cov1))
```


```
## fom =  0.9196457 0.9478261
```

```
## fom diff =  -0.02818035
```

```
## pval =  0.2693389
```

```
## ci =  0.02182251 -0.07818322
```

We extract the data for reader 1 only, line 1, resulting in a 2-treatment single-reader dataset `ds`. Lines 2-3 compute the Wilcoxon figures of merit for each treatment as a row vector. Lines 4-7 computes OR treatment mean square `msT`, the OR variance components `Var` and `Cov1`: function`UtilORVarComponentsFactorial` is used with the Wilcoxon figure of merit specified. Line 8 obtains the number of treatments, $I=2$ in this example. Line 9 computes the observed chisquare statistic, `chiObs`. Line 10 computes the p-value, `pValue`, i.e., the probability that a sample from a chisquare distribution with I-1 degrees of freedom exceeds the observed value. Lines 11-13 compute the 95% confidence interval for the inter-treatment FOM difference. For this reader the two treatments are not significantly different.

### Application 2 {#or-method-intro-single-reader-application-froc}

Here is an application of the method for an FROC dataset, `dataset04`, which consists of five treatments and four readers.


```{.r .numberLines}
ds <- DfExtractDataset(dataset04, rdrs = 1, trts = c(4,5))
fom <- as.vector(unlist(UtilFigureOfMerit(ds, FOM = "wAFROC")), mode = "numeric")
vc <- UtilORVarComponentsFactorial(ds, FOM = "wAFROC")
Cov1 <- vc$IndividualRdr$cov1EachRdr
Var <- vc$IndividualRdr$varEachRdr
msT <- vc$IndividualRdr$msTEachRdr
I <- length(ds$ratings$NL[,1,1,1])
chiObs <- (I-1)*msT/(Var-Cov1)
pval <- pchisq(chiObs,I-1,lower.tail = F)
ci <- array(dim = 2)
ci[1] <- (fom[1] - fom[2]) + 
  qt(0.025, Inf, lower.tail = F) * sqrt(2*(Var - Cov1))
ci[2] <- (fom[1] - fom[2]) - 
  qt(0.025, Inf, lower.tail = F) * sqrt(2*(Var - Cov1))
```


```
## fom =  0.8101333 0.7488
```

```
## fom diff =  0.06133333
```

```
## pval =  0.03189534
```

```
## ci =  0.117357 0.005309652
```

We extract the data for reader 1 only, for treatments 4 and 5, line 1, resulting in a 2-treatment single-reader dataset `ds`. Lines 2-3 compute the wAFROC figures of merit for each treatment as a row vector. Lines 4-7 computes OR treatment mean square `msT`, the OR variance components `Var` and `Cov1`: function`UtilORVarComponentsFactorial` is used with the wAFROC figure of merit specified. Line 8 obtains the number of treatments, $I=2$ in this example. Line 9 computes the observed chisquare statistic, `chiObs`. Line 10 computes the p-value, `pValue`, i.e., the probability that a sample from a chisquare distribution with I-1 degrees of freedom exceeds the observed value. Lines 11-13 compute the 95% confidence interval for the inter-treatment FOM difference. For this reader the two treatments are significantly different.

## Single-treatment multiple-reader {#or-method-intro-single-treatment}

### Overview {#or-method-intro-single-treatment-overview}

Consider multiple readers $j$ ($j$ = 1, 2, ..., $J$) interpreting a common case-set $\{c\}$ in a single treatment. The OR sampling model is:

```{=tex}
\begin{equation}
\theta_{j\{c\}}=\mu+R_j+\epsilon_{j\{c\}}
(\#eq:or-sampling-model-multiple-reader)
\end{equation}
```
The error term $\epsilon_{j\{c\}}$ has sampling behavior described by a multivariate normal distribution with a J-dimensional zero mean vector and a $J \times J$ dimensional covariance matrix $\Sigma$:

```{=tex}
\begin{equation}
\epsilon_{j\{c\}} \sim N_J\left ( \vec{0} ,  \Sigma\right )
(\#eq:def-epsilon-multiple-readers)
\end{equation}
```
The covariance matrix has the following structure:

```{=tex}
\begin{equation}
\Sigma_{jj'}=Cov\left ( \epsilon_{j\{c\}}, \epsilon_{j'\{c\}} \right )=\left\{\begin{matrix}
\text{Var} \qquad (j=j')\\ 
Cov_2 \qquad (j\neq j')
\end{matrix}\right.
(\#eq:def-sigma-multiple-reader)
\end{equation}
```

The reason for the subscript "2" in $Cov_2$ will become clear when one extends this model to multiple- treatments and multiple-readers. The $J \times J$ covariance matrix $\Sigma$ is:

```{=tex}
\begin{equation}
\Sigma=
\begin{pmatrix}
\text{Var} & Cov_2   & \ldots & Cov_2 & Cov_2 \\
Cov_2 & \text{Var}   & \ldots &Cov_2 & Cov_2 \\
\vdots & \vdots & \vdots & \vdots & \vdots \\
Cov_2 & Cov_2 & \ldots & \text{Var} & Cov_2 \\
Cov_2 & Cov_2 & \ldots & Cov_2 & \text{Var}
\end{pmatrix}
(\#eq:ExampleSigma1)
\end{equation}
```

The covariance matrix is estimated, as usual, by either a resampling method (jackknife of bootstrap) or, for the special case of Wilcoxon figure of merit, by the DeLong method.

### Significance testing {#st-or-multiple-reader}

Unlike the seemingly analogous single-reader multiple-treatment case addressed in Section \@ref(st-or-multiple-treatment), the single-treatment multiple-reader case is fundamentally different. This is because reader is a *random* factor while treatment, in Section \@ref(st-or-multiple-treatment), was a *fixed* factor. This makes it impossible to define a null hypothesis analogous to that with the treatment factor, e.g., $R_1 = R_2$, since reader is modeled as a random sample from a distribution, i.e., $R \sim N(0,\sigma_R^2)$. 

### Special case {#st-or-multiple-reader-example-three}

If reader is regarded as a *fixed* factor significance testing between readers can be performed. The analysis presented in Section \@ref(st-or-multiple-treatment) is applicable, with the treatment factor replaced by the reader factor. This is appropriate, for example, when comparing two AI (artificial intelligence) algorithms. The two algorithms, each of which qualifies as a reader, are not random samples from a population of AI readers: rather they are two fixed algorithms, in the literal sense. 


## Multiple-reader multiple-treatment {#or-method-intro-multiple-reader-multiple-treatment}


The previous sections introduced Obuchowski and Rockette method using single reader and single treatment examples. This section extends it to multiple-readers interpreting a common case-set in multiple-treatments (MRMC). The extension is, in principle, fairly straightforward. Compared to Eqn. \@ref(eq:or-sampling-model-multiple-treatments), one needs an additional $j$ index to denote reader dependence of the figure of merit, and additional terms to model reader and treatment-reader variability, and the error term needs to be modified to account for the additional random reader factor.

The Obuchowski and Rockette model for fully paired multiple-reader multiple-treatment interpretations is:

```{=tex}
\begin{equation}
\theta_{ij\{c\}}=\mu+\tau_i+R_j+(\tau R)_{ij}+\epsilon_{ij\{c\}}
(\#eq:or-sampling-model-general)
\end{equation}
```
-   The fixed treatment effect $\tau_i$ is subject to the usual constraint, Eqn. \@ref(eq:ConstraintTau).

-   The first two terms on the right hand side of Eqn. \@ref(eq:or-sampling-model-general) have their usual meanings: a constant term $\mu$ representing performance averaged over treatments and readers, and a treatment effect $\tau_i$ ($i$ = 1,2, ..., $I$).

-   The next two terms are, by assumption, mutually independent random samples specified as follows:

    -   $R_j$ denotes the random treatment-independent figure-of-merit contribution of reader $j$ ($j$ = 1,2, ..., $J$), modeled by a zero-mean normal distribution with variance $\sigma_R^2$;
    -   $(\tau R)_{ij}$ denotes the treatment-dependent random contribution of reader $j$ in treatment $i$, modeled as a sample from a zero-mean normal distribution with variance $\sigma_{\tau R}^2$. 

-   Summarizing:

```{=tex}
\begin{equation}
\left.
\begin{aligned}
\begin{matrix}
R_j \sim N(0,\sigma_R^2)\\ 
{\tau R} \sim N(0,\sigma_{\tau R}^2)
\end{matrix}
\end{aligned}
\right \}
(\#eq:ORVariances)
\end{equation}
```
For a single dataset $c$ = 1. An estimate of $\mu$ follows from averaging over the $i$ and $j$ indices (the averages over the random terms are zeroes):

```{=tex}
\begin{equation}
\mu = \theta_{\bullet \bullet \{1\}}
(\#eq:ORmuEstimate)
\end{equation}
```
Averaging over the j index and performing a subtraction yields an estimate of $\tau_i$:

```{=tex}
\begin{equation}
\tau_i = \theta_{i \bullet \{1\}} - \theta_{\bullet \bullet \{1\}}
(\#eq:ORtauEstimate)
\end{equation}
```
The $\tau_i$ estimates obey the constraint Eqn. \@ref(eq:ConstraintTau). For example, with two treatments, the values of $\tau_i$ must be the negatives of each other: $\tau_1=-\tau_2$.

The error term on the right hand side of Eqn. \@ref(eq:or-sampling-model-general) is more complex than the corresponding DBM model error term. Obuchowski and Rockette model this term with a multivariate normal distribution with a length $(IJ)$ zero-mean vector and a $(IJ \times IJ)$ dimensional covariance matrix $\Sigma$. In other words,

```{=tex}
\begin{equation}
\epsilon_{ij\{c\}} \sim N_{IJ}(\vec{0},\Sigma)
(\#eq:OREpsSampling)
\end{equation}
```
Here $N_{IJ}$ is the $IJ$-variate normal distribution, $\vec{0}$ is the zero-vector with length $IJ$, denoting the vector-mean of the distribution. The counterpart of the variance, namely the covariance matrix $\Sigma$ of the distribution, is defined by 4 parameters, $\text{Var}, \text{Cov1}, \text{Cov2}, \text{Cov3}$, defined as follows:

```{=tex}
\begin{equation}
Cov(\epsilon_{ij\{c\}},\epsilon_{i'j'\{c\}}) =
\left\{\begin{matrix}
\text{Var} \; (i=i',j=j') \\
\text{Cov1} \; (i\ne i',j=j')\\ 
\text{Cov2} \; (i = i',j \ne j')\\ 
\text{Cov3} \; (i\ne i',j \ne j')
\end{matrix}\right\}
(\#eq:ORVarCov)
\end{equation}
```
Apart from fixed effects, the model implied by Eqn. \@ref(eq:or-sampling-model-general) and Eqn. \@ref(eq:ORVarCov) contains 6 parameters:

$$\sigma_R^2,\sigma_{\tau R}^2,\text{Var}, \text{Cov1}, \text{Cov2}, \text{Cov3}$$

This is the same number of variance component parameters as in the DBM model, which should not be a surprise since one is modeling the data with equivalent models. The Obuchowski and Rockette model Eqn. \@ref(eq:or-sampling-model-general) "looks" simpler because four covariance terms are encapsulated in the $\epsilon$ term. As with the singe-reader multiple-treatment model, the covariance matrix is assumed to be independent of treatment or reader.

It is implicit in the Obuchowski-Rockette model that the $Var$, $\text{Cov1}$, $Cov_2$, and $Cov_3$ estimates are averaged over all applicable treatment-reader combinations.

### Structure of the covariance matrix {#StrCovMatrix}

To understand the structure of this matrix, recall that the diagonal elements of a square covariance matrix are the variances and the off-diagonal elements are covariances. With two indices $ij$ one can still imagine a square matrix where the position along each dimension is labeled by a pair of indices $ij$. One $ij$ pair corresponds to the horizontal direction, and the other $ij$ pair corresponds to the vertical direction. To visualize this let consider the simpler situation of two treatments ($I = 2$) and three readers ($J = 3$). The resulting $6 \times 6$ covariance matrix would look like this:

$$
\Sigma=
\begin{bmatrix}
(11,11) & (12,11) & (13,11) & (21,11) & (22,11) & (23,11) \\
& (12,12) & (13,12) & (21,12) & (22,12) & (23,12) \\ 
& & (13,13) & (21,13) & (22,13) & (23,13) \\ 
& & & (21,21) & (22,21) & (23,21) \\
& & & & (22,22) & (23,22) \\ 
& & & & & (23,23)
\end{bmatrix}
$$

Shown in each cell of the matrix is a pair of ij-values, serving as column indices, followed by a pair of ij-values serving as row indices, and a comma separates the pairs. For example, the first column is labeled by (11,xx), where xx depends on the row. The second column is labeled (12,xx), the third column is labeled (13,xx), and the remaining columns are successively labeled (21,xx), (22,xx) and (23,xx). Likewise, the first row is labeled by (yy,11), where yy depends on the column. The following rows are labeled (yy,12), (yy,13), (yy,21), (yy,22)and (yy,23). Note that the reader index increments faster than the treatment index.

The diagonal elements are evidently those cells where the row and column index-pairs are equal. These are (11,11), (12,12), (13,13), (21,21), (22,22) and (23,23). According to Eqn. \@ref(eq:ORVarCov) these cells represent $Var$.

$$
\Sigma=
\begin{bmatrix}
Var & (12,11) & (13,11) & (21,11) & (22,11) & (23,11) \\
& Var & (13,12) & (21,12) & (22,12) & (23,12) \\ 
& & Var & (21,13) & (22,13) & (23,13) \\ 
& & & Var & (22,21) & (23,21) \\
& & & & Var & (23,22) \\ 
& & & & & Var
\end{bmatrix}
$$

According to Eqn. \@ref(eq:ORVarCov) cells with different treatment indices but identical reader indices represent $\text{Cov1}$. As an example, cell (21,11) has the same reader indices, namely reader 1, but different treatment indices, namely 2 and 1, so it is $\text{Cov1}$:

$$
\Sigma=
\begin{bmatrix}
\text{Var} & (12,11) & (13,11) & \text{Cov1} & (22,11) & (23,11) \\
& \text{Var} & (13,12) & (21,12) & \text{Cov1} & (23,12) \\ 
& & \text{Var} & (21,13) & (22,13) & \text{Cov1} \\ 
& & & \text{Var} & (22,21) & (23,21) \\
& & & & \text{Var} & (23,22) \\ 
& & & & & \text{Var}
\end{bmatrix}
$$

Similarly, cells with identical treatment indices but different reader indices represent $Cov_2$:

$$
\Sigma=
\begin{bmatrix}
Var & Cov_2 & Cov_2 & \text{Cov1} & (22,11) & (23,11) \\
& \text{Var} & Cov_2 & (21,12) & \text{Cov1} & (23,12) \\ 
&  & \text{Var} & (21,13) & (22,13) & \text{Cov1} \\ 
&  &  & \text{Var} & Cov_2 & Cov_2 \\
&  &  &  & \text{Var} & Cov_2 \\ 
&  &  &  &  & \text{Var}
\end{bmatrix}
$$

Finally, cells with different treatment indices and different reader indices represent $Cov_3$:

$$
\Sigma=
\begin{bmatrix}
\text{Var} & Cov_2 & Cov_2 & \text{Cov1} & Cov_3 & Cov_3 \\
& \text{Var} & Cov_2 & Cov_3 & \text{Cov1} & Cov_3 \\ 
&  & \text{Var} & Cov_3 & Cov_3 & \text{Cov1} \\ 
&  &  & \text{Var} & Cov_2 & Cov_2 \\
&  &  &  & \text{Var} & Cov_2 \\ 
&  &  &  &  & \text{Var}
\end{bmatrix}
$$

To understand these terms consider how they might be estimated. Suppose one had the luxury of repeating the study with different case-sets, c = 1, 2, ..., C. Then the variance $\text{Var}$ is estimated as follows:

```{=tex}
\begin{equation}
\text{Var}=
\left \langle \frac{1}{C-1}\sum_{c=1}^{C} (\theta_{ij\{c\}}-\theta_{ij\{\bullet\}})^2 \right \rangle_{ij}
\epsilon_{ij\{c\}} \sim N_{IJ}(\vec{0},\Sigma)
(\#eq:EstVariance)
\end{equation}
```
Of course, in practice one would use the bootstrap or the jackknife as a stand-in for the c-index (with the understanding that if the jackknife is used, then a variance inflation factor has to be included on the right hand side of Eqn. \@ref(eq:EstVariance). Notice that the left-hand-side of Eqn. \@ref(eq:EstVariance) lacks treatment or reader indices. This is because implicit in the notation is averaging the observed variances over all treatments and readers, as implied by $\left \langle \right \rangle _{ij}$. Likewise, the covariance terms are estimated as follows:

```{=tex}
\begin{equation}
Cov=\left\{\begin{matrix}
\text{Cov1}=\left \langle \frac{1}{C-1}\sum_{c=1}^{C} (\theta_{ij\{c\}}-\theta_{ij\{\bullet\}}) (\theta_{i'j\{c\}}-\theta_{i'j\{\bullet\}}) \right \rangle_{ii',jj}\\ 
Cov_2=\left \langle \frac{1}{C-1}\sum_{c=1}^{C} (\theta_{ij\{c\}}-\theta_{ij\{\bullet\}}) (\theta_{ij'\{c\}}-\theta_{ij'\{\bullet\}}) \right \rangle_{ii,jj'}\\ 
Cov_3=\left \langle \frac{1}{C-1}\sum_{c=1}^{C} (\theta_{ij\{c\}}-\theta_{ij\{\bullet\}}) (\theta_{i'j'\{c\}}-\theta_{i'j'\{\bullet\}}) \right \rangle_{ii',jj'}
\end{matrix}\right.
(\#eq:EstCovMatrix)
\end{equation}
```
*In Eqn.* \@ref(eq:EstCovMatrix) *the convention is that primed and unprimed variables are always different.*

Since there are no treatment and reader dependencies on the left-hand-sides of the above equations, one averages the estimates as follows:

-   For $\text{Cov1}$ one averages over all combinations of *different treatments and same readers*, as denoted by $\left \langle \right \rangle_{ii',jj}$.
-   For $Cov_2$ one averages over all combinations of *same treatment and different readers*, as denoted by $\left \langle \right \rangle_{ii,jj'}$.
-   For $Cov_3$ one averages over all combinations of *different treatments and different readers*, as denoted by $\left \langle \right \rangle_{ii',jj'}$.

### Physical meanings of the covariance terms {#PhysicalMeaningsOfCovMatrix}

The meanings of the different terms follow a similar description to that given in Eqn. \@ref(StrCovMatrix). The diagonal term $\text{Var}$ is the variance of the figures-of-merit when reader $j$ interprets different case-sets $\{c\}$ in treatment $i$. Each case-set yields a number $\theta_{ij\{c\}}$ and the variance of the $C$ numbers, averaged over the $I \times J$ treatments and readers, is $\text{Var}$. It captures the total variability due to varying difficulty levels of the case-sets, inter-reader and within-reader variability.

It is easier to see the physical meanings of $\text{Cov1}, Cov_2, Cov_3$ if one starts with the correlations.

-   $\rho_{1;ii'jj}$ is the correlation of the figures-of-merit when reader $j$ interprets case-sets in different treatments $i,i'$. Each case-set, starting with $c = 1$, yields two numbers $\theta_{ij\{1\}}$ and $\theta_{i'j\{1\}}$. The correlation of the two pairs of C-length arrays, averaged over all pairings of different treatments and same readers, is $\rho_1$. The correlation exists due to the common contribution of the shared reader. When the common variation is large, the two arrays become more correlated and $\rho_1$ approaches unity. If there is no common variation, the two arrays become independent, and $\rho_1$ equals zero. Converting from correlation to covariance, see Eqn. \@ref(eq:CovMtrxSigmaRhoForm), one has $\text{Cov1} < \text{Var}$.

-   $\rho_{2;iijj'}$ is the correlation of the figures-of-merit values when different readers $j,j'$ interpret the same case-sets in the same treatment $i$. As before this yields two C-length arrays, whose correlation, upon averaging over all distinct treatment pairings and same readers, yields $\rho_2$. If one assumes that common variation between different-reader same-treatment FOMs is smaller than the common variation between same-reader different-treatment FOMs, then $\rho_2$ will be smaller than $\rho_1$. This is equivalent to stating that readers agree more with themselves in different treatments than they do with other readers in the same treatment. Translating to covariances, one has $Cov_2 < \text{Cov1} < \text{Var}$.

-   $\rho_{3;ii'jj'}$ is the correlation of the figure-of-merit values when different readers $j,j'$ interpret the same case set in different treatments $i,i'$, etc., yielding $\rho_3$. This is expected to yield the least correlation.

Summarizing, one expects the following ordering for the terms in the covariance matrix:

```{=tex}
\begin{equation}
Cov_3 \leq  Cov_2 \leq  \text{Cov1} \leq  \text{Var}
(\#eq:CovOrderings)
\end{equation}
```
## Summary {#or-method-intro-summary}

## Discussion {#or-method-intro-discussion}

## Appendix: Covariance and correlation {#or-method-intro-elementary-stats}

Some elementary statistical results are reviewed here. 

### Relation: chisquare and F with infinite ddf {#or-method-intro-elementary-stats-f-stat-chisq-stat} 

Define $D_{1-\alpha}$, the $(1-\alpha)$ quantile of distribution $D$, such that the probability of observing a random sample $d$ less than or equal to $D_{1-\alpha}$ is $(1-\alpha)$:

```{=tex}
\begin{equation}
\Pr(d\leq D_{1-\alpha} \mid d \sim D)=1-\alpha
(\#eq:DefQuantile)
\end{equation}
```
With definition Eqn. \@ref(eq:DefQuantile), the $(1-\alpha)$ quantile of the $\chi_{I-1}^2$ distribution, i.e., $\chi_{1-\alpha,I-1}^2$, is related to the $(1-\alpha)$ quantile of the $F_{I-1,\infty}$ distribution, i.e., $F_{1-\alpha,I-1,\infty}$, as follows [see @RN1772, Eq. 22]:

```{=tex}
\begin{equation}
\frac{\chi_{1-\alpha,I-1}^{2}}{I-1} = F_{1-\alpha,I-1,\infty}
(\#eq:Chisqr2F)
\end{equation}
```
Eqn. \@ref(eq:Chisqr2F) implies that the $(1-\alpha)$ quantile of the F-distribution with $ndf=(I-1)$ and $ddf =\infty$ equals the $(1-\alpha)$ quantile of the $\chi_{I-1}^2$ distribution *divided by* $(I-1)$.

Here is an `R` illustration of this theorem for $I-1 = 4$ and $\alpha = 0.05$:


```r
qf(0.05, 4, Inf)
```

```
## [1] 0.1776808
```

```r
qchisq(0.05,4)/4
```

```
## [1] 0.1776808
```

### Definitions of covariance and correlation {#or-method-intro-elementary-stats-def-cov-matrix}

The covariance of two scalar random variables X and Y is defined by:

```{=tex}
\begin{equation}
Cov(X,Y) =\frac{\sum_{i=1}^{N}(x_{i}-x_{\bullet})(y_{i}-y_{\bullet})}{N-1}=E(XY)-E(X)-E(Y)
(\#eq:DefCov)
\end{equation}
```
Here $E(X)$ is the expectation value of the random variable $X$, i.e., the integral of x multiplied by its $\text{pdf}$ over the range of $x$:

$$E(X)=\int \text{pdf(x)} x dx$$

The covariance can be thought of as the *common* part of the variance of two random variables. The variance, a special case of covariance, of $X$ is defined by:

$$\text{Var}(X,X) = Cov(X,X)=E(X^2)-(E(X))^2=\sigma_x^2$$

It can be shown, this is the Cauchy--Schwarz inequality, that:

$$\mid Cov(X,Y) \mid^2 \le \text{Var}(X)\text{Var}(Y)$$

A related quantity, namely the correlation $\rho$ is defined by (the $\sigma$s are standard deviations):

$$\rho_{XY} \equiv Cor(X,Y)=\frac{Cov(X,Y)}{\sigma_X \sigma_Y}$$

It has the property:

$$\mid \rho_{XY} \mid \le 1$$

### Special case when variables have equal variances {#or-method-intro-elementary-stats-equal-variance}

Assuming $X$ and $Y$ have the same variance:

$$\text{Var}(X)=\text{Var}(Y)\equiv \text{Var}\equiv \sigma^2$$

A useful theorem applicable to the OR single-reader multiple-treatment model is:

```{=tex}
\begin{equation}
\text{Var}(X-Y)=\text{Var}(X)+\text{Var}(Y)-2Cov(X,Y)=2(\text{Var}-Cov)
(\#eq:UsefulTheorem)
\end{equation}
```
The right hand side specializes to the OR single-reader multiple-treatment model where the variances (for different treatments) are equal and likewise the covariances in Eqn. \@ref(eq:ExampleSigma) are equal) The correlation $\rho_1$ is defined by (the reason for the subscript 1 on $\rho$ is the same as the reason for the subscript 1 on $\text{Cov1}$, which will be explained later):

$$\rho_1=\frac{\text{Cov1}}{\text{Var}}$$

The I x I covariance matrix $\Sigma$ can be written alternatively as (shown below is the matrix for I = 5; as the matrix is symmetric, only elements at and above the diagonal are shown):

```{=tex}
\begin{equation}
\Sigma = 
\begin{bmatrix}
\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
& \sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
&  & \sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
&  &  & \sigma^2 & \rho_1\sigma^2\\
&  &  &  & \sigma^2
\end{bmatrix}
(\#eq:CovMtrxSigmaRhoForm)
\end{equation}
```
### Estimating the variance-covariance matrix {#or-method-intro-elementary-stats-est-cov-matrix}

An unbiased estimate of the covariance matrix Eqn. \@ref(eq:DefinitionSigma) follows from:

```{=tex}
\begin{equation}
\Sigma_{ii'}\mid_{ps}=\frac{1}{C-1}\sum_{c=1}^{C} \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)
(\#eq:EstimateSigmaPopulation)
\end{equation}
```
The subscript $ps$ denotes population sampling. As a special case, when $i = i'$, this equation yields the population sampling based variance.

```{=tex}
\begin{equation}
\text{Var}_{i}\mid_{ps}=\frac{1}{C-1}\sum_{c=1}^{C} \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right)^2
(\#eq:EstimateVarPopulation)
\end{equation}
```
The I-values when averaged yield the population sampling based estimate of $\text{Var}$.

Sampling different case-sets, as required by Eqn. \@ref(eq:EstimateSigmaPopulation), is unrealistic. In reality one has $C$ = 1, i.e., a single dataset. Therefore, direct application of this formula is impossible. However, as seen when this situation was encountered before in (book) Chapter 07, one uses resampling methods to realize, for example, different bootstrap samples, which are resampling-based "stand-ins" for actual case-sets. If $B$ is the total number of bootstraps, then the estimation formula is:

```{=tex}
\begin{equation}
\Sigma_{ii'}\mid_{bs} =\frac{1}{B-1}\sum_{b=1}^{B} \left ( \theta_{i\{b\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{b\}} - \theta_{i'\{\bullet\}} \right)
(\#eq:EstimateSigmaBootstrap)
\end{equation}
```
Eqn. \@ref(eq:EstimateSigmaBootstrap), the bootstrap method of estimating the covariance matrix, is a direct translation of Eqn. \@ref(eq:EstimateSigmaPopulation). Alternatively, one could have used the jackknife FOM values $\theta_{i(k)}$, i.e., the figure of merit with a case $k$ removed, repeated for all $k$, to estimate the covariance matrix:

```{=tex}
\begin{equation}
\Sigma_{ii'}\mid_{jk} =\frac{(K-1)^2}{K} \left [ \frac{1}{K-1}\sum_{k=1}^{K} \left ( \theta_{i(k)} - \theta_{i(\bullet)} \right) \left ( \theta_{i'(k)} - \theta_{i'(\bullet)} \right) \right ]
(\#eq:EstimateSigmaJackknife)
\end{equation}
```
[For either bootstrap or jackknife, if $i = i'$, the equations yield the corresponding variance estimates.]

Note the subtle difference in usage of ellipses and parentheses between Eqn. \@ref(eq:EstimateSigmaPopulation) and Eqn. \@ref(eq:EstimateSigmaJackknife). In the former, the subscript $\{c\}$ denotes a set of $K$ cases while in the latter, $(k)$ denotes the original case set with case $k$ removed, leaving $K-1$ cases. There is a similar subtle difference in usage of ellipses and parentheses between Eqn. \@ref(eq:EstimateSigmaBootstrap) and Eqn. \@ref(eq:EstimateSigmaJackknife). The subscript enclosed in parenthesis, i.e., $(k)$, denotes the FOM with case $k$ removed, while in the bootstrap equation one uses the ellipses (curly brackets) $\{b\}$ to denote the $b^{th}$ bootstrap *case-set*, i.e., a whole set of $K_1$ non-diseased and $K_2$ diseased cases, sampled with replacement from the original dataset.

The index $k$ ranges from 1 to $K$, where the first $K_1$ values represent non-diseased cases and the following $K_2$ values represent diseased cases. Jackknife figure of merit values, such as $\theta_{i(k)}$, are not to be confused with jackknife pseudovalues used in the DBM chapters. The jackknife FOM corresponding to a particular case is the FOM with the particular case removed while the pseudovalue is $K$ times the FOM with all cases include minus $(K-1)$ times the jackknife FOM. Unlike pseudovalues, jackknife FOM values cannot be regarded as independent and identically distributed, even when using the empirical AUC as FOM.

### The variance inflation factor {#or-method-intro-elementary-stats-jack-var-inflation-factor}

In Eqn. \@ref(eq:EstimateSigmaJackknife), the expression for the jackknife covariance estimate contains a *variance inflation factor*:

```{=tex}
\begin{equation}
\frac{(K-1)^2}{K}
(\#eq:JKVarianceInflationFactor)
\end{equation}
```

This factor multiplies the traditional expression for the covariance, shown in square brackets in Eqn. \@ref(eq:EstimateSigmaJackknife). It is only needed for the jackknife estimate. The bootstrap and the DeLong estimate, see next, do not require this factor.

A third method of estimating the covariance [@RN112], only applicable to the empirical AUC, is not discussed here; however, it is implemented in the software.

### Meaning of the covariance matrix {#or-method-intro-elementary-stats-meaning-cov-matrix}

With reference to Eqn. \@ref(eq:ExampleSigma), suppose one has the luxury of repeatedly sampling case-sets, each consisting of $K$ cases from the population. A single radiologist interprets these cases in $I$ treatments. Therefore, each case-set $\{c\}$ yields $I$ figures of merit. The final numbers at ones disposal are $\theta_{i\{c\}}$, where $i$ = 1,2,...,$I$ and $c$ = 1,2,...,$C$. Considering treatment $i$, the variance of the FOM-values for the different case-sets $c$ = 1,2,...,$C$, is an estimate of $Var_i$ for this treatment:

```{=tex}
\begin{equation}
\sigma_i^2 \equiv Var_i = \frac{1}{C-1}\sum_{c=1}^{C}\left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right)
(\#eq:EstimateVari)
\end{equation}
```
The process is repeated for all treatments and the $I$-variance values are averaged. This is the final estimate of $\text{Var}$ appearing in Eqn. \@ref(eq:DefinitionEpsilon).

To estimate the covariance matrix one considers pairs of FOM values for the same case-set $\{c\}$ but different treatments, i.e., $\theta_{i\{c\}}$ and $\theta_{i'\{c\}}$; *by definition primed and un-primed indices are different*. The process is repeated for different case-sets. The covariance is calculated as follows:

```{=tex}
\begin{equation}
\text{Cov}_{1;ii'} = \frac{1}{C-1}\sum_{c=1}^{C} \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)
(\#eq:EstimateCov)
\end{equation}
```
The process is repeated for all combinations of different-treatment pairings and the resulting $I(I-1)/2$ values are averaged yielding the final estimate of $\text{Cov}_1$. [Recall that the Obuchowski-Rockette model does not allow treatment-dependent parameters in the covariance matrix - hence the need to average over all treatment pairings.]

Since they are derived from the same case-set, one expects the $\theta_{i\{c\}}$ and $\theta_{i'\{c\}}$ values to be correlated. As an example, for a particularly easy *case-set* one expects $\theta_{i\{c\}}$ and $\theta_{i'\{c\}}$ to be both higher than usual. The correlation $\rho_{1;ii'}$ is defined by:

```{=tex}
\begin{equation}
\rho_{1;ii'} = \frac{1}{C-1}\sum_{c=1}^{C} \frac {\left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)}{\sigma_i \sigma_{i'} }
(\#eq:EstimateRho)
\end{equation}
```
Averaging over all different-treatment pairings yields the final estimate of the correlation $\rho_1$. Since the covariance is smaller than the variance, the magnitude of the correlation is smaller than 1. In most situations one expects $\rho_1$ to be positive. There is a scenario that could lead to negative correlation. With "complementary" treatments, e.g., CT vs. MRI, where one treatment is good for bone imaging and the other for soft-tissue imaging, an easy case-set in one treatment could correspond to a difficult case-set in the other treatment, leading to negative correlation.

To summarize, the covariance matrix can be estimated using the jackknife or the bootstrap, or, in the special case of the empirical AUC figure of merit, the DeLong method can be used. In (book) Chapter 07, these three methods were described in the context of estimating the *variance* of AUC. Eqn. \@ref(eq:EstimateSigmaBootstrap) and Eqn. \@ref(eq:EstimateSigmaJackknife) extend the jackknife and the bootstrap methods, respectively, to estimating the *covariance* of AUC (whose diagonal elements are the variances estimated in the earlier chapter).

### Code illustrating the covariance matrix {#or-method-intro-elementary-stats-code-cov-matrix}

To minimize clutter, the `R` functions (for estimating `Var` and `Cov1` using bootstrap, jackknife, and the DeLong methods) are not shown, but they are compiled. To display them `clone` or 'fork' the book repository and look at the `Rmd` file corresponding to this output and the sourced `R` files listed below:

The following code chunk extracts (using the `DfExtractDataset` function) a single-reader multiple-treatment ROC dataset corresponding to the first reader from `dataset02`, which is the Van Dyke dataset.


```r
rocData1R <- DfExtractDataset(dataset02, rdrs = 1) #select the 1st reader to be analyzed
zik1 <- rocData1R$ratings$NL[,1,,1];K <- dim(zik1)[2];I <- dim(zik1)[1]
zik2 <- rocData1R$ratings$LL[,1,,1];K2 <- dim(zik2)[2];K1 <- K-K2;zik1 <- zik1[,1:K1]
```

The following notation is used in the code below:

-   jk = jackknife method
-   bs = bootstrap method, with B = number of bootstraps and `seed` = value.
-   dl = DeLong method
-   rj_jk = RJafroc, `covEstMethod` = "jackknife"
-   rj_bs = RJafroc, `covEstMethod` = "bootstrap"

For example, `Cov1_jk` is the jackknife estimate of `Cov1`. Shown below are the results of the jackknife method, first using the code in this repository and next, as a cross-check, using `RJafroc` function `UtilORVarComponentsFactorial`:


```r
ret1 <- VarCov1_Jk(zik1, zik2)
Var <- ret1$Var
Cov1 <- ret1$Cov1 # use these (i.e., jackknife) as default values in subsequent code
data.frame ("Cov1_jk" = Cov1, "Var_jk" = Var)
```

```
##        Cov1_jk       Var_jk
## 1 0.0003734661 0.0006989006
```

```r
ret4 <- UtilORVarComponentsFactorial(
  rocData1R, FOM = "Wilcoxon") # the functions default `covEstMethod` is jackknife
data.frame ("Cov1_rj_jk" = ret4$VarCom["Cov1", "Estimates"], 
            "Var_rj_jk" = ret4$VarCom["Var", "Estimates"])
```

```
##     Cov1_rj_jk    Var_rj_jk
## 1 0.0003734661 0.0006989006
```

Note that the estimates are identical and that the $\text{Cov1}$ estimate is smaller than the $\text{Var}$ estimate (their ratio is the correlation $\rho_1 = \text{Cov1}/\text{Var}$ = 0.5343623).

Shown next are bootstrap method estimates with increasing number of bootstraps (200, 2000 and 20,000):


```r
ret2 <- VarCov1_Bs(zik1, zik2, 200, seed = 100)
data.frame ("Cov_bs" = ret2$Cov1, "Var_bs" = ret2$Var) 
```

```
##        Cov_bs       Var_bs
## 1 0.000283905 0.0005845354
```

```r
ret2 <- VarCov1_Bs(zik1, zik2, 2000, seed = 100)
data.frame ("Cov_bs" = ret2$Cov1, "Var_bs" = ret2$Var) 
```

```
##         Cov_bs       Var_bs
## 1 0.0003466804 0.0006738506
```

```r
ret2 <- VarCov1_Bs(zik1, zik2, 20000, seed = 100)
data.frame ("Cov_bs" = ret2$Cov1, "Var_bs" = ret2$Var) 
```

```
##         Cov_bs       Var_bs
## 1 0.0003680714 0.0006862668
```

With increasing number of bootstraps the values approach the jackknife estimates.

Following, as a cross check, are results of bootstrap method as calculated by the `RJafroc` function `UtilORVarComponentsFactorial`:


```r
ret5 <- UtilORVarComponentsFactorial(
  rocData1R, FOM = "Wilcoxon", 
  covEstMethod = "bootstrap", nBoots = 2000, seed = 100)
data.frame ("Cov_rj_bs" = ret5$VarCom["Cov1", "Estimates"], 
            "Var_rj_bs" = ret5$VarCom["Var", "Estimates"])
```

```
##      Cov_rj_bs    Var_rj_bs
## 1 0.0003466804 0.0006738506
```

Note that the two estimates shown above for $B = 2000$ are identical. This is because *the seeds are identical*. With different seeds on expect sampling related fluctuations.

Following are results of the DeLong covariance estimation method, the first output is using this repository code and the second using the `RJafroc` function `UtilORVarComponentsFactorial` with appropriate arguments:


```r
mtrxDLStr <- VarCovMtrxDLStr(rocData1R)
ret3 <- VarCovs(mtrxDLStr)
data.frame ("Cov_dl" = ret3$cov1, "Var_dl" = ret3$var)
```

```
##         Cov_dl       Var_dl
## 1 0.0003684357 0.0006900766
```

```r
ret5 <- UtilORVarComponentsFactorial(
  rocData1R, FOM = "Wilcoxon", covEstMethod = "DeLong")
data.frame ("Cov_rj_dl" = ret5$VarCom["Cov1", "Estimates"], 
            "Var_rj_dl" = ret5$VarCom["Var", "Estimates"])
```

```
##      Cov_rj_dl    Var_rj_dl
## 1 0.0003684357 0.0006900766
```

Note that the two estimates are identical and that the DeLong estimate are close to the bootstrap estimates using 20,000 bootstraps. The just demonstrated close correspondence is only expected when using the Wilcoxon figure of merit, i.e., the empirical AUC.

### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments {#or-method-intro-compare-dbm-or}

We have shown two methods for analyzing a single reader in multiple treatments: the DBM method, involving jackknife derived pseudovalues and the Obuchowski and Rockette method that does not have to use the jackknife, since it could use the bootstrap, or the DeLong method, if one restricts to the Wilcoxon statistic for the figure of merit, to get the covariance matrix. Since one is dealing with a single reader in multiple treatments, for DBM one needs the fixed-reader random-case analysis described in TBA §9.8 of the previous chapter (it should be obvious that with one reader the conclusions apply to the specific reader only, so reader must be regarded as a fixed factor).

Shown below are results obtained using `RJafroc` function `StSignificanceTesting` with `analysisOption = "FRRC"` for `method` = "DBM" (which uses the jackknife), and for OR using 3 different ways of estimating the covariance matrix for the one-reader analysis (i.e., $\text{Cov1}$ and $\text{Var}$).


```r
ret1 <- StSignificanceTesting(
  rocData1R,FOM = "Wilcoxon", method = "DBM", analysisOption = "FRRC")
data.frame("DBM:F" = ret1$FRRC$FTests["Treatment", "FStat"], 
           "DBM:ddf" = ret1$FRRC$FTests["Treatment", "DF"], 
           "DBM:P-val" = ret1$FRRC$FTests["Treatment", "p"])
```

```
##       DBM.F DBM.ddf  DBM.P.val
## 1 1.2201111       1 0.27168532
```

```r
ret2 <- StSignificanceTesting(
  rocData1R,FOM = "Wilcoxon", method = "OR", analysisOption = "FRRC")
data.frame("ORJack:Chisq" = ret2$FRRC$FTests["Treatment", "Chisq"], 
           "ORJack:ddf" = ret2$FRRC$FTests["Treatment", "DF"], 
           "ORJack:P-val" = ret2$FRRC$FTests["Treatment", "p"])
```

```
##   ORJack.Chisq ORJack.ddf ORJack.P.val
## 1    1.2201111          1   0.26933885
```

```r
ret3 <- StSignificanceTesting(
  rocData1R,FOM = "Wilcoxon", method = "OR", analysisOption = "FRRC", 
                              covEstMethod = "DeLong")
data.frame("ORDeLong:Chisq" = ret3$FRRC$FTests["Treatment", "Chisq"], 
           "ORDeLong:ddf" = ret3$FRRC$FTests["Treatment", "DF"], 
           "ORDeLong:P-val" = ret3$FRRC$FTests["Treatment", "p"])
```

```
##   ORDeLong.Chisq ORDeLong.ddf ORDeLong.P.val
## 1      1.2345017            1     0.26653335
```

```r
ret4 <- StSignificanceTesting(
  rocData1R,FOM = "Wilcoxon", method = "OR", analysisOption = "FRRC", 
                              covEstMethod = "bootstrap")
data.frame("ORBoot:Chisq" = ret4$FRRC$FTests["Treatment", "Chisq"], 
           "ORBoot:ddf" = ret4$FRRC$FTests["Treatment", "DF"], 
           "ORBoot:P-val" = ret4$FRRC$FTests["Treatment", "p"])
```

```
##   ORBoot.Chisq ORBoot.ddf ORBoot.P.val
## 1    1.1680667          1   0.27979883
```

The DBM and OR-jackknife methods yield identical F-statistics, but the denominator degrees of freedom are different, $(I-1)(K-1)$ = 113 for DBM and $\infty$ for OR. The F-statistics for OR-bootstrap and OR-DeLong are different.

Shown below is a first-principles implementation of OR significance testing for the one-reader case.


```r
alpha <- 0.05
theta_i <- c(0,0);for (i in 1:I) theta_i[i] <- Wilcoxon(zik1[i,], zik2[i,])

MS_T <- 0
for (i in 1:I) {
  MS_T <- MS_T + (theta_i[i]-mean(theta_i))^2
}
MS_T <- MS_T/(I-1)

F_1R <- MS_T/(Var - Cov1)
pValue <- 1 - pf(F_1R, I-1, Inf)

trtDiff <- array(dim = c(I,I))
for (i1 in 1:(I-1)) {    
  for (i2 in (i1+1):I) {
    trtDiff[i1,i2] <- theta_i[i1]- theta_i[i2]    
  }
}
trtDiff <- trtDiff[!is.na(trtDiff)]
nDiffs <- I*(I-1)/2
CI_DIFF_FOM_1RMT <- array(dim = c(nDiffs, 3))
for (i in 1 : nDiffs) {
  CI_DIFF_FOM_1RMT[i,1] <- trtDiff[i] + qt(alpha/2,  df = Inf)*sqrt(2*(Var - Cov1))
  CI_DIFF_FOM_1RMT[i,2] <- trtDiff[i]
  CI_DIFF_FOM_1RMT[i,3] <- trtDiff[i] + qt(1-alpha/2,df = Inf)*sqrt(2*(Var - Cov1))
  print(data.frame("theta_1" = theta_i[1],
                   "theta_2" = theta_i[2],
                   "Var" = Var,
                   "Cov1" = Cov1,
                   "MS_T" = MS_T,
                   "F_1R" = F_1R, 
                   "pValue" = pValue,
                   "Lower" = CI_DIFF_FOM_1RMT[i,1], 
                   "Mid" = CI_DIFF_FOM_1RMT[i,2], 
                   "Upper" = CI_DIFF_FOM_1RMT[i,3]))
}
```

```
##      theta_1    theta_2           Var         Cov1          MS_T      F_1R
## 1 0.91964573 0.94782609 0.00069890056 0.0003734661 0.00039706618 1.2201111
##       pValue        Lower          Mid       Upper
## 1 0.26933885 -0.078183215 -0.028180354 0.021822507
```

The following shows the corresponding output of `RJafroc`.


```r
ret_rj <- StSignificanceTesting(
  rocData1R, FOM = "Wilcoxon", method = "OR", analysisOption = "FRRC")
print(data.frame("theta_1" = ret_rj$FOMs$foms[1,1],
                 "theta_2" = ret_rj$FOMs$foms[2,1],
                 "Var" = ret_rj$ANOVA$VarCom["Var", "Estimates"],
                 "Cov1" = ret_rj$ANOVA$VarCom["Cov1", "Estimates"],
                 "MS_T" = ret_rj$ANOVA$TRanova[1,3],
                 "Chisq_1R" = ret_rj$FRRC$FTests["Treatment","Chisq"], 
                 "pValue" = ret_rj$FRRC$FTests["Treatment","p"],
                 "Lower" = ret_rj$FRRC$ciDiffTrt[1,"CILower"], 
                 "Mid" = ret_rj$FRRC$ciDiffTrt[1,"Estimate"], 
                 "Upper" = ret_rj$FRRC$ciDiffTrt[1,"CIUpper"]))
```

```
##      theta_1    theta_2           Var         Cov1          MS_T  Chisq_1R
## 1 0.91964573 0.94782609 0.00069890056 0.0003734661 0.00039706618 1.2201111
##       pValue        Lower          Mid       Upper
## 1 0.26933885 -0.078183215 -0.028180354 0.021822507
```

The first-principles and the `RJafroc` values agree exactly with each other [for $I = 2$, the F and chisquare statistics are identical]. This above code also shows how to extract the different estimates ($Var$, $\text{Cov1}$, etc.) from the object `ret_rj` returned by `RJafroc`. Specifically,

-   Var: ret_rj\$ANOVA\$VarCom["Var", "Estimates"]
-   Cov1: ret_rj\$ANOVA\$VarCom["Cov1", "Estimates"]
-   Chisquare-statistic: ret_rj\$FRRC\$FTests["Treatment","Chisq"]
-   df: ret_rj\$FRRC\$FTests[1,"DF"]
-   p-value: ret_rj\$FRRC\$FTests["Treatment","p"]
-   CI Lower: ret_rj\$FRRC\$ciDiffTrt[1,"CILower"]
-   Mid Value: ret_rj\$FRRC\$ciDiffTrt[1,"Estimate"]
-   CI Upper: ret_rj\$FRRC\$ciDiffTrt[1,"CIUpper"]

#### Jumping ahead

If RRRC analysis were conducted, the values are [one needs to analyze a dataset like `dataset02` having more than one treatments and readers and use `analysisOption` = "RRRC"]:

-   msR: ret_rj\$ANOVA\$TRanova["R", "MS"]
-   msT: ret_rj\$ANOVA\$TRanova["T", "MS"]
-   msTR: ret_rj\$ANOVA\$TRanova["TR", "MS"]
-   Var: ret_rj\$ANOVA\$VarCom["Var", "Estimates"]
-   Cov1: ret_rj\$ANOVA\$VarCom["Cov1", "Estimates"]
-   Cov2: ret_rj\$ANOVA\$VarCom["Cov2", "Estimates"]
-   Cov3: ret_rj\$ANOVA\$VarCom["Cov3", "Estimates"]
-   varR: ret_rj\$ANOVA\$VarCom["VarR", "Estimates"]
-   varTR: ret_rj\$ANOVA\$VarCom["VarTR", "Estimates"]
-   F-statistic: ret_rj\$RRRC\$FTests["Treatment", "FStat"]
-   ddf: ret_rj\$RRRC\$FTests["Error", "DF"]
-   p-value: ret_rj\$RRRC\$FTests["Treatment", "p"]
-   CI Lower: ret_rj\$RRRC\$ciDiffTrt["trt0-trt1","CILower"]
-   Mid Value: ret_rj\$RRRC\$ciDiffTrt["trt0-trt1","Estimate"]
-   CI Upper: ret_rj\$RRRC\$ciDiffTrt["trt0-trt1","CIUpper"]

For `RRFC` analysis, one replaces `RRRC` with `RRFC`, etc. I should note that the auto-prompt feature of `RStudio` makes it unnecessary to enter the complex string names shown above - `RStudio` will suggest them.
