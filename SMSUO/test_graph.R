setwd("/Users/Dok/PycharmProjects/SMSUO/data")
smsuo = read.csv("one_bkp.csv",header=FALSE, sep=";")
x=smsuo[,c(1)]
y=smsuo[,c(2)]
smsuo$xx <- as.Date(x, "%d.%m.%y")
smsuo$weekday <- weekdays(smsuo$xx)
smsuo$month <- format(smsuo$xx, "%m")
smsuo$daym <- format(smsuo$xx, "%d")
smsuo$weeknum <- (as.numeric(smsuo$daym) %/% 7) + 1
smsuo$weekcount <- (as.numeric(smsuo$daym) %% 7)
smsuo$weekyearnum <- (as.numeric(format(smsuo$xx+3,"%U")))
#удаляем из временного ряда декабрь (т.к. в 2014 он был далек от стандарта)
smsuo.sub  <- subset(smsuo, month != "12")
#plot(xx,y, type="l")
#lines(xx, y, col="blue")
#plot(xx$day, y)
library(TTR)
library(zoo)
library(ggplot2)
#av <- SMA(y, n=3)
smsuo.sub$av_e <- EMA(smsuo.sub$V2,n=5)

qplot(smsuo.sub$daym, smsuo.sub$av_e, group = smsuo.sub$month, data = smsuo.sub, colour = as.factor(smsuo.sub$month), geom = "line")
#по всей видимости недельные циклы здесь все-таки не имеют места быть - пробуем забацать месячные
split_dt <- as.Date("01.12.14","%d.%m.%y")

training <- subset(smsuo.sub, xx < split_dt)
testing <- subset(smsuo.sub, xx >= split_dt)

#разобраться с ошибкой по несоответствию размерности!
fit = glm(av_e ~ daym + weekday , data = training)
#new.df <- data.frame(av_e)
testing$res <- predict(fit, testing)

qplot(testing$daym, res, group = testing$month, data = testing, colour = as.factor(testing$month), geom = "line")