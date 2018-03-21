findstats <- function(x){
  data <- read.csv("Raw data_10000 articles_Jul-Dec 2017.csv")
  
  data <- data %>%
    mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
    arrange(desc(yes_URL)) %>%
    select("Title", "Views", "Visitors") %>%
    head(1)
  
  formattable::formattable(data)
}

parser <- system('python Parser.py Batch_3155287_batch_results.csv')