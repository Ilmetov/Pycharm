from pandas import read_csv, DataFrame
import pandas as pd
from sklearn.linear_model import LinearRegression, LogisticRegression
from sklearn.svm import SVR
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import r2_score, roc_auc_score, roc_curve,precision_recall_curve
from sklearn.cross_validation import train_test_split
import matplotlib.pyplot as plt
from sklearn.feature_selection import RFE

learn = read_csv('full_learn_dataset.csv',';',low_memory=False, header =0, )
learn = learn.fillna(0)
fraud = {'fraud': 1, 'good': 0}
flag = {1: True, 0: False}

learn['type'] = learn['type'].replace(fraud)
learn['BK_PIN_FLAG'] = learn['BK_PIN_FLAG'].replace(flag)
learn['STORNO_APPROVE_FLAG'] = learn['STORNO_APPROVE_FLAG'].replace(flag)
learn['MAIN_OPERATION'] = learn['MAIN_OPERATION'].replace(flag)

trg = learn['type']
trn = learn.drop(['type','id','evt_type','FLAG_ID_STORNO_APPROVE','FLAG_BK_PIN'], axis=1)

Xtrn, Xtest, Ytrn, Ytest = train_test_split(trn, trg, test_size=0.3)

#a = pd.DataFrame(trn)
#b = pd.DataFrame(trg)
#a.to_csv("trn.csv",sep=";",encoding="UTF-8")
#b.to_csv("trg.csv",sep=";",encoding="UTF-8")

model = LogisticRegression()
    #LogisticRegression() # логистическая регрессия
    #RandomForestRegressor(n_estimators=100, max_features ='sqrt'), # случайный лес
	#SVR(kernel='linear'), # метод опорных векторов с линейным ядром
#создаем временные структуры
TestModels = DataFrame()
tmp = {}
#для каждой модели из списка
#for model in models:
	#получаем имя модели
#	m = str(model)
    #tmp['Model'] = m[:m.index('(')]
	#для каждого столбцам результирующего набора
	#for i in range(Ytrn.shape[1]):
	#обучаем модель
model.fit(Xtrn, Ytrn)
	#вычисляем коэффициент детерминации
#tt1 = r2_score(Ytest, model.predict(Xtest))

rfe = RFE(model, 3)
rfe = rfe.fit(Xtrn, Ytrn)
# summarize the selection of the attributes
#print(rfe.support_)
#print(rfe.ranking_)

roc = roc_auc_score(Ytest, model.predict(Xtest))
roc_c = roc_curve(Ytest, model.predict(Xtest))
p_r = precision_recall_curve(Ytest, model.predict(Xtest))


fpr, tpr, thresholds  = roc_curve(Ytest, model.predict(Xtest))
plt.plot(fpr, tpr, label='ROC fold  (area = %0.2f)' % (roc))

	#записываем данные и итоговый DataFrame
#TestModels = DataFrame.append(model)
#делаем индекс по названию модели
#TestModels.set_index('Model', inplace=True)
#fig, axes = plt.subplots(ncols=1, figsize=(10,4))
#TestModels.tt1.plot(ax=axes[0], kind='bar', title='LogRegr')
#TestModels.R2_Y2.plot(ax=axes[1], kind='bar', color='green', title='R2_Y2')

#learn.head()
