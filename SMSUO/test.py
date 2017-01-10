import numpy as np
import datetime
data = []
labels = []
with open('./data/one.csv') as ifile:
    for line in ifile:
        tokens = line.strip().split(';')
        data.append(datetime.datetime.strptime(tokens[0], '%d.%m.%y'))
        #labels.append(list(int(tk1) for tk1 in tokens[-1]))
        labels.append(int(tokens[-1]))
print(data)
print(labels)