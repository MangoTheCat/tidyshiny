# tidyshiny

> Interactively manipulate data with the `tidyr` package using this handy shiny gadget. 

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Travis-CI Build Status](https://travis-ci.org/MangoTheCat/tidyshiny.svg?branch=master)](https://travis-ci.org/MangoTheCat/tidyshiny)
[![](http://www.r-pkg.org/badges/version/tidyshiny)](http://www.r-pkg.org/pkg/tidyshiny)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/tidyshiny)](http://www.r-pkg.org/pkg/tidyshiny)

## Installation

```r
library(devtools)
install_github("MangoTheCat/tidyshiny")
```

## Usage

After launching the gadget with the `tidyData` function you will be able to set the `key` and `value` arguments and select columns. The gadget will preview the data that will be generated from the function call that is returned unless no columns are selected. 

```r
library(tidyshiny)

# Create a dataset object for the gadget to detect
testData <- airquality
tidyData()

# Alternatively pass the data to the tidyData function call
tidyData(iris)
```

This package has been setup to work with RStudio addin's and it will be available from the addins menu after installing the package.
