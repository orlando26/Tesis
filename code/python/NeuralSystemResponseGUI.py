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

    def changeToNeuronOne(self):
        self.currentNeuron = 0
        self.updatePlot(self.stimulus.get())

    def changeToNeuronTwo(self):
        self.currentNeuron = 1
        self.updatePlot(self.stimulus.get())

    def changeToNeuronThree(self):
        self.currentNeuron = 2
        self.updatePlot(self.stimulus.get())

    def updatePlot(self, e):
        self.a.clear()
        if self.responsePlot:
            x, y = pg.getNeuralResponse(e, self.currentNeuron)
            self.a.plot(x, y)
            self.a.set_title('Neural system response on diferent stimulus on neuron (%d,%d)' % (self.currentNeuron, self.currentNeuron))
            self.a.set_xlabel('X(k)')
            self.a.set_ylabel('X(k-1)')
        else:
            data = pg.plotPattern1(e, self.currentNeuron)
            self.a.plot(data)
            self.a.set_ylabel('Neuron (%d,%d) output.' % (self.currentNeuron, self.currentNeuron))
            self.a.set_xlabel('n.')
            self.a.set_title('Plot Pattern On e = ' + str(e))
        self.canvas.show()

    def changePlot(self):
        self.a.clear()
        if self.responsePlot:
            data = pg.plotPattern1(self.stimulus.get(), self.currentNeuron)
            self.a.plot(data)
            self.a.set_ylabel('Neuron (%d,%d) output.' % (self.currentNeuron, self.currentNeuron))
            self.a.set_xlabel('n.')
            self.a.set_title('Plot Pattern On e = ' + str(self.stimulus.get()))
            self.responsePlot = False
        else:
            x, y = pg.getNeuralResponse(self.stimulus.get(), self.currentNeuron)
            self.a.plot(x, y)
            self.a.set_title('Neural system response on diferent stimulus on neuron (%d,%d)' % (self.currentNeuron, self.currentNeuron))
            self.a.set_xlabel('X(k)')
            self.a.set_ylabel('X(k-1)')
            self.responsePlot = True
        self.canvas.show()

    def createWidgets(self):
        self.createQuitButton()
        self.createPrintButton()
        self.createNeuronBtns()
        self.createStimulusScale()
        self.createPlot()

    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.responsePlot = True
        self.currentNeuron = 1
        self.pack(expand=True)
        self.createWidgets()

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
        self.stimulus = Scale(self, from_=0.00, to_=1.00, resolution=0.01, orient=HORIZONTAL)
        self.stimulus["command"] = self.updatePlot
        self.stimulus.pack(fill = X)

    def createPlot(self):
        self.f = Figure(figsize=(10, 5), dpi=100)
        self.a = self.f.add_subplot(111)
        x, y = pg.getNeuralResponse(0, self.currentNeuron)
        self.a.plot(x, y)
        self.a.set_title('Neural system response on diferent stimulus on neuron (%d,%d)' % (self.currentNeuron, self.currentNeuron))
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
        self.n1["text"] = "N(0,0)",
        self.n1["command"] = self.changeToNeuronOne
        self.n1.pack(side=TOP)

        self.n2 = Button(self)
        self.n2["text"] = "N(1,1)",
        self.n2["command"] = self.changeToNeuronTwo
        self.n2.pack(side=TOP)

        self.n3 = Button(self)
        self.n3["text"] = "N(2,2)",
        self.n3["command"] = self.changeToNeuronThree
        self.n3.pack(side=TOP)



root = Tk()
app = Application(master=root)
app.mainloop()
root.destroy()