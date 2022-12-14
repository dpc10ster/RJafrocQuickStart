--- 
title: "The RJafroc Quick Start Book"
author: "Dev P. Chakraborty, PhD"
geometry: margin=2cm
date: "2022-12-14"
site: bookdown::bookdown_site
output: pdf_document
documentclass: book
bibliography: [packages.bib, myRefs.bib]
biblio-style: apalike
link-citations: yes
github-repo: dpc10ster/RJafrocQuickStart
description: "This book is for those already somewhat familiar running Windows JAFROC to analyze data. The Windows program has been replaced by RJafroc. This book dives into how to use RJafroc to analyze ROC/FROC data."
---






# Preface {-}

* This online book is for those already somewhat familiar running Windows JAFROC to analyze data. 
* The Windows program has been replaced by `RJafroc`. 
* This book dives into how to use `RJafroc` to analyze ROC/FROC data.
* It starts with explanation of the dataset structures for ROC and FROC studies.
* This is followed by an explanation of DBM and OR analyses.


## Rationale and Organization

* Intended as an online update to my print book [@chakraborty2017observer].
* All references in this book to `RJafroc` refer to the R package with that name (case sensitive) [@R-RJafroc]. 
* Since its publication in 2017 `RJafroc`, on which the `R` code examples in the print book depend, has evolved considerably causing many of the examples to "break" if one uses the most current version of `RJafroc`. The code will still run if one uses [`RJafroc` 0.0.1](https://cran.r-project.org/src/contrib/Archive/RJafroc/) but this is inconvenient and misses out on many of the software improvements made since the print book appeared.
* This gives me the opportunity to update the print book.
* The online book has been divided into 3 books.
    + **This book:** [RJafrocQuickStartBook](https://dpc10ster.github.io/RJafrocQuickStart/).
    + The [RJafrocRocBook](https://dpc10ster.github.io/RJafrocRocBook/) book.
    + The [RJafrocFrocBook](https://dpc10ster.github.io/RJafrocFrocBook/).


## Getting help on the software

* If you have installed `RJafroc` from `GitHub`:
    + ?`RJafroc-package` (RStudio will auto complete ...) followed by Enter.
    + Scroll down all the way and click on `Index`
* Regardless of where you installed from use the `RJafroc` help site:
    + [RJafroc help site](https://dpc10ster.github.io/RJafroc/)
    + Look under the `Reference` tab. 
    + For example, for help on the function `PlotEmpiricalOperatingCharacteristics`:
    + [PlotEmpiricalOperatingCharacteristics](https://dpc10ster.github.io/RJafroc/reference/PlotEmpiricalOperatingCharacteristics.html)




## TBA Acknowledgements

### Persons who have stimulated my thinking:

Harold Kundel, MD

Claudia Mello-Thoms, PhD

### Contributors to the software

Dr. Xuetong Zhai

Dr. Peter Phillips

Online Latex Editor [at](https://latexeditor.lagrida.com/) 

### Dataset contributors

TBA


