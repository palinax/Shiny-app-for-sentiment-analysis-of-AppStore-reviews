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

Writing own advanced functions in R (including defensive programming)
    
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
reviews$review vector of strings 
* Text pre-processing textpreProcess() input reviews$review, output: reviews$processesed_reviews (vector of lists of strings)
   * this func incorporates below functions 

    * Lowercase the reviews: tolower(reviews$review) output: reviews$processesed_reviews (vector of strings)
    * Remove numerical digits & punctuation  gsub("[0-9[:punct:]]", "", reviews$processesed_reviews), output(reviews$processesed_reviews)
    * Tokenize text into individual words word_tokenize(reviews$processesed_reviews), output: reviews$processesed_reviews vector of lists of strings. Basically bring tokens for each review back to DataFrame.
       a. output looks like Row1: 'love','snapchat'.
                            Row2: 'hate', 'snapchat
    *  Remove stopwords remoweWords(reviews$processesed_reviews) output (reviews$processesed_reviews) output: vector of lists of strings. 
       a. This is part of tm package, if we want to do manually - need to define all stopwords and exclude them from tokenized_reviews. 
    * Perform stemming to reduce words to their roots/base stemDocument(reviews$processesed_reviews).Output reviews$processesed_reviews output: vector of lists of strings
      a. There`s a wordStem() from the SnowballC package as it`s complicated fucntion. It basically reduce word to its root like **bright**ful = bright. 


* Wordcloud
   * For wordclout, we first need to flatten reviews i.e. to create a single combined vector of words and their frequencies 
   * Calculate terms frequency in a given text corpus termFreq()
   * Generate word cloud wordCloud(combined_reviews, word_freqs)

Example:

library(wordcloud)

# Flatten your list of lists into a single vector of words
combined_reviews <- unlist(reviews$processesed_reviews)
# Calculate word frequencies
word_freqs <- table(combined_reviews)
# Generate the word cloud
wordcloud(names(combined_reviews), freq = word_freqs)
    
* Sentiment Analysis sentimentScore() 

Vector of strings needs to be an input to sentiment analysis. 

Example: library(syuzhet)

# apply get_sentiment() to the review column
reviews$processed_reviews <- as.character(reviews$processed_reviews)
sentiment_scores <- get_sentiment(reviews$processed_reviews)

    * Assign sentiment scores to the pre-processed text per each review assignScores(reviews$processed_reviews) output sentiment_scores, not sure what`s exact output need to run code
    * Calculate average sentiment for the app averageSentiment(). Need to sum sentiment scores and divide by len(reviews$processed_reviews) and display on app
    * Dispaly on app table with reviews with sentiments score & sentiments assigned. It is a DF with reviews and added column with scores 
   
* Sentiment Visualisations sentimentVizual()
   * Sentiment distribution for a chosen app pie chart with count / percentage of positive, negative, neutral sentimentDistributionPie()
   * Sentiment distribution as a histogram with sentiment scrores across app sentimentDistributionHist() 
   * Sentiment ratio sentimentRatio() 
   * Sentiments stats like Standard Deviation, Min/Max, percentile sentimentStats()
  
* Topic modelling topicModel(input: DocumentTermMatrix, n of topics (k))

* library(topicmodels)
* library(tm)

   * Input: Pre-processed and tokenized list of lists of strings (or review object we discussed!) needs to be transformed to a document-word matrix, n of topics (let`s choose 3) 
   * Example how to create document_term_marix 
   * # Create a list of lists of tokenized strings
         tokenized_text <- list(
          c("this", "is", "the", "first", "document"),
          c("this", "is", "the", "second", "document"))
# Create a Corpus object from the tokenized text
corpus <- Corpus(VectorSource(tokenized_text))
# Create a document-word matrix
dtm <- DocumentTermMatrix(corpus)

* The output of LDA topic modeling includes:

   * Extracted topics: A set of topics identified by the LDA model, where each topic is represented by a distribution of words with associated probabilities. These topics can provide insights into the main themes or issues discussed in the reviews.
   * Topic-word distribution: The probability distribution of words within each topic, which indicates the importance of each word in contributing to a specific topic.
   * Document-topic distribution: The distribution of topics within each app store review, indicating the likelihood of a review belonging to a particular topic.
   * Topic summaries: A summary of the most probable words associated with each topic, allowing you to interpret and label the topics based on the prominent words.

* Expected output of the app:
   * Bar plots displaying the top-N words or terms for each topic along with their corresponding probabilities or frequencies. Each topic is represented by a bar chart, with the height of the bars indicating the importance of each word within the topic. Example: pink/green/blue bars: https://rpubs.com/asmi2990/988736
