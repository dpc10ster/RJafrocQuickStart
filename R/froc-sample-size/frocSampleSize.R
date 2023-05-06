frocSampleSize <- function (NHdataset, J, K, lesDistr, effectSizeROC) {

  JStar <- length(NHdataset$ratings$NL[1,,1,1])
  KStar <- length(NHdataset$ratings$NL[1,1,,1])

  if (missing(lesDistr)) {
    lesDistr <- UtilLesDistr(NHdataset)
  }
  
  ret <- SsFrocNhRsmModel(NHdataset, lesDistr = lesDistr$Freq)
  muNH <- ret$mu
  lambdaNH <- ret$lambda
  nuNH <- ret$nu
  scaleFactor <- ret$scaleFactor
  effectSizewAFROC <- effectSizeROC*scaleFactor$coefficients[1]
  
  RocDatasetBin <- DfBinDataset(DfFroc2Roc(NHdataset), opChType = "ROC")
  varComp_roc <- UtilVarComponentsOR(
    DfFroc2Roc(NHdataset), 
    FOM = "Wilcoxon")$VarCom[-2]
  
  varComp_wafroc <- UtilVarComponentsOR(
    NHdataset, 
    FOM = "wAFROC")$VarCom[-2]
  
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
  power_roc <- ret$powerRRRC
  
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
  power_wafroc <- ret$powerRRRC
  
  return(list(
    powerRoc = power_roc,
    powerFroc = power_wafroc
  ))
    
}