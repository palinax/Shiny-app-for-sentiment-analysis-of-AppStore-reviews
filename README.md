# R-project - revapp

<code>revapp</code> is a R package that core functionality is to analyse a reviews from an AppStore.

# Packages

For developing purposes we used following packages:

* usethis: especially useful:
    * usethis::use_data when creating data for your package, 
    * usethis::use_package_doc for managing dependencies [see](https://r-pkgs.org/dependencies-in-practice.html#sec-dependencies-in-imports-r-code)
* checkmate: validating function arguments
* devtools: documenting, testing, checking and building package
    * devtools::document()
    * devtools::test_coverage_file()
* roxygen2: documenting package

For additional information about R package development check [R Packages (2e)](https://r-pkgs.org/)

Other packages:

* [appler](https://github.com/cran/appler) for downloading reviews 
* data.table: data manipulation
* ggplot2: visualizations

# To do:

* add hyperlinks to the packages mentioned in README
* add inst/ directory with shiny files
