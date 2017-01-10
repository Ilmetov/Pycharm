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
library(unbalanced)


afraud = read.csv("split_model.csv",header=TRUE, stringsAsFactors=FALSE, sep=",") #читаем файл
#afraud <-as.data.frame(class_mod)

#afraud$PARAM1 [afraud$PARAM1 == 1] <- "yes"
#afraud$PARAM1 [afraud$PARAM1 == 0] <- "no"
afraud$PARAM1 <- as.logical(afraud$PARAM1)
#afraud$PARAM2 [afraud$PARAM2 == 1] <- "TRUE"
#afraud$PARAM2 [afraud$PARAM2 == 0] <- "FALSE"
afraud$PARAM2 <- as.logical(afraud$PARAM2)
#afraud$PARAM3 [afraud$PARAM3 == 1] <- "TRUE"
#afraud$PARAM3 [afraud$PARAM3 == 0] <- "FALSE"
afraud$PARAM3 <- as.logical(afraud$PARAM3)
afraud$Label [afraud$Label == "FALSE"] <- "0"
afraud$Label [afraud$Label == "TRUE"] <- "1"
#afraud$Label <- as.logical(afraud$Label)

n<-ncol(afraud)
output<-as.factor(afraud$Label) 

input<-afraud[ ,2:4]
data<-ubBalance(X=input1, Y= output)
newData<-cbind(data$X, data$Y)
newData$Label <- newData$`data$Y`
newData$`data$Y` <- NULL

rf <- randomForest(Label ~ ., newData)
predictions <- predict(rf, afraud)

result <- cbind(afraud, predictions)
write.csv(result, file = "result.csv")
