"""Test program."""

import numpy as np
from random import randint

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

def nGauss(sa):
    l = 0.14
    cm = 0.25
    sa = gauss(sa, cm, l)
    return sa

def ANSV1(e, sa):
    w1 = np.array(([0.1, 0.2, 0.3],[0.6, 0.5, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    w2 = np.array(([0.1, 0.2, 0.3], [0.6, 0.5, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    a = np.array(([0.1, 0.1, 0.1],[0.10, 1, 0.1], [0.1, 0, 0.1]), dtype=float)

    mAux = np.zeros((3,3), dtype=float)

    mo = mDis(e, mAux)
    mo1 = w1 - mo

    sa = nGauss(sa)
    mo = mDis(sa, mAux)
    mo2 = w2 - mo

    mAux = mo1 + mo2
    mo = EVFGauss(mAux, 0.0, 0.15)

    mo1 = mo * a

    s1 = np.sum(mo1)
    s2 = np.sum(mo)
    y = s1/(s2 + 0.00000052)

    return y, sa

def ANSV2(e, sa):
    w1 = np.array(([0.1, 0.2, 0.3],[0.6, 0.5, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    w2 = np.array(([0.1, 0.2, 0.3], [0.6, 0.5, 0.4], [0.7, 0.8, 0.9]), dtype=float)
    a = np.array(([0.1, 0.1, 0.1],[0.10, 1, 0.1], [0.1, 0, 0.1]), dtype=float)

    mAux = np.zeros((3, 3), dtype=float)

    mo = mDis(e, mAux)
    mo1 = w1 - mo

    sa = nGauss(sa)
    mo = mDis(sa, mAux)
    mo2 = w2 - mo

    mAux = mo1 + mo2
    mo = EVFGauss(mAux, 0.0, 0.15)

    mo = mo * a

    return mo

def plotBeahvor(e):
    sa = randint(0,1)

    rep = []
    for i in xrange(1, 250):
        y, sa = ANSV1(e, sa)
        rep.append(y)

    return rep

test = plotBeahvor(0)
print(test)


