# tidyshiny

> Interactively manipulate data with the `tidyr` package using this handy shiny gadget. 

[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
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
