from Tkinter import *

class Application(Frame):
    def say_hi(self):
        print "hi there, everyone!"

    def createWidgets(self):
        self.createQuitButton()
        self.createPrintButton()
        self.createWeights1()

    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.pack()
        self.createWidgets()

    def createQuitButton(self):
        self.QUIT = Button(self)
        self.QUIT["text"] = "QUIT"
        self.QUIT["fg"] = "red"
        self.QUIT["command"] = self.quit
        self.QUIT.pack({"side": "left"})

    def createPrintButton(self):
        self.hi_there = Button(self)
        self.hi_there["text"] = "Hello",
        self.hi_there["command"] = self.say_hi
        self.hi_there.pack({"side": "left"})

    def createWeights1(self):
        self.w1 = Entry(self)
        self.w1.pack(side=BOTTOM)

root = Tk()
app = Application(master=root)
app.mainloop()
root.destroy()