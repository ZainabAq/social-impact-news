library(readr)

turk <- read_csv("C:/Users/choco/Desktop/SPRING 2018/Capstone/Batch_3145287_batch_results.csv")

summary(turk)
turk$WorkerId <- as.factor(turk$WorkerId)

turk2 <- turk %>%
  select(WorkerId, WorkTimeInSeconds,Answer.categories) %>%
  add_count(WorkerId)%>%
  group_by(WorkerId) %>%
  mutate(cat_0=count(Answer.categories=="category 1")) %>%
  mutate(cat_1=count(Answer.categories=="category 2")) %>%
  mutate(perc_0=cat_0/(cat_0+cat_1)) %>%
  mutate(perc_1=cat_1/(cat_0+cat_1)) %>%
  mutate(avg_sec=mean(WorkTimeInSeconds)) %>%
  filter(n>30)%>%
  select(-cat_0,-cat_1,-WorkTimeInSeconds,-Answer.categories)

turk2$check_perc <- ifelse(turk2$perc_0<0.2|turk2$perc_1<0.2, 1, 0)
turk2$check_sec <- ifelse(turk2$avg_sec<5, 1, 0)
turk2$check_both <- ifelse(turk2$check_perc=="1" & turk2$check_sec=="1",1,0)

turk2 <- unique(turk2)




