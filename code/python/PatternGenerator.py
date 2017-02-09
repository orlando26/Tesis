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
    l = 0.14
    cm = 0.25
    sa = gauss(sa, cm, l)
    return sa

#Artificial Neural System Single Output
def aNSSOutput(e, sa):
    w1 = np.array(([0.1, 0.2, 0.3],[0.6, 0.5, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    w2 = np.array(([0.1, 0.2, 0.3], [0.6, 0.5, 0.4], [0.7, 0.8, 0.9]), dtype=float)
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
def aNSMOutput(e, sa):
    w1 = np.array(([0.1, 0.2, 0.3],[0.6, 0.5, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    w2 = np.array(([0.1, 0.2, 0.3], [0.6, 0.5, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    A = np.array(([0, 0, 0],[0, 1, 0], [0, 0, 0]), dtype=float)

    mAux = np.zeros((3, 3), dtype=float)

    E = mDis(e, mAux)
    m1 = E - w1

    sa = nGauss(sa)
    SA = mDis(sa, mAux)
    m2 = SA - w2

    mAux = m1 + m2
    R = EVFGauss(mAux, 0.0, 0.15)

    mo = R * A

    return mo, sa

#plots a group of 500 samples of the Neural System Output for a given stimulus(e)
def plotPattern(e):
    sa = 0

    data = []
    for i in xrange(1, 500):
        mo, sa = aNSMOutput(e, sa)
        data.append(mo[1][1])

    plt.figure()
    plt.subplot()
    plt.plot(data)
    plt.ylabel('Neuron (1,1) output.')
    plt.xlabel('n.')
    plt.title('Plot Pattern On e = ' + str(e))
    return data


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

