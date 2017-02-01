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