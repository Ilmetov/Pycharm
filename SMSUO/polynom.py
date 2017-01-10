from __future__ import print_function
import os
from utils import DATA_DIR, CHART_DIR
import scipy as sp
from load import load_dataset
import numpy as np

import datetime
import matplotlib.pyplot as plt
from matplotlib.dates import MONDAY
from matplotlib.dates import MonthLocator, WeekdayLocator, DateFormatter
import matplotlib.dates as mdates


#sp.random.seed(3)  # to reproduce the data later on

# data = sp.genfromtxt("./data/one_bkp.csv", delimiter=";")
# print(data[:10])
# print(data.shape)

x,y = load_dataset("one_bkp")

# all examples will have three classes in this file
colors = ['g', 'k', 'b', 'm', 'r']
linestyles = ['-', '-.', '--', ':', '-']


print("Number of invalid entries:", sp.sum(sp.isnan(y)))
x = x[~sp.isnan(y)]
y = y[~sp.isnan(y)]

print(x)
print(y)


# plot input data
def plot_models(x, y, models, fname, mx=None, ymax=None, xmin=None):
    fig, ax = plt.subplots()
    months = MonthLocator(range(1, 13), bymonthday=1, interval=3)
    monthsFmt = DateFormatter("%b '%y")
    mondays = WeekdayLocator(MONDAY)
    plt.title("Visiting VSP by dates")
    ax.plot_date(x, y, '-')
    ax.xaxis.set_major_locator(months)
    ax.xaxis.set_major_formatter(monthsFmt)
    ax.xaxis.set_minor_locator(mondays)
    ax.autoscale_view()
    #ax.xaxis.grid(False, 'major')
    #ax.xaxis.grid(True, 'minor')
    ax.grid(True)
    xi = mdates.date2num(x)
    if models:
        if mx is None:
            mx = sp.linspace(0, xi[-1], 1000)
        for model, style, color in zip(models, linestyles, colors):
            # print "Model:",model
            # print "Coeffs:",model.coeffs
            xx = np.linspace(xi.min(), xi.max(), 1000)
            dd = mdates.num2date(xx)
            fig, ax = plt.subplots()
            ax.plot_date(dd, model(xx))

        plt.legend(["d=%i" % m.order for m in models], loc="upper left")
    fig.autofmt_xdate()
    plt.autoscale(tight=True)
    plt.ylim(ymin=0)
    if ymax:
        plt.ylim(ymax=ymax)
    if xmin:
        plt.xlim(xmin=xmin)
    plt.grid(True, linestyle='-', color='0.75')
    plt.savefig(fname)
#
# # first look at the data
plot_models(x, y, None, os.path.join(CHART_DIR, "1400_01_01.png"))
#
xi = mdates.date2num(x)
# create and plot models
fp1, res1, rank1, sv1, rcond1 = sp.polyfit(xi, y, 1, full=True)
print("Model parameters of fp1: %s" % fp1)
print("Error of the model of fp1:", res1)
f1 = sp.poly1d(fp1)

fp2, res2, rank2, sv2, rcond2 = sp.polyfit(xi, y, 2, full=True)
print("Model parameters of fp2: %s" % fp2)
print("Error of the model of fp2:", res2)
f2 = sp.poly1d(fp2)
f3 = sp.poly1d(sp.polyfit(xi, y, 3))
f10 = sp.poly1d(sp.polyfit(xi, y, 10))
f100 = sp.poly1d(sp.polyfit(xi, y, 20))


plot_models(x, y, [f1], os.path.join(CHART_DIR, "1400_01_02.png"))
plot_models(x, y, [f1, f2], os.path.join(CHART_DIR, "1400_01_03.png"))
plot_models(
    x, y, [f1, f2, f3, f10, f100], os.path.join(CHART_DIR, "1400_01_04.png"))