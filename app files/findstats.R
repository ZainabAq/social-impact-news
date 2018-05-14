#loading in data
politics_s3 <- read.csv("FINAL_DATA_FOR_SQL.csv")

#To use SQL database (OUR MODELS DO NOT RUN WITH SQL)

# db <- src_mysql(dbname = "social_impact", host="scidb.smith.edu", port=3306, user = "capstone18", password="xxx")
# # 
# politics_s3 <- db %>%
#   tbl("FINAL_POLITICS") %>%
#   collect(n = Inf)
# 
# politics_s3 <- read.csv("politics-data-for-model-final2.csv")

#loading in models

load(file = 'GBM_Final.rda')

load(file = 'svmFINALFINAL.rda')

load(file = 'logisitic_regression_final.rda')

###BOOSTING

#New data for boosting, removing both impact columns
politics_boost <- politics_s3 %>%
  select(-Impact, -impact)
  # mutate(Li_ref = as.factor(Li_ref), Pi_ref = as.factor(Pi_ref), Li_int = as.factor(Li_int), Pi_int = as.factor(Pi_int))

pred <- predict(object=mpf6, politics_boost, type='prob')

pred <- pred %>%
  select(Y)

pred <- as.vector(pred$Y)

###LOGISTIC

#data for logistic
# politics_s3_log <- politics_s3 %>%
#   rename('Social interactions' = Social_interactions, "smog-index" = smog_index, "total-words" = total_words)

pred_log <- predict(m5, politics_s3, type = "response")

###SVM

library(e1071)
#new data for svm, removing both impact columns
politics_svm <- politics_s3 %>%
  select(-Impact, -impact)

pred_svm <- predict(bestmod2, politics_svm, probability = TRUE)

pred40 <- data.frame(attr(pred_svm, "probabilities"))

pred40 <- pred40 %>%
  select(X1)

pred40 <- as.vector(pred40$X1)


######Adding new columns
politics_s3 <- politics_s3 %>%
  mutate(predboosting = pred, predlog = pred_log, predsvm = pred40)

#Functions
############################

findvar <- function(x, y){
  data7 <- politics_s3%>%
    mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
    arrange(desc(yes_URL)) %>%
    select(y) %>%
    head(1)
  
  c(t(data7))
}

# findtable <- function(x, y){
#     data10 <- politics_s3%>%
#       mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#       arrange(desc(yes_URL)) %>%
#       select(y) %>%
#       head(1)
#     
#     formattable(data10)
#   }
# 
# findtable1 <- function(x){
#   data8 <- politics_s3%>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select(`Total words` = total_words, Views, `TW interactions` = Tw_interactions) %>%
#     head(1)
#   
#   formattable(data8)
# }
# 
# findtable2 <- function(x){
#   data9 <- politics_s3%>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select(`Total words` = total_words,`Negative1` = neg1, `Positive2` =pos2) %>%
#   head(1)
#   
#   formattable(data9)
# }
# 
# findtable3 <- function(x){
#   data11 <- politics_s3%>%
#     mutate(yes_URL = ifelse(URL == x, 1, 0)) %>%
#     arrange(desc(yes_URL)) %>%
#     select(`FB references` = Fb_refs, `New visitors` = New_vis., `Mobile views` = Mobile_views) %>%
#     head(1)
#   
#   formattable(data11)
# }
