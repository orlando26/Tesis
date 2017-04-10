# Clase modelo para una red neuronal
import numpy as np

s = np.array((
    [74, 77, 180],
    [76, 80, 180],
    [78, 82, 180],
    [81, 85, 180],
    [84, 86, 180],
    [88, 87, 180],
    [91, 89, 180],
    [91, 90, 180],
    [92, 89, 180],
    [96, 91, 180],
    [101, 97, 180]
), dtype=float)

m = np.array((
    [0],
    [15],
    [20],
    [25],
    [40],
    [48],
    [60],
    [68],
    [80],
    [86],
    [90]
), dtype=float)


class NeuralNetwork(object):
    def __init__(self):
        # Se definen las neuronas de cada capa
        self.inputLayerSize = 3
        self.outputLayerSize = 1
        self.hiddenLayerSize = 5

        # Se definen valores random para los pesos iniciales
        self.w1 = np.random.rand(self.inputLayerSize, self.hiddenLayerSize)
        self.w2 = np.random.rand(self.hiddenLayerSize, self.outputLayerSize)

    def normalization(self, x, min, max):
        normalized = (x - min)/((max - min) + 0.000001)
        return normalized

    def desnormalization(self, x, min, max):
        desnormalized = x*max + min*(1 - x)
        return desnormalized

    def forward(self, s):
        # Normalizacion de los valores de los sensores
        s = s / 180
        # Se propagan las entradas por la red hasta las salidas
        self.z2 = np.dot(s, self.w1)
        self.a = self.sigmoid(self.z2)
        self.z3 = np.dot(self.a, self.w2)
        self.mHat = self.sigmoid(self.z3)
        self.mHat *= 90;
        return self.mHat

    def sigmoid(self, z):
        # Funcion de activacion sigmoid
        return 1 / (1 + np.exp(-z))

    def sigmoidPrime(self, z):
        # Derivada de la funcion sigmoid
        return np.exp(-z) / ((1 + np.exp(-z)) ** 2)

    def costFunction(self, s, m):
        # Calcular el error para los valores de los sensores y los
        # motores dados, se usan los pesos guardados en la clase.
        self.mHat = self.forward(s)
        e = 0.5 * sum((m - self.mHat) ** 2)
        return e

    def costFunctionPrime(self, s, m):
        # Calcula la derivada con respecto a w1 y w2
        self.mHat = self.forward(s)

        delta3 = np.multiply(-(m - self.mHat), self.sigmoidPrime(self.z3))
        djdw2 = np.dot(self.a.T, delta3)

        delta2 = np.dot(delta3, self.w2.T) * self.sigmoidPrime(self.z2)
        djdw1 = np.dot(s.T, delta2)
        return djdw1, djdw2

    # funciones para interactuar con otras clases:
    def getParams(self):
        # obtiene w1 y w2 como un vector:
        params = np.concatenate((self.w1.ravel(), self.w2.ravel()))
        return params

    def setParams(self, params):
        # asigna w1 y w2
        W1_start = 0
        W1_end = self.hiddenLayerSize * self.inputLayerSize
        self.w1 = np.reshape(params[W1_start:W1_end], (self.inputLayerSize, self.hiddenLayerSize))
        W2_end = W1_end + self.hiddenLayerSize * self.outputLayerSize
        self.w2 = np.reshape(params[W1_end:W2_end], (self.hiddenLayerSize, self.outputLayerSize))

    def computeGradients(self, s, m):
        dJdw1, dJdw2 = self.costFunctionPrime(s, m)
        return np.concatenate((dJdw1.ravel(), dJdw2.ravel()))

    def computeNumericalGradient(N, s, m):
        paramsInitial = N.getParams()
        numgrad = np.zeros(paramsInitial.shape)
        perturb = np.zeros(paramsInitial.shape)
        e = 1e-4

        for p in range(len(paramsInitial)):
            # Se asigna el vector de perturbacion
            perturb[p] = e
            N.setParams(paramsInitial + perturb)
            loss2 = N.costFunction(s, m)

            N.setParams(paramsInitial - perturb)
            loss1 = N.costFunction(s, m)

            # Calculo del gradiente numerico
            numgrad[p] = (loss2 - loss1) / (2 * e)

            # se regresa el valor que cambiamos a 0:
            perturb[p] = 0

        # Regresamos los parametros a su valor original:
        N.setParams(paramsInitial)

        return numgrad


