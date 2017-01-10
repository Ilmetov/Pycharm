from __future__ import print_function
import numpy as np
from load import load_dataset
import datetime


# Import sklearn implementation of KNN
from sklearn.neighbors import KNeighborsClassifier

features, labels = load_dataset('one')
print (features)
print(labels)