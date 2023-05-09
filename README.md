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

# Shiny application

To run the application:

* clone this repo
* run `devtools::load_all()`
* run `shiny::runApp("inst")`

# To do:

* add hyperlinks to the packages mentioned in README
* add dummy output to the app to present the logic
* create a class to store data for reviews, creating specific visualizations
* add assertions to the functions and tests

# How this project complies with the requirements?

1. Writing own advanced functions in R (including defensive programming)
    To do: some advanced functions
    As far as the defensive programing oges, our functions includes wide range of assertions of the parameters.
2. Object-oriented programming - creating own classes, methods and generic functions of the S3, S4 and R6 systems
    We've decided to use S4 system
3. Use of C++ in R (Rcpp)
    It was not a part of our proposal
4. Vectorisation of the code
    It was not a part of our proposal
5. Shiny + creating analytical dashboards
    Part of the repo contains ui and server logic
6. Creating own R packages
    All of the functions are wrapped into the R package structure. Apart from wrting functions, we've also:
    * added sample data and wrapped it into data - data-raw logic
    * added inst/ directory to contain all the files necessary to run Shiny application
    * added documentation for all the functions
    * added tests to those functions
