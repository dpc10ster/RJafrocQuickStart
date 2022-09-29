--- 
title: "The RJafroc Quick Start Book"
author: "Dev P. Chakraborty, PhD"
date: "2022-09-29"
site: bookdown::bookdown_site
output: 
   bookdown::pdf_document: default
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


## TBA Acknowledgements

Dr. Xuetong Zhai

Dr. Peter Phillips

Online Latex Editor [at](https://latexeditor.lagrida.com/) 

Dataset contributors


