setwd("/Users/Dok/PycharmProjects/Antifraud_prot/data")
library(TTR)
library(zoo)
library(ggplot2)
library(reshape2)
library(rpart) #библа для дерева решений
library (e1071) #библа для байеса
library(klaR) #библа для байеса
library(randomForest)
library(caret) #библа для кроссвалидации


class_mod = read.csv("split_model.csv",header=TRUE, stringsAsFactors=FALSE, sep=";") #читаем файл
afraud <-as.data.frame(class_mod)

#afraud$PARAM1 [afraud$PARAM1 == 1] <- "yes"
#afraud$PARAM1 [afraud$PARAM1 == 0] <- "no"
afraud$MAIN_OPERATION <- as.logical.factor(afraud$PARAM1)
#afraud$PARAM2 [afraud$PARAM2 == 1] <- "TRUE"
#afraud$PARAM2 [afraud$PARAM2 == 0] <- "FALSE"
afraud$PARAM2 <- as.logical.factor(afraud$PARAM2)
#afraud$PARAM3 [afraud$PARAM3 == 1] <- "TRUE"
#afraud$PARAM3 [afraud$PARAM3 == 0] <- "FALSE"
afraud$PARAM3 <- as.logical.factor(afraud$PARAM3)
#afraud$Label [afraud$Label == "good"] <- "0"
#afraud$Label [afraud$Label == "fraud"] <- "1"
afraud$Label <- as.factor(afraud$Label)


# define training control
train_control <- trainControl(method="boot", number=100)
# train the model
model <- train(Label ~ PARAM1 + PARAM2 + PARAM3, data=afraud, trControl=train_control, method="nb")
# summarize results
print(model)

fit <- randomForest(Label ~ PARAM1 + PARAM2 + PARAM3, data=afraud,ntree=50, norm.votes=FALSE)

# show the results
plot(fit)
text(fit, use.n = TRUE)


#модель Решающее дерево
#fit <- rpart(Label ~ PARAM1 + PARAM3 + PARAM3,
#            method="class", data=afraud, minsplit=2, minbucket=1)
#модель РандомФорест
#fit <-  randomForest(Label ~ PARAM1 + PARAM3 + PARAM3, afraud, ntree=50, norm.votes=FALSE)

printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits
par(mfrow = c(1,2), xpd = NA) # otherwise on some devices the text is clipped



plot(fit, uniform=TRUE, 
     main="Classification Tree for Serega")
text(fit, use.n=TRUE, all=TRUE, cex=.8)

# create attractive postscript plot of tree 



post(fit, file = "/Users/Dok/PycharmProjects/Antifraud_prot/data/tree.ps", 
     title = "Classification Tree for Serega")
# set up a training sample
#train.ind <- sample(1:nrow(afraud), ceiling(nrow(afraud)*2/3), replace=FALSE)

# apply NB classifier
#fit <- NaiveBayes(fraud ~ main_flag + pin_code_flag + client_session_flag + ip_main_flag, data=afraud)

# show the results
#plot(fit)
#text(fit, use.n = TRUE)

# predict on holdout units
#nb.pred <- predict(nb.res, spam[-train.ind,])

# raw accuracy
#confusion.mat <- table(nb.pred$class, spam[-train.ind,"spam"])
#sum(diag(confusion.mat))/sum(confusion.mat)



