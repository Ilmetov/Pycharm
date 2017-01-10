import numpy as np
import datetime


def load_dataset(dataset_name):
    '''
    data,labels = load_dataset(dataset_name)
    Load a given dataset
    Returns
    -------
    data : numpy ndarray
    labels : list of str
    '''
    data = []
    labels = []
    with open('./data/{0}.csv'.format(dataset_name)) as ifile:
        for line in ifile:
            tokens = line.strip().split(';')
            #data.append(datetime.datetime.strptime(tokens[0], '%d.%m.%y').day) #так получаем день месяца
            data.append(datetime.datetime.strptime(tokens[0], '%d.%m.%y'))
            #labels.append(list(int(tk1) for tk1 in tokens[-1]))
            labels.append(int(tokens[-1]))
    data = np.array(data)
    labels = np.array(labels)
    return data, labels