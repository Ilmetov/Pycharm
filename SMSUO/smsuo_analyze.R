setwd("/Users/Dok/PycharmProjects/SMSUO/data")
library(TTR)
library(zoo)
library(ggplot2)
library(reshape2)
library(kohonen)
library(data.table)
smsuo = read.csv("full_data_op15.csv",header=FALSE, stringsAsFactors=FALSE, sep=";")
#do.call(paste0, smsuo[c(2,3)])
smsuo <- within (smsuo, id <- paste(V2, V3, sep ="_"))
smsuo <- smsuo[-c(1)]
ccnt = ncol(smsuo)
smsuo <- smsuo[,c(ccnt,1:ccnt-1)]
smsuo <- smsuo[-c(2,3)]

smsuo_t <-as.data.frame(t(smsuo))
colnames(smsuo_t) = smsuo$id
smsuo_t <- smsuo_t [-1,]
colnames(smsuo_t)[1] = "dates"
smsuo_t$dates <- as.Date(as.character(smsuo_t$dates),format="%Y%m%d")


ccnt1 = ncol(smsuo_t)

smsuo_melt <- melt(smsuo_t, id.var = c(1), variable.name = 'vsp')
smsuo_melt$month <- format(smsuo_melt$dates, "%m")
smsuo_melt$daym <- format(smsuo_melt$dates, "%d")
smsuo_melt$av_e <- expm1(as.numeric(smsuo_melt$value)) #пока хз как это использовать, но пусть будет
#http://stackoverflow.com/questions/23619855/constructing-moving-average-over-a-categorical-variable-in-r
smsuo_melt$MA <- ave(as.numeric(smsuo_melt$value), smsuo_melt$vsp, FUN = function(x) rollmeanr(x, 10, na.pad = TRUE))
#попробуем освоить data.table
smsuo2 <- data.table(smsuo_melt)
smsuo2[,Mean:= mean(as.numeric(value)),by=c("vsp","month")]
month_mean <- data.table(smsuo2)
month_mean[,dates:=NULL]
month_mean[,value:=NULL]
month_mean[,daym:=NULL]
month_mean[,MA:=NULL]
month_mean[,av_e:=NULL]
#month_mean[,month:=NULL]
month_mean <- unique(month_mean)
smsuo_melt <- as.data.table(smsuo_melt)
smsuo.sub  <- subset(smsuo_melt, vsp == "97970_1005612" | vsp == "97970_1005613" | vsp =="97970_1005623")
#write.csv(smsuo_t, file = "smsuo_t.csv", ,row.names=FALSE, sep = ";")
#vec_clast1 <- setNames(as.character(month_mean$vsp), as.numeric( month_mean$month))
month_men_xyf <- xyf(data = month_mean$Mean, classvec2classmat(month_mean$vsp), grid = somgrid (10,10,"hexagonal"),rlen=100)
#, classvec2classmat(month_mean$vsp)
test_xyf <- xyf(data = as.numeric(smsuo.sub$value), classvec2classmat(smsuo.sub$vsp), grid = somgrid (4,4,"rectangular"),rlen=50)

plot(month_men_xyf)
#
hist(month_mean$Mean, breaks = 20, freq = FALSE, col = "lightblue",
     xlab = "Переменная X",
     ylab = "Плотность вероятности",
     main = "Гистограмма, совмещенная с кривой плотности")
lines(density(month_mean$Mean), col = "red", lwd = 2)

#qplot(smsuo.sub$dates, smsuo.sub$MA ,group = smsuo.sub$vsp, data = smsuo.sub, colour = as.factor(smsuo.sub$vsp), geom = "line")
#PCA, ICA - 
#http://mabrek.github.io/