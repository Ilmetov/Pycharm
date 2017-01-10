setwd("/Users/Dok/PycharmProjects/Antifraud_prot/traminer")
library(RColorBrewer)
library(TraMineR)

my_seq_test <- read.csv(file = "traminer_fraud.csv", sep =";", header = FALSE, na.strings = "")

my_seq_test <- my_seq_test[ -c(33) ]
#my_seq_test <- subset(my_seq_test, V2 == "Выдача н/д средств со вклада по л/с другого ВСП")
my_seq_test2 <- seqdef(my_seq_test, var = 3:length(names(my_seq_test)), missing = "%") # missing = "%" чтобы удалять пропуски в середине как void
my_seq_test3 <- seqdef(my_seq_test2)#, left = "0", gaps = "0", right = "0")

# generate colors
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
#n <- 35
#pie(rep(1,n), col=sample(col_vector, n))
col_vector[which(attr(my_seq_test3, "labels") == "fraud")[[1]]] = "#00FF00"
attr(my_seq_test3,"cpal") <- col_vector#[1:35]

par(mfrow = c(2, 2))
#seqiplot(my_seq_test3, title = "Index plot (first sequences)", withlegend = FALSE, tlim = 1:nrow(my_seq_test3))
#seqdplot(my_seq_test3, title = "State distribution plot", withlegend = FALSE)
#seqfplot(my_seq_test3, title = "Sequence frequency plot", withlegend = FALSE, pbarw = TRUE)
#seqIplot(my_seq_test3, title = "Index plot (first sequences)", withlegend = FALSE)
seqHtplot(my_seq_test3, title = "Index plot (first sequences)", withlegend = FALSE)
#seqmtplot(my_seq_test3, title = "Index plot (first sequences)", withlegend = FALSE)
seqlegend(my_seq_test3, fontsize = 0.5, horiz = TRUE)



# The seqpm() function counts the number of sequences that contain a given 
# subsequence and collects their row index numbers.

seqpm(my_seq_test3,"ac")
my_subseq <- seqpm(my_seq_test3, "ac")
my_seq_test3[my_subseq$MIndex, ]

# длина цепочки
seqlength(my_seq_test3)
# кол-во подпоследовательностей
seqsubsn(my_seq_test3)
# переходы
seqdss(my_seq_test3)
# durations
seqdur(my_seq_test3)


# статистика пребывания в статусах
# The seqistatd() function returns for each sequence the time spent in the different states.
my_seq_statd <- seqistatd(my_seq_test3)
my_seq_statd
apply(my_seq_statd, 2, mean)

# энтропия цепочки (мера вариативности статусов(состояний)), не учивает очередность
my_seq_entropy <- seqient(my_seq_test3, norm = TRUE)
my_seq_entropy
hist(my_seq_entropy, col = "cyan", main = NULL, xlab = "Entropy")
my_seq_test3[my_seq_entropy == max(my_seq_entropy), ]

#turbulence
seqST(my_seq_test3)
seqST(seqdss(my_seq_test3))

# Longest Common Prefix (LCP) distances
seqLLCP(my_seq_test3[1, ], my_seq_test3[2, ])
seqdist(my_seq_test3, method = "LCP")

# LCS - longest common subsequence metric
# x: S-U-S-M-S-U
# y: U-S-SC-MC
# z: S-U-M-S-SC-UC-MC
# seqLLCS(x, y) = 2 (U-S)
# seqLLCS(x, z) = 4 (S-U-M-S)
# seqdist() - LCS metric. 
# LCS distances with internal gaps
seqdist(my_seq_test3, method = "LCS", with.miss = TRUE)

# На всяк случай - расчеты стоимостей переходов между последовательностями.
# Generating optimal matching distances
# We generate a substitution cost matrix with constant value of 2
# ccost <- seqsubm(ex3.seq, method = "CONSTANT", cval = 2)
# ccost
# and compute the distances using the matrix and the default indel cost of 1
# ex3.OM <- seqdist(ex3.seq, method = "OM", sm = ccost)
# ex3.OM
# In the next example, we use the substitution cost matrix previously computed for the biofam.seq
# sequence object using the seqsubm() command
# couts <- seqsubm(biofam.seq, method = "TRATE")
# biofam.om <- seqdist(biofam.seq, method = "OM", indel = 3, sm = couts)

# Во, то, что надо:
# Searching for frequent event subsequences
my_subseq <- seqefsub(seqecreate(my_seq_test3),minSupport = 3)
plot(my_subseq[1:15], col = "cyan")
my_subseq

# Во, то, что надо - различия в группах последовательностей:
# 10.4 Identifying discriminant event subsequences
# The function seqecmpgroup() identifies subsequences that discriminate signicantly a group using
# the chi-square test. The subsequences are then ordered by decreasing discriminant power.

cohort <- factor(my_seq_test$num > 5, labels = c("<=5 fraud",">5, non-fraud"))
my_discrcohort <- seqecmpgroup(my_subseq, group = cohort, method = "bonferroni")
my_discrcohort[1:10]

plot(my_discrcohort) #plot(my_discrcohort[1:10])


# 10.5.1 Looking after specific subsequences
# mysubseqstr <- character(2)
# mysubseqstr[1] <- "(Parent)-(Left)-(Left+Marr)"
# mysubseqstr[2] <- "(Parent)-(Left+Marr)"
# mysubseq <- seqefsub(bf.seqestate, strsubseq = mysubseqstr)
# print(mysubseq)
# далее их можно использовать для сравнения различий в seqecmpgroup

# 10.5.3 Selecting event subsequences
# condition <- seqecontain(fsubseq, eventList = c("Parent>Married", "Parent>Left+Marr"))
# fsubseq[condition]