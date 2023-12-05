install.packages("dplyr")
install.packages("jsonlite")
install.packages("rvest")
install.packages("glue")

library(dplyr)
library(jsonlite)
library(rvest)
library(glue)

rm(list = ls())
setwd("/Users/minwukim/Desktop/KDI Research/OPEC/OPEC-in-the-news/analysis")


apiKey <- "6BZtZvYLg0r5BhyUM2L4ONsAS0x5JMLt"
query = "opec"
begin_date = "20060818"
end_date = "20231117"
baseUrl <- "http://api.nytimes.com/svc/search/v2/articlesearch.json?q={query}&begin_date={begin_date}&end_date={end_date}&sort=oldest"

baseUrl <- glue(baseUrl)
baseUrl

articles <- list()
for(i in 0:199){ 
  # The following line will create the necessary URL by pasting together a few
  # elements: the base URL, the page argument (which changes), and the key.
  req <- fromJSON(paste0(baseUrl, "&page=", i, '&api-key=', apiKey), flatten=TRUE)
  # This line tells the loop to give us a message telling us which page it is on
  message("Retrieving page ", i)
  # We will save the queried articles in the empty 'articles' object we created
  articles[[i+1]] <- req$response$docs
  # Because we do not want to overwhelm the API, let's make one search every
  # 30 seconds.
  Sys.sleep(12)
  # Close the loop and run it! Look for the retrieving status in the console.
}


# First, combine all page results into one dataframe (and drop empty entries)
scrape <- rbind_pages(articles[sapply(articles, length)>0])
# Let's check the initial dataframe
nrow(scrape) # the number of rows should = 10*3 because there are 10 results per page
# Let's see what variables we have
colnames(scrape)
# View a snippet of the data and the class of each variable
as_tibble(scrape) # the web_url, for example, is 'character' class

scrape_simple <- scrape[, c("abstract", "web_url", "snippet", "lead_paragraph", 
                            "print_section", "print_page", "pub_date", "_id", 
                            "word_count", "uri")]

directory <- "nyt_scrape.csv"
write.csv(scrape_simple, directory, row.names=FALSE)
toCollect <- scrape$web_url #vector of urls

docs <- list()

for(i in 1:length(toCollect)){
  xml <- read_html(toCollect[i])
  message("Retrieving page ", i)
  # Once the loop calls the page, we need to scrape the article text (and not
  # other stuff like the headline and associated links). To identify the
  # main text I used the CSS Selector tool --
  # https://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/ --
  # to find which label identifies the main text. On the pages of The New
  # York Times, it is '.story-content'.
  txt <- xml %>%
    html_nodes("div.StoryBodyCompanionColumn div p") %>%
    html_text()
  # Collapse each paragraph into one long string of words
  text <- paste(txt, collapse = '') 
  # Get ride of line breaks
  text <- gsub('\n', ' ', text) #-A bit fancier version of strip: sub("[[:space:]]+$", "", names)
  docs[[i]] <- text
  # Scrape one article very eight seconds
  Sys.sleep(5)
  # Close and execute the loop! Look for the status message!
}


doc_text <- as.data.frame(matrix(unlist(docs), byrow=T))
# Name the new variable (column) of the text
names(doc_text) <- 'doc_text'
# Combine the text with the other variables
text_data <- cbind(scrape, doc_text)
# Check the variables in the dataframe. Is 'doc_text' there? What class is it?
as_tibble(text_data)
# If 'doc_text' is a factor, so let's make convert it to character class
text_data$doc_text <- as.character(text_data$doc_text)
# View the text of a few articles
head(text_data$doc_text)


dir <- "nyt_oil.csv"
text_data <- apply(text_data,2,as.character)
write.csv(text_data, dir, row.names=FALSE)
