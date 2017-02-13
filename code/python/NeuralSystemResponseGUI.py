from Tkinter import *
import matplotlib
matplotlib.use("TkAgg")
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg
from matplotlib.figure import Figure
import PatternGenerator as pg

class Application(Frame):


    def updatePlot(self, e):
        self.a.clear()
        if self.responsePlot:
            x, y = pg.getNeuralResponse(e)
            self.a.plot(x, y)
            self.a.set_title('Neural system response on diferent stimulus')
            self.a.set_xlabel('X(k)')
            self.a.set_ylabel('X(k-1)')
        else:
            data = pg.plotPattern1(e)
            self.a.plot(data)
            self.a.set_ylabel('Neuron (1,1) output.')
            self.a.set_xlabel('n.')
            self.a.set_title('Plot Pattern On e = ' + str(e))
        self.canvas.show()

        # self.a2.clear()
        # data = pg.plotPattern1(e)
        # self.a2.plot(data)
        # self.canvas2.show()

    def changePlot(self):
        self.a.clear()
        if self.responsePlot:
            data = pg.plotPattern1(self.stimulus.get())
            self.a.plot(data)
            self.a.set_ylabel('Neuron (1,1) output.')
            self.a.set_xlabel('n.')
            self.a.set_title('Plot Pattern On e = ' + str(self.stimulus.get()))
            self.responsePlot = False
        else:
            x, y = pg.getNeuralResponse(self.stimulus.get())
            self.a.plot(x, y)
            self.a.set_title('Neural system response on diferent stimulus')
            self.a.set_xlabel('X(k)')
            self.a.set_ylabel('X(k-1)')
            self.responsePlot = True
        self.canvas.show()

    def createWidgets(self):
        self.createQuitButton()
        self.createPrintButton()
        self.createStimulusScale()
        self.createPlot()
        #self.createPlot2()

    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.responsePlot = True
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
        self.stimulus = Scale(self, from_=0.00, to_=2.00, resolution=0.01, orient=HORIZONTAL)
        self.stimulus["command"] = self.updatePlot
        self.stimulus.pack(fill = X)

    def createPlot(self):
        self.f = Figure(figsize=(10, 5), dpi=100)
        self.a = self.f.add_subplot(111)
        x, y = pg.getNeuralResponse(0)
        self.a.plot(x, y)
        self.a.set_title('Neural system response on diferent stimulus')
        self.a.set_xlabel('X(k)')
        self.a.set_ylabel('X(k-1)')
        self.canvas = FigureCanvasTkAgg(self.f, self)
        self.canvas.show()
        self.canvas.get_tk_widget().pack(side=BOTTOM, fill=BOTH, expand=True)
        self.toolbar = NavigationToolbar2TkAgg(self.canvas, self)
        self.toolbar.update()
        self.canvas._tkcanvas.pack(side=TOP, fill=BOTH, expand=True)

    # def createPlot2(self):
    #     self.f2 = Figure(figsize=(5, 5), dpi=100)
    #     self.a2 = self.f2.add_subplot(111)
    #     data = pg.plotPattern1(0)
    #     self.a2.plot(data)
    #     self.canvas2 = FigureCanvasTkAgg(self.f2, self)
    #     self.canvas2.show()
    #     self.canvas2.get_tk_widget().pack(side=BOTTOM, fill=BOTH, expand=True)
    #     self.toolbar2 = NavigationToolbar2TkAgg(self.canvas2, self)
    #     self.toolbar2.update()
    #     self.canvas2._tkcanvas.pack(side=TOP, fill=BOTH, expand=True)


root = Tk()
app = Application(master=root)
app.mainloop()
root.destroy()