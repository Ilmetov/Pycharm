import pandas as pd
import numpy as np
import math
from sklearn import metrics

data = pd.read_csv('full_learn_dataset.csv',header=None)

data.head()

y = data[0]
x = pd.DataFrame()
x[1] = data[1]
x[2] = data[2]

def find_w_grad(x, y, C=10, k = 0.1):
    evcl = 10
    cnt = 0
    w1 = 0
    w2 = 0
    l = y.count()
    while evcl > 0.00001 and cnt < 10000 :
        s1 = 0
        s2 = 0
        v1 = w1
        v2 = w2
        for i in range(l):
            a = w1*x[1][i] + w2*x[2][i]
            a = 1 + math.exp(-1*y[i]*a)
            a = 1 - 1/a
            s1 = s1 + y[i]*x[1][i]*a
            s2 = s2 + y[i]*x[2][i]*a
        w1 = w1 + k/l*s1 - k*C*w1
        w2 = w2 + k/l*s2 - k*C*w2
        evcl = math.sqrt((w1-v1)**2 + (w2-v2)**2)
        cnt = cnt + 1
        #print cnt, C, w1, w2
    return (w1,w2)

# w/o regularization
(w1,w2) = find_w_grad(x,y,C=0)
y_pred_noreg = w1*x[1] + w2*x[2]
#estimate AUC-ROC w/o regularization (C=0)
roc_score_noreg = metrics.roc_auc_score(y,y_pred_noreg)
round(roc_score_noreg,3)

# with regularization
(w1,w2) = find_w_grad(x,y,C=10)
y_pred_reg = w1*x[1] + w2*x[2]
#estimate AUC-ROC with regularization (C=10.0)
roc_score_reg = metrics.roc_auc_score(y,y_pred_reg)
roc_score_reg
round(roc_score_reg,3)

with open('A8.answ', 'w') as a:
    a.write(str(round(roc_score_noreg,3))+" "+str(round(roc_score_reg,3)))