"""Pattern Generator Code."""

import numpy as np
import matplotlib.pyplot as plt

#distribution vector function
def vDis(e,vi):
    m = vi.size
    vo = np.full((1,m), e, dtype=float)
    return vo

#distribution matrix function
def mDis(e, mi):
    m, n = mi.shape
    mo = np.full((m,n), e, dtype=float)
    return mo

#gauss funcion
def gauss(x, cm, l):
    y = np.exp((-(x-cm)**2) /l)
    return y

#gaussian function for all the elements of the matrix
def EVFGauss(mi, cm, l):
    m, n = mi.shape
    mo = np.zeros((m, n), dtype=float)

    for i in xrange(0, m):
        for j in xrange(0, n):
            mo[i, j] = gauss(mi[i, j], cm, l)

    return mo

#Chaotic gaussian neuron
def nGauss(sa):
    l = 0.15
    cm = 0.25
    sa = gauss(sa, cm, l)
    return sa

#Artificial Neural System Single Output
def aNSSOutput(e, sa):
    w1 = np.array(([0.1, 0.2, 0.3],[0.6, 0.2, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    w2 = np.array(([0.1, 0.2, 0.3], [0.6, 0.9, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    A = np.array(([0.1, 0.1, 0.1],[0.10, 1, 0.1], [0.1, 0, 0.1]), dtype=float)

    mAux = np.zeros((3,3), dtype=float)

    E = mDis(e, mAux)
    m1 = w1 - E

    sa = nGauss(sa)
    SA = mDis(sa, mAux)
    m2 = w2 - SA

    mAux = m1 + m2
    R = EVFGauss(mAux, 0.0, 0.15)

    mTemp = R * A

    s1 = np.sum(mTemp)
    s2 = np.sum(R)
    y = s1/(s2 + 0.00000052)

    return y, sa

#Artificial Neural System Matrix Output
def aNSMOutput(e, sa, weight1, weight2, cn):
    w1 = np.array(([0.5, 0.2, 0.3],[0.6, 0.2, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    w2 = np.array(([0.3, 0.2, 0.3], [0.6, 0.5, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    w1[cn[0]][cn[1]] = weight1
    w2[cn[0]][cn[1]] = weight2
    #w1 = np.array(([0.1, 0.6, 0.3], [0.2, 0.3, 0.4], [0.9, 0.1, 0.5]), dtype=float)
    #w2 = np.array(([0.5, 0.7, 0.6], [0.6, 0.4, 0.6], [0.1, 0.2, 0.3]), dtype=float)
    # w1 = np.array(([0.19, 0.12, 0.03],[0.56, 0.25, 0.45], [0.67, 0.38, 0.99]), dtype=float)
    # w2 = np.array(([0.1, 0.9, 0.8], [0.6, 0.3, 0.4], [0.74, 0.48, 0.79]), dtype=float)
    A = np.array(([180, 1, 1],[1, 1, 1], [1, 180, 180]), dtype=float)

    mAux = np.zeros((3, 3), dtype=float)

    E = mDis(e, mAux)
    m1 = w1 - E

    sa = nGauss(sa)
    SA = mDis(sa, mAux)
    m2 = w2 - SA

    mAux = m1 + m2
    R = EVFGauss(mAux, 0.0, 0.15)

    mo = R * A

    return mo, sa

#plots a group of 500 samples of the Neural System Output for a given stimulus(e)
def plotPattern1(e, cn, w1, w2):
    sa = 1

    data = []
    for i in xrange(1, 251):
        mo, sa = aNSMOutput(e, sa, w1, w2, cn)
        data.append(mo[cn[0]][cn[1]])

    print data[40:44], w1, w2
    return data

def getData(e, cn, w1, w2):
    sa = 1

    data = []
    for i in xrange(1, 251):
        mo, sa = aNSMOutput(e, sa, w1, w2, cn)
        data.append(mo[cn[0]][cn[1]])


def frange(start, stop, step):
        x = start
        while x < stop:
            yield x
            x += step

#plots a group of 500 samples of the Neural System Output for a given stimulus(e)
def plotPattern(e, figure, subplot, color):
    sa = 0

    data = []
    for i in xrange(1, 251):
        mo, sa = aNSMOutput(e, sa)
        data.append(mo[1][1])

    plt.figure(figure)
    plt.subplot(subplot)
    plt.plot(data, color)
    plt.ylabel('Neuron (1,1) output.')
    plt.xlabel('n.')
    plt.title('Plot Pattern On e = ' + str(e))
    return data

#shows the response of the neural system on different stimulus
def dynamicNeuralSystemPlot():
    e = 0
    data = plotPattern(e, 1, 221, 'b')
    xk = data[50:250]
    xkmo = data[49:249]
    plt.figure(2)
    plt.plot(xk, xkmo, 'b')
    print data

    e = 0.7
    data = plotPattern(e, 1, 222, 'g')
    xk = data[50:250]
    xkmo = data[49:249]
    plt.figure(2)
    plt.plot(xk, xkmo, 'g')
    print data

    e = 0.9
    data = plotPattern(e, 1, 223, 'r')
    xk = data[50:250]
    xkmo = data[49:249]
    plt.figure(2)
    plt.plot(xk, xkmo, 'r')
    print data

    e = 1
    data = plotPattern(e, 1, 224, 'k')
    xk = data[50:250]
    xkmo = data[49:249]
    plt.figure(2)
    plt.plot(xk, xkmo, 'k')
    print data
    plt.title('Neural system response on diferent stimulus')
    plt.xlabel('X(k)')
    plt.ylabel('X(k-1)')

def getNeuralResponse(e, cn, w1, w2):
    data = plotPattern1(e, cn, w1, w2)
    xk = data[50:250]
    xkmo = data[49:249]
    return xk, xkmo, data

