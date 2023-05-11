# R-project - revapp

<code>revapp</code> is a R package that core functionality is to analyse a reviews from an AppStore.

# Packages

For developing purposes we used following packages:

* [usethis](https://github.com/cran/usethis): especially useful:
    * usethis::use_data when creating data for your package, 
    * usethis::use_package_doc for managing dependencies [see](https://r-pkgs.org/dependencies-in-practice.html#sec-dependencies-in-imports-r-code)
* [checkmate](https://mllg.github.io/checkmate/): validating function arguments
* [devtools](https://devtools.r-lib.org/): documenting, testing, checking and building package
    * devtools::document()
    * devtools::test_coverage_file()
* [roxygen2](https://roxygen2.r-lib.org/): documenting package
* [lintr](https://github.com/r-lib/lintr/) for keeping the codes neat (see for yourself using `lintr::lint_package()`)

For additional information about R package development check [R Packages (2e)](https://r-pkgs.org/)

For the application part of the project:

* [shiny](https://github.com/rstudio/shiny) for, well, Shiny
* [appler](https://github.com/cran/appler) for downloading reviews 
* [data.table](https://rdatatable.gitlab.io/data.table/) for data manipulation
* [ggplot2](https://ggplot2.tidyverse.org/) for visualizations
* [DT](https://github.com/rstudio/DT) for displaying tables in Shiny

# Shiny application

To run the application:

* clone this repo
* open up the `revapp.Rproj`
* run `devtools::load_all()`
* run `shiny::runApp("inst")`

# How this project complies with the requirements?

1. Writing own advanced functions in R (including defensive programming)
    
    As far as the defensive programing oges, our functions includes wide range of assertions of the parameters.
    To do: 
    * some advanced functions
    
2. Object-oriented programming - creating own classes, methods and generic functions of the S3, S4 and R6 systems
    
    We've decided to use S4 system. We have class and appriopriate methods for:
    * `review` - class represting single review. Methods:
        * tokenize_review
    * review_set - class representing set of reviews. Methods:
        * tokenize_review_set
    To do:
    * add additional classes and methods (for cleaning data, for calculating statistics, for visualizations)
3. Use of C++ in R (Rcpp)
    
    It was not a part of our proposal
4. Vectorisation of the code
    
    It was not a part of our proposal
5. Shiny + creating analytical dashboards
    
    Part of the repo contains ui and server logic. We have used:
    * widgets like `selectInput` or `dateRangeInput`, 
    * reactive expressions to optimize performance.
    * using a condtional panel for different tabs
    
    To do:
    * using fileInput for data for an user
    * using custom .css file
    * add input to user to run some analysis
    * adding reactive values and isolates
6. Creating own R packages
    
    All of the functions are wrapped into the R package structure. Apart from wrting functions, we've also:
    * added sample data and wrapped it into data - data-raw logic
    * added inst/ directory to contain all the files necessary to run Shiny application
    * added documentation for all the functions
    * added tests to those functions

# Steps

* write out pipeline in a way that each step is covered in some function. describe briefly those functions and arguments of those functions
* modify the `app.R` file by adding description on each tab what the user would be enable to see/do/modify on each tab
* based on the description insert dummy output presenting the logic in form fo buttons, plots, tables etc.
* write out specific function and simple documentation for those functions
* try to organize the functions in a set of classes and methods (eg. to store data for reviews, creating specific visualizations)
* add assertions to the functions and tests
* assess package from the technical point of view (with `devtools::check()`)
* assess package from th Advanced R point of view (are the functions advanced enough, are all of the needed things included)

## Pipeline

First step: clean the data

* clean_the_data()
    * tokenize() 
    * remove_stop_words()
    * remove_punctioans()
