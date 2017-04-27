"""Neural System Response GUI Aplication"""
# Small GUI to see the Neural System response
# of three diferent neurons of the ouput matrix in real-time.
# it uses the functions from PatternGenerator.py.

from Tkinter import *
import matplotlib
matplotlib.use("TkAgg")
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg
from matplotlib.figure import Figure
import PatternGenerator as pg

class Application(Frame):

    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.responsePlot = True
        self.currentNeuron = [1, 1]
        self.pack(expand=True)
        self.createWidgets()
        self.v1 = 0
        self.v2 = 0
        self.v3 = 0
        self.v4 = 0


     #********* Functions ***********#
    def getValues(self):
        self.updatePlot(self.stimulus.get())

    def changeToNeuronOne(self):
        self.currentNeuron = [0, 0]
        self.updatePlot(self.stimulus.get())

    def changeToNeuronTwo(self):
        self.currentNeuron = [1, 1]
        self.updatePlot(self.stimulus.get())

    def changeToNeuronThree(self):
        self.currentNeuron = [2  , 2]
        self.updatePlot(self.stimulus.get())

    def updatePlot(self, e):
        self.a.clear()
        if self.responsePlot:
            x, y, data = pg.getNeuralResponse(e, self.currentNeuron, self.w1.get(), self.w2.get())
            self.v1 = round(data[40], 3)
            self.v2 = round(data[41], 3)
            self.v3 = round(data[42], 3)
            self.v4 = round(data[43], 3)
            self.vl1["text"] = self.v1
            self.vl2["text"] = self.v2
            self.vl3["text"] = self.v3
            self.vl4["text"] = self.v4
            self.a.plot(x, y)
            self.a.set_title('Neural system response on diferent stimulus on neuron (%d,%d)' % (self.currentNeuron[0], self.currentNeuron[1]))
            self.a.set_xlabel('X(k)')
            self.a.set_ylabel('X(k-1)')
        else:
            data = pg.plotPattern1(e, self.currentNeuron, self.w1.get(), self.w2.get())
            self.v1 = round(data[40], 2)
            self.v2 = round(data[41], 2)
            self.v3 = round(data[42], 2)
            self.v4 = round(data[43], 2)
            self.a.plot(data)
            self.a.set_ylabel('Neuron (%d,%d) output.' % (self.currentNeuron[0], self.currentNeuron[1]))
            self.a.set_xlabel('n.')
            self.a.set_title('Plot Pattern On e = ' + str(e))
        self.canvas.show()

    def changePlot(self):
        self.a.clear()
        if self.responsePlot:
            data = pg.plotPattern1(self.stimulus.get(), self.currentNeuron, self.w1.get(), self.w2.get())
            self.v1 = round(data[40], 2)
            self.v2 = round(data[41], 2)
            self.v3 = round(data[42], 2)
            self.v4 = round(data[43], 2)
            self.a.plot(data)
            self.a.set_ylabel('Neuron (%d,%d) output.' % (self.currentNeuron[0], self.currentNeuron[1]))
            self.a.set_xlabel('n.')
            self.a.set_title('Plot Pattern On e = ' + str(self.stimulus.get()))
            self.responsePlot = False
        else:
            x, y, data = pg.getNeuralResponse(self.stimulus.get(), self.currentNeuron, self.w1.get(), self.w2.get())
            self.v1 = round(data[40], 2)
            self.v2 = round(data[41], 2)
            self.v3 = round(data[42], 2)
            self.v4 = round(data[43], 2)
            self.a.plot(x, y)
            self.a.set_title('Neural system response on diferent stimulus on neuron (%d,%d)' % (self.currentNeuron[0], self.currentNeuron[1]))
            self.a.set_xlabel('X(k)')
            self.a.set_ylabel('X(k-1)')
            self.responsePlot = True
        self.canvas.show()

    def createWidgets(self):
        self.createQuitButton()
        self.createPrintButton()
        self.createNeuronBtns()
        self.createSpinBox()
        self.createWightsButton()
        self.createStimulusScale()
        self.createPlot()
        self.createValues()

    #********** Widgets ***********#
    def createQuitButton(self):
        self.QUIT = Button(self)
        self.QUIT["text"] = "QUIT"
        self.QUIT["fg"] = "red"
        self.QUIT["command"] = self.quit
        self.QUIT.pack()

    def createPrintButton(self):
        self.hi_there = Button(self)
        self.hi_there["text"] = "CHANGE_PLOT",
        self.hi_there["command"] = self.changePlot
        self.hi_there.pack()

    def createStimulusScale(self):
        self.stimulus = Scale(self, from_=0.00, to_=1.00, resolution=0.01, orient=HORIZONTAL, label="Stimulus(e):")
        self.stimulus["command"] = self.updatePlot
        self.stimulus.pack(fill = X)

    def createPlot(self):
        self.f = Figure(figsize=(10, 5), dpi=100)
        self.a = self.f.add_subplot(111)
        x, y, data = pg.getNeuralResponse(0, self.currentNeuron, self.w1.get(), self.w2.get())
        self.v1 = round(data[40], 3)
        self.v2 = round(data[41], 3)
        self.v3 = round(data[42], 3)
        self.v4 = round(data[43], 3)
        self.a.plot(x, y)
        self.a.set_title('Neural system response on diferent stimulus on neuron (%d,%d)' % (self.currentNeuron[0], self.currentNeuron[1]))
        self.a.set_xlabel('X(k)')
        self.a.set_ylabel('X(k-1)')
        self.canvas = FigureCanvasTkAgg(self.f, self)
        self.canvas.show()
        self.canvas.get_tk_widget().pack(side=BOTTOM, fill=BOTH, expand=True)
        self.toolbar = NavigationToolbar2TkAgg(self.canvas, self)
        self.toolbar.update()
        self.canvas._tkcanvas.pack(side=TOP, fill=BOTH, expand=True)

    def createNeuronBtns(self):
        self.n1 = Button(self)
        self.n1["text"] = "0 - 180",
        self.n1["command"] = self.changeToNeuronOne
        self.n1.pack(side=TOP)

        self.n2 = Button(self)
        self.n2["text"] = "0 - 1",
        self.n2["command"] = self.changeToNeuronTwo
        self.n2.pack(side=TOP)
        label = Label(self, text="")
        label.pack(side=TOP, pady=5)

    def createWightsButton(self):
        self.wButton = Button(self)
        self.wButton["text"] = "OK"
        self.wButton["command"] = self.getValues
        self.wButton.pack()

    def createSpinBox(self):
        w = Label(self, text="W1")
        w.pack()
        self.w1 = Spinbox(self, from_=0, to_=1, increment=0.1, width=5)
        self.w1.pack(side=TOP)
        w = Label(self, text="W2")
        w.pack()
        self.w2 = Spinbox(self, from_=0, to_=1, increment=0.1, width=5)
        self.w2.pack(side=TOP)

    def createValues(self):
        self.vl1 = Label(self, text=round(self.v1, 2))
        self.vl1.pack()
        self.vl2 = Label(self, text=round(self.v2, 2))
        self.vl2.pack()
        self.vl3 = Label(self, text=round(self.v3, 2))
        self.vl3.pack()
        self.vl4 = Label(self, text=round(self.v4, 2))
        self.vl4.pack()


root = Tk()
app = Application(master=root)
app.mainloop()
root.destroy()