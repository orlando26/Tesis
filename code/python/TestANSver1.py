"""Test program."""

import numpy as np

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
    w1 = np.array(([0.1, 0.2, 0.3],[0.6, 0.5, 0.4], [0.7, 0.8, 0.8]), dtype=float)
    w2 = np.array(([0, 0.0182, 0],[0.6814, 0, 0.2645], [0, 0.9984, 0]), dtype=float)
    a = np.array(([0, 0, 1],[1, 0, 1], [0, 1, 0]), dtype=float)

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

    return y


