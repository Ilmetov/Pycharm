setwd("/Users/Dok/PycharmProjects/Antifraud_prot/traminer")
library(RColorBrewer)
library(TraMineR)
library(dplyr)

# generate colors
gen_colors <- function()
{
  qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
  colour_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
  return(colour_vector)
}
col_vector = gen_colors()

### Research: ###

my_seq_test  <- read.csv(file = "AI3.csv", sep =";", header = FALSE, na.strings = "")
my_seq_test2 <- seqdef(my_seq_test, var = 4:length(names(my_seq_test)), missing = "%") # missing = "%" чтобы удалять пропуски в середине как void
my_seq_test3 <- seqdef(my_seq_test2)#, left = "0", gaps = "0", right = "0")

col_vector[which(attr(my_seq_test3, "labels") == "oper")[[1]]] = "#FF0000"
attr(my_seq_test3,"cpal") <- col_vector#[1:35]

# order operation types by count
my_types <- summarise(group_by(my_seq_test,V3),n=n())
my_types <- my_types[order(my_types$n,decreasing = TRUE),]

# break types into parts (get top t types by count)
t = 4
my_subset = which(my_seq_test$V3 %in% my_types[1:t,1])
my_seq_test4 = my_seq_test3[my_subset,]

my_group <- (interaction(my_seq_test$V1[my_subset], my_seq_test$V3[my_subset]))
seqplot(my_seq_test4, type = "Ht", title = "Enthropy", withlegend = FALSE, cols=2, rows = t,group = my_group)
seqplot(my_seq_test4, type = "d", title = "State distribution plot", withlegend = FALSE, group = my_group , cols = 2, rows = t)
seqplot(my_seq_test4, type = "i", title = "Index plot (first sequences)", withlegend = FALSE, tlim = 1:nrow(my_seq_test4), group = my_group , cols = 2, rows = t)
seqplot(my_seq_test4, type = "f", title = "Sequence frequency plot", withlegend = FALSE, pbarw = TRUE, group = my_group , cols = 2, rows = t)
#seqplot(my_seq_test4, type = "ms", title = "Sequence frequency plot", withlegend = FALSE, pbarw = TRUE, group = my_group , cols = 2, rows = t)

## должно быть полезно, но опять какая-то фигня с палитрой: ##

my_pos <- which(names(my_seq_test4) == "V20")
my_offset = 3
my_range <- (my_pos-my_offset):(my_pos+my_offset)
my_seq_test5 <- my_seq_test4[,my_range]

## Computing a distance matrix with OM metric
my_costs <- seqsubm(my_seq_test5, method="TRATE", with.missing = TRUE)
my_om <- seqdist(my_seq_test5, method="OM", sm=my_costs, with.missing = TRUE)
## Plot of the representative sets grouped by sex using the default density criterion
seqrplot(my_seq_test5, group=my_group, dist.matrix=my_om)
## Plot of the representative sets grouped by sex using the "dist" (centrality) criterion
seqrplot(my_seq_test5, group=my_group, criterion="dist", dist.matrix=my_om)

#seqlegend(my_seq_test3, fontsize = 0.5, horiz = TRUE)


### Addendum: ###

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