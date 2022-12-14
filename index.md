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






# Preface {#quick-start-index-preface}

* This online book is for those already somewhat familiar running Windows JAFROC to analyze data. It is also intended for those unfamiliar with Windows JAFROC but have read the other books and wish to apply the methods.
* The Windows program has been replaced by `RJafroc`. 
* This book dives into how to use `RJafroc` to analyze ROC/FROC data.
* It starts with explanation of the dataset structures for ROC and FROC studies.
* This is followed by an explanation of DBM and OR analyses.
* TBA.


## Rationale and Organization {#quick-start-index-rationale-and-organization}

* Intended as an online update to my print book [@chakraborty2017observer].
* All references in this book to `RJafroc` refer to the R package with that name (case sensitive) [@R-RJafroc]. 
* Since its publication in 2017 `RJafroc`, on which the `R` code examples in the print book depend, has evolved considerably causing many of the examples to "break" if one uses the most current version of `RJafroc`. The code will still run if one uses [`RJafroc` 0.0.1](https://cran.r-project.org/src/contrib/Archive/RJafroc/) but this is inconvenient and misses out on many of the software improvements made since the print book appeared.
* This gives me the opportunity to update the print book.
* The online book has been divided into 3 books.
    + **This book:** [RJafrocQuickStartBook](https://dpc10ster.github.io/RJafrocQuickStart/).
    + The [RJafrocRocBook](https://dpc10ster.github.io/RJafrocRocBook/) book.
    + The [RJafrocFrocBook](https://dpc10ster.github.io/RJafrocFrocBook/).


## Getting help on the software {#quick-start-index-getting-help}

* If you have installed `RJafroc` from `GitHub`:
    + ?`RJafroc-package` (RStudio will auto complete ...) followed by Enter.
    + Scroll down all the way and click on `Index`
* Regardless of where you installed from you can use the `RJafroc` website:
    + [RJafroc help site](https://dpc10ster.github.io/RJafroc/)
    + Look under the `Reference` tab. 
    + For example, for help on the function `PlotEmpiricalOperatingCharacteristics`:
    + [PlotEmpiricalOperatingCharacteristics](https://dpc10ster.github.io/RJafroc/reference/PlotEmpiricalOperatingCharacteristics.html)




## TBA Acknowledgements {#quick-start-index-acknowledgements}

### Persons who have stimulated my thinking:

Harold Kundel, MD

Claudia Mello-Thoms, PhD

Dr. Xuetong Zhai (contributed significantly to the significance testing sections and other chapters of my book).

### Contributors to the software {#quick-start-index-contributors}

Dr. Xuetong Zhai (he developed the first version of `RJafroc`)

Dr. Peter Phillips

Online Latex Editor [at](https://latexeditor.lagrida.com/) 

### Dataset contributors {#quick-start-index-dataset-contributors}

TBA


## Accessing files and code {#quick-start-index-how-to-access-files}

To access files/code one needs to `fork` the `GitHub` repository. This will create, on your computer, a copy of all files used to create this document. To compile the files try `Build Book` and select `gitbook`. You will probably get errors corresponding to missing packages that are not loaded on your machine. All required packages are listed in the DESCRIPTION file. Install those packages and try again ...



