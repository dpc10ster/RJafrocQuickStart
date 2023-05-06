--- 
title: "The RJafroc Quick Start Book"
author: "Dev P. Chakraborty, PhD"
geometry: margin=2cm
date: "2023-05-06"
site: bookdown::bookdown_site
output: html_document
documentclass: book
bibliography: [packages.bib, myRefs.bib]
biblio-style: apalike
link-citations: yes
github-repo: dpc10ster/RJafrocQuickStart
description: "This book is for those already somewhat familiar running Windows JAFROC to analyze data. The Windows program has been replaced by RJafroc. This book dives into how to use RJafroc to analyze ROC/FROC data."
---






# Preface {#quick-start-index-preface}

TBA


## Rationale and Organization {#quick-start-index-rationale-and-organization}

* See [here](https://dpc10ster.github.io/ai-froc-research/) for an overview of my AI/FROC research websites. 
* All references in this book to `RJafroc` refer to the `R` package with that name (case sensitive) [@R-RJafroc]. 


## Getting help on the software {#quick-start-index-getting-help}

* If you have installed `RJafroc` from `GitHub`:
    + Type ?`RJafroc-package` (RStudio will auto complete ...) followed by `Enter`.
    + Scroll down and click on `Index`
* Regardless of where you installed from you can use the `RJafroc` [website ](https://dpc10ster.github.io/RJafroc/) to access help.
    + Look under the `Reference` tab. 
    + For example, for help on the function `PlotEmpiricalOperatingCharacteristics` look [here](https://dpc10ster.github.io/RJafroc/reference/PlotEmpiricalOperatingCharacteristics.html)


## Acknowledgements {#quick-start-index-acknowledgements}

TBA 

### Persons who have stimulated my thinking:

Harold Kundel, MD

Claudia Mello-Thoms, PhD

Dr. Xuetong Zhai (contributed significantly to the significance testing sections and other chapters of my book).


## Contributors to the software {#quick-start-index-contributors}

Dr. Xuetong Zhai (he developed the first version of `RJafroc`)

Dr. Peter Phillips

Online Latex Editor at this [website](https://latexeditor.lagrida.com/). I found this very useful in learning and using Latex to write math equations. 


## Dataset contributors {#quick-start-index-dataset-contributors}

TBA


## Accessing files and code {#quick-start-index-how-to-access-files}

You would not normally need to access the files used to create the book. But if you are adventurous, ...

To access files/code one needs to `fork` the `GitHub` repository. This will create, on your computer, a copy of all files used to create this document. To compile the files try `Build Book` and select `gitbook`. You will probably get errors corresponding to missing packages that are not loaded on your machine. All required packages are listed in the DESCRIPTION file. Install those packages and try again ...

