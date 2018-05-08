#loading in data
# data <- read.csv("politics-s3-merged.csv")
politics_s3 <- read.csv("politics-data-for-model-final2.csv")

# politics_s3 <- read.csv("FINAL_DATA_FOR_SQL.csv")

#loading in models
# load(file = 'boosting2.rda')
load(file = 'boostingfinal.rda')
# load(file = 'boostingFINALFINAL.rda')
# load(file = 'boosting.rda')
# load(file = 'svm.rda')
load(file = 'svm-final.rda')
# load(file = 'svmFinal.rda')
# load(file = 'logistic_regression_model_s3.rda')
load(file = 'logistic_regression_model_s4.rda')
# load(file = 'logistic_regression_FINAL.rda')

#Creating new politics data, where impact is a character vector
politics_boost <- politics_s3 %>%
  mutate(Li_ref = as.factor(Li_ref), Pi_ref = as.factor(Pi_ref), Li_int = as.factor(Li_int), Pi_int = as.factor(Pi_int))

#predicting from boosting and boosting 2 models
# pred1 <- predict(mp6, politics_boost)

pred <- predict(object=mp6, politics_boost, type='prob')

pred <- pred %>%
  select(Y)

pred <- as.vector(pred$Y)

#data for logistic
# politics_s3_log <- politics_s3 %>%
#   rename('Social interactions' = Social_interactions, "smog-index" = smog_index, "total-words" = total_words)

pred_log <- predict(m5, politics_s3, type = "response")

#SVM
library(e1071)
# politics_svm <- politics_s3 %>%
#   rename(ImpactBinary = impact) %>%
#   select(-Impact, -URL, -Title)

pred_svm <- predict(bestmod, politics_s3, probability = TRUE)

pred40 <- data.frame(attr(pred_svm, "probabilities"))

pred40 <- pred40 %>%
  select(X1)

pred40 <- as.vector(pred40$X1)


######Adding new columns
politics_s3 <- politics_s3 %>%
  mutate(predboosting = pred, predlog = pred_log, predsvm = pred40)

#Rounding
# data$predimpact <- round(data$predimpact, digits = 2)
# 
# data$huffpost <- round(data$huffpost, digits = 2)
# 
# data$predlog <- round(data$predlog, digits = 2)

#Functions

############# DONT NEED ANY OF THIS BECAUSE OF FINDVAR FUNCTION

# findstats <- function(x){
#   
#   data1 <- politics_s3 %>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     head(1)
# 
# }
# 
# findtitle <- function(x){
#   
#   data1 <- politics_s3 %>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select("Title")%>%
#     head(1)
#   
#   c(t(data1))
#   
# }
# 
# findboosting <- function(x){  
#   data2 <- politics_s3 %>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select("predboosting") %>%
#     head(1)
#   
#   c(t(data2))
# }

# findboosting <- function(x){  
#   data3 <- data %>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select("predimpact_2") %>%
#     head(1)
#   
#   c(t(data3))
# }

####We might want this??
# findhuff <- function(x){  
#   data4 <- data %>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select("huffpost") %>%
#     head(1)
#   
#   c(t(data4))
# }

########## DONT NEED ANY OF THIS WITH FINDVAR FUNCTION BELOW 

# findsvm <- function(x){  
#   data3 <- politics_s3 %>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select("predsvm") %>%
#     head(1)
#   
#   c(t(data3))
# }
#   
# findlog <- function(x){  
#   data4 <- politics_s3 %>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select("predlog") %>%
#     head(1)
#   
#   c(t(data4))
# }
# 
# findours <- function(x){  
#   data5 <- politics_s3 %>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select("impact") %>%
#     head(1)
#   
#   c(t(data5))
# }
#   
# findtotalwords <- function(x){  
#   data6 <- politics_s3 %>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select("total_words") %>%
#     head(1)
#   
#   c(t(data6))
# }

############################

findvar <- function(x, y){
  data7 <- politics_s3%>%
    mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
    arrange(desc(yes_URL)) %>%
    select(y) %>%
    head(1)
  
  c(t(data7))
}

findtable <- function(x, y){
    data10 <- politics_s3%>%
      mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
      arrange(desc(yes_URL)) %>%
      select(y) %>%
      head(1)
    
    formattable(data10)
  }

findtable1 <- function(x){
  data8 <- politics_s3%>%
    mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
    arrange(desc(yes_URL)) %>%
    select(`Total words` = total_words, Views, `TW interactions` = Tw_interactions) %>%
    head(1)
  
  formattable(data8)
}

findtable2 <- function(x){
  data9 <- politics_s3%>%
    mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
    arrange(desc(yes_URL)) %>%
    select(`Total words` = total_words,`Negative1` = neg1, `Positive2` =pos2) %>%
  head(1)
  
  formattable(data9)
}

findtable3 <- function(x){
  data11 <- politics_s3%>%
    mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
    arrange(desc(yes_URL)) %>%
    select(`FB references` = Fb_refs, `New visitors` = New_vis., `Mobile views` = Mobile_views) %>%
    head(1)
  
  formattable(data11)
}