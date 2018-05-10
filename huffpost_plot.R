#Huff
# huff <- data.frame(data$huffpost)
# 
# huff <- huff %>%
#   select(data.predimpact2 = data.huffpost)

#Boosting
boosting <- data.frame(politics_s3$predboosting)

boosting <- boosting %>%
  select(politics_s3.predimpact = politics_s3.predboosting)

#Log
log <- data.frame(politics_s3$predlog)

log <- log %>%
  select(politics_s3.predimpact = politics_s3.predlog)

#SVM
# data$predsvm <- as.numeric(data$predsvm)
svm <- data.frame(politics_s3$predsvm)

svm <- svm %>%
  select(politics_s3.predimpact = politics_s3.predsvm)

#adding column
# huff$Model <- 'HuffPost'
boosting$Model<- 'Boosting'
log$Model <- 'MLR'
svm$Model <- 'SVM'

#Creating dataset
models_for_graph <- rbind(boosting, log, svm)

#Creating and saving plot
plot <- ggplot(models_for_graph, aes(politics_s3.predimpact, fill = Model)) + geom_density(alpha = 0.4) + 
  scale_fill_manual(values = c("red", "blue", "green")) +
  labs(x = "Probability of Social Impact") +
  theme(axis.title.y = element_blank(), axis.text = element_text(size = 10),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.ticks.y = element_blank(), axis.text.y = element_blank())

save(plot, file = "huffplot.rda")
