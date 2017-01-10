__author__ = 'Dok'
import scipy as sp
data = sp.genfromtxt("web_traffic.tsv", delimiter="\t")
#print(data[:10])
#print(data.shape)
x=data[:,0]
y=data[:,1]
x=x[~sp.isnan(y)]
y=y[~sp.isnan(y)]

def error(f,x,y):
    return sp.sum((f(x)-y)**2)



fp1, residuals, rank, sv, rcond = sp.polyfit(x,y,1,full=True)
print("Параметры модели: %s" % fp1)
print(residuals)

f1 = sp.poly1d(fp1)
print(error(f1,x,y))

f2p = sp.polyfit(x,y,2)
print(f2p)
f2 = sp.poly1d(f2p)
print(error(f2,x,y))

f3p = sp.polyfit(x,y,4)
print(f3p)
f3 = sp.poly1d(f3p)
print(error(f3,x,y))

inflection = 3.5*7*24
xa=x[:inflection]
ya=y[:inflection]
xb=x[inflection:]
yb=y[inflection:]

fa = sp.poly1d(sp.polyfit(xa,ya,3))
fb = sp.poly1d(sp.polyfit(xb,yb,2))

fa_error = error(fa, xa, ya)
fb_error = error(fb, xb, yb)

print ("Error inflection: %f " % (fa_error + fb_error))

import matplotlib.pyplot as plt
plt.figure(num=None, figsize=(8, 6))
plt.clf()
plt.scatter(x, y, s=10)
plt.title("Web traffic over the last month")
plt.xlabel("Time")
plt.ylabel("Hits/hour")
plt.xticks(
    [w * 7 * 24 for w in range(10)], ['week %i' % w for w in range(10)])


plt.scatter(x, y, s=10)
plt.title("Web traffic over the last month")
plt.xlabel("Time")
plt.ylabel("Hits/hour")
plt.xticks([w*7*24 for w in range(10)]
,['week %i' % w for w in range(10)])
plt.autoscale(tight=True)
plt.grid(True, linestyle='-', color='0.75')

fx=sp.linspace(0,x[-1],1000)
fx2=sp.linspace(inflection-300, x[-1],1000)
#plt.plot(fx,f1(fx), linewidth=4)
#plt.plot(fx,f2(fx), linewidth=4)
#plt.plot(fx,f3(fx), linewidth=4)
plt.plot(fx,fa(fx),linewidth=4)
plt.plot(fx2,fb(fx2),linewidth=4)
#plt.legend(["d=%i" % f1.order,"d=%i" % f2.order,"d=%i" % f3.order], loc="upper left")

plt.show()