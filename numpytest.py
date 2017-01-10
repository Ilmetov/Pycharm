import numpy as np
#a = np.array([0,1,2,3,4,5])
#b = a.reshape(2,3).copy()
#b[1][0] = 77
#print (b)
#print(a*2)
c = np.array ([1,2,np.NAN,3,4])
np.isnan(c)
print(np.mean(c[~np.isnan(c)]))