import tkinter as tk
from tkinter import *
from tkinter import messagebox
from tkinter import simpledialog
from tkinter import filedialog
import pyautogui
import time
import sys
import os

pyautogui.PAUSE = 0.5 # time between steps
pyautogui.FAILSAFE = True # determines if the FAILSAFE is active

"""
# This is basically a wrapper class that contains additional
# properties to a Frame which will now (in combination) be called
# a Container. The main property added onto the Frame by this class
# is the 'nameID' which indicates the name of the Frame.
"""
class Container:
    def __init__(self, frame, nameID):
        self.frame = frame
        self.nameID = nameID

"""
# The point of this class is to know when the user wants to loop a series of
# steps. This class contains it's own list to be used just like 'Steps'.
"""
class Loop:
    def __init__(self, iterations):
        self.iterations = iterations # the amount of times to loop
        self.LoopSteps = [] # a list to be used like 'Steps'
    """
    # It loops 'run_steps' by 'iterations' amount of times.
    """
    def RunLoop(self):
        for i in range(self.iterations):
            self.run_steps()
    """
    # It iterates through the 'LoopSteps' list and does each step.
    # Note: The convention used to name this function is completely off
    #       from all the other functions because it is to prevent miscalls
    #       of this functions which should not be called anywhere else aside
    #       from this object's 'RunLoop' function.
    """
    def run_steps(self):
        for step in self.LoopSteps:
            eval(step) # call function using the string

# Colors
BLACK = "#18191A"
PURPLE = "#1F1B28"
LIGHT_PURPLE = "#332940"

# Font and Font Size
Text_Font = ("Arial", 20)

# Initalize window as global variable
my_window = Tk()

# A list of all the containers
Containers = []

# A list of steps the user wants to complete
Steps = []

# A list of loop objects
Loops = []

# Boolean flags
inLoop = False

# Global Integers/Floats
LoopIndex = 0
PlayLoop_currentIndex = 0

# There are special functions that don't really have thier own category
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
"""
# This function will minimize the application
"""
def MinimizeWindow():
    my_window.wm_state('iconic')

"""
# This function will maximize the application
"""
def MaximizeWindow():
    my_window.wm_state('normal')

"""
# This fuction will get the frame from the list of 'Containers'
# based on the 'nameID'.
# Note: It returns a Frame NOT a Container
"""
def GetFrame(frameName):
    for container in Containers:
        if container.nameID == frameName:
            return container.frame

"""
# This function should always be called when saving a file. This function makes
# sure that there aren't two files with the same name.
#
# @param the directory with the name of the file and extention
"""
def RenameSameFiles(at_dir):
    # check if the file exists
    if not os.path.exists(at_dir):
        return # return safe gaurd - file does not exist

    # initialize the static  variable
    if not hasattr(RenameSameFiles, "count"):
        RenameSameFiles.count = 1  # it doesn't exist yet, so initialize it

    # Get the directory and file name (with extention attachted)
    splitStr = at_dir.rsplit('/', 1) # split string
    at_dir = splitStr[0] + "/"
    fileName = splitStr[1]

    # Get the name of the file and the extention name
    splitStr = fileName.rsplit(".",1)
    fileName=splitStr[0]
    extentionName = "."+splitStr[1]

    # Rename the file
    new_dest =fileName + str(RenameSameFiles.count) + extentionName
    src = at_dir+fileName+extentionName
    new_dest = at_dir+new_dest
    os.rename(src,new_dest)

    # Increase counter
    RenameSameFiles.count += 1
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

# Functions only for UI purposes, but they don't do anything
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
def LoopMoveTo(x,y):
    pass # this function is just for UI purposes
def LoopClick(button):
    pass # this function is just for UI purposes
def LoopPress(btn):
    pass # this function is just for UI purposes
def LoopType(string):
    pass # this function is just for UI purposes
def LoopHotkey(string):
    pass # this function is just for UI purpose
def LoopScreenshot(int1,int2,int3,int4):
    pass # this function is just for UI purposes
def EndLoop():
    pass # does nothing aside from indicating we ended loop
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


# Disregard these functions - may be used in a later update
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
def Find(img_dir):
    location = pyautogui.locateOnScreen(img_dir)
    point = pyautogui.center(location)
    x,y = point

    pyautogui.moveTo(x,y)
def AddFindLocation():
    # Ask the user to select a single file name.
    answer = filedialog.askopenfilename(parent=my_window,
                                        initialdir=os.getcwd(),
                                        title="Please Select An Image:",
                                        filetypes=[('image files', '.png'),('image files', '.jpg')])
    # Add step to the appropriate list(s)
    if not inLoop:
        Steps.append("Find(\""+answer+"\")")
    else:
        Loops[LoopIndex].LoopSteps.append("Find(\""+answer+"\")")

    # Update steps to user
    UpdateSteps()
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


# These functions do not add steps but alters or uses the steps in some capacity
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
"""
# This function uses the 'Steps' list to run all the steps created. In other
# words, it starts the automation process.
"""
def RunSteps():
    MinimizeWindow()
    time.sleep(1) # makes sure the window is minimized before continuing
    #reset integer variables
    global LoopIndex
    global PlayLoop_currentIndex
    LoopIndex = 0
    PlayLoop_currentIndex = 0
    try:
        for step in Steps:
            eval(step) # call function using the string
        MaximizeWindow()
    except KeyboardInterrupt:
        sys.exit()

"""
# This function clears all the steps created and resets all global variables.
"""
def ClearAllSteps():
    answer = messagebox.askyesno("Question","Would you like to clear ALL steps?"
                                 "\nNote: This cannot be undone.")
    if answer == False:
        return # return gaurd - exit function

    global Steps # to make sure it is assigned
    global Loops
    Steps = []
    Loops = []

    #reset integer variables
    global LoopIndex
    global PlayLoop_currentIndex
    LoopIndex = 0
    PlayLoop_currentIndex = 0

    # Display Cleared steps
    UpdateSteps()

"""
# This removes the last step created by the user.
# Note: although it removes the step(s) properly, it does not check if
#       a loop is deleted.
"""
def RemoveLast():
    Steps.pop()
    global LoopIndex
    if inLoop:
        if not Loops[LoopIndex].LoopSteps:#check if 'LoopSteps' list is empty - if it is, remove element from 'Loops'
            Loops.pop()
            LoopIndex -= 1
        else:#'LoopSteps' not empty - pop item from that list
            Loops[LoopIndex].LoopSteps.pop()
    # Note: This doesn't take into accont if loop was deleted

    # Update steps to user
    UpdateSteps()

"""
# This plays a Loop object's steps. Additionally, it increases the global
# varaible 'PlayLoop_currentIndex' to move onto the next Loop object
"""
def PlayLoop():
    global PlayLoop_currentIndex
    Loops[PlayLoop_currentIndex].RunLoop() # run the steps within the loop
    PlayLoop_currentIndex += 1 # increase current index
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


# All the "Add" functionalities which create a step
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
"""
# This creates a step for the user to move the mouse at a location
"""
def AddMoveTo():
    # Notify the user & get mouse location in 3 seconds
    messagebox.showinfo("Message","Close this message then move your mouse to "
                        "the desired location within 3 seconds. After the "
                        "3 seconds, the application will reopen.")
    MinimizeWindow()
    time.sleep(3) # wait 3 seconds
    x,y=pyautogui.position()#get mouse position
    MaximizeWindow()
    answer = messagebox.askyesno("Question","Would you like to redo?\n"
                                 "Answering \"Yes\" will result in replacing "
                                 "the previous location.")

    # repeat the process above unil they choose not to redo
    while answer==True:
        messagebox.showinfo("Message","Close this message then move your mouse to "
                            "the desired location within 3 seconds. After the "
                            "3 seconds, the application will reopen.")
        MinimizeWindow()
        time.sleep(3)
        x,y=pyautogui.position()
        MaximizeWindow()
        answer = messagebox.askyesno("Question","Would you like to redo?\n"
                                     "Answering \"Yes\" will result in replacing "
                                     "the previous location.")

    # Add step to the appropriate list(s)
    if not inLoop:
        Steps.append("pyautogui.moveTo("+str(x)+","+str(y)+")")
    else:
        Steps.append("LoopMoveTo("+str(x)+","+str(y)+")")
        Loops[LoopIndex].LoopSteps.append("pyautogui.moveTo("+str(x)+","+str(y)+")")

    # Display new step to user
    UpdateSteps()

"""
# This crates a step where it will (left,right, or middle) click something on
# screen.
"""
def AddClick():
    # Get mouse button to click
    answer = simpledialog.askstring("Input", "What Button Do You Want To Click?"
    "\nPlease Enter left,middle,or right",parent=my_window)

    # Add step to the appropriate list(s)
    if not inLoop:
        Steps.append("pyautogui.click(button=\""+answer+"\")")
    else:
        Steps.append("LoopClick(button=\""+answer+"\")")
        Loops[LoopIndex].LoopSteps.append("pyautogui.click(button=\""+answer+"\")")

    # Update steps to user
    UpdateSteps()

"""
# This creates a step where a key will be pressed.
"""
def AddKeyboard():
    # Get key to press
    answer = simpledialog.askstring("Input", "What Key Do You Want To Press?"
    "\nLook At Keyboard Input On Website For More Info.",parent=my_window)

    # Add step to the appropriate list(s)
    if not inLoop:
        Steps.append("pyautogui.press(\""+answer+"\")")
    else:
        Steps.append("LoopKeyboard(\""+answer+"\")")
        Loops[LoopIndex].LoopSteps.append("pyautogui.press(\""+answer+"\")")

    # Update steps to user
    UpdateSteps()

"""
# This creates a step where it will type/write what the user wants at runtime.
# Note: There is a 0.15 delay between each press
"""
def AddTyping():
    # Get characters to type
    answer = simpledialog.askstring("Input", "What Do You Want To Type?",parent=my_window)

    # Add step to the appropriate list(s)
    if not inLoop:
        Steps.append("pyautogui.write(\""+answer+"\",0.15)")
    else:
        Steps.append("LoopType(\""+answer+"\")")
        Loops[LoopIndex].LoopSteps.append("pyautogui.write(\""+answer+"\",0.15)")

    # Update steps to user
    UpdateSteps()

"""
# A step is created to hold down (at most) 5 keys at once in an order. The first
# key pressed will be the last to be unpressed.
"""
def AddHotKey():
    # Get an integer in relation to the amount of keys to press
    answer = simpledialog.askinteger("Input", "How Many Keys Are Pressed "
    "At Once?",parent=my_window,minvalue=0, maxvalue=5)

    keys = "" # string containg the keys the user want to press

    # Get each key and add them to the 'keys' string
    for i in range(answer):
        new_key = simpledialog.askstring("Input", "Key "+str(i+1)+" (in order):"
        " ",parent=my_window)
        keys += ("\""+new_key+"\"")
        if i+1 < answer:
            keys += ","

    # Add step to the appropriate list(s)
    if not inLoop:
        Steps.append("pyautogui.hotkey("+keys+")")
    else:
        Steps.append("LoopHotkey(\""+answer+"\")")
        Loops[LoopIndex].LoopSteps.append("pyautogui.hotkey("+keys+")")

    # Update steps to user
    UpdateSteps()

"""
# This creats a step where the user can take a screen shot at a specified
# location. This also saves the screenshot at a directory at with a specific
# name.
"""
def AddScreenshot():
    points = ""
    for i in range(2):
        # Notify the user & get mouse location in 3 seconds
        messagebox.showinfo("Message","Close this message then move your mouse to "
                            "the desired location within 3 seconds. After the "
                            "3 seconds, the application will reopen.")
        MinimizeWindow()
        time.sleep(3)
        x,y=pyautogui.position()#get mouse position
        MaximizeWindow()
        answer = messagebox.askyesno("Question","Would you like to redo?\n"
                                     "Answering \"Yes\" will result in replacing "
                                     "the previous location.")

        # repeat the process unil they choose not to redo
        while answer==True:
            messagebox.showinfo("Message","Close this message then move your mouse to "
                                "the desired location within 3 seconds. After the "
                                "3 seconds, the application will reopen.")
            MinimizeWindow()
            time.sleep(3)
            x,y=pyautogui.position()
            MaximizeWindow()
            answer = messagebox.askyesno("Question","Would you like to redo?\n"
                                         "Answering \"Yes\" will result in replacing "
                                         "the previous location.")
        points += str(x)+","+str(y)
        if i+1 == 1:
            points += ","

    # Ask the user to select a single file name for saving.
    new_file = filedialog.asksaveasfilename(parent=my_window,
                                          initialdir=os.getcwd(),
                                          title="Please select a file name for saving:",defaultextension=".png",
                                          filetypes=[('image files', '.png'),('image files', '.jpg')])
    if not inLoop:
        Steps.append("pyautogui.screenshot(region=("+points+")).save(\""+new_file+"\")")
        Steps.append("RenameSameFiles(\""+new_file+"\")") # this is for insurance purposes
    else:
        Steps.append("LoopScreenshot("+points+")")
        Loops[LoopIndex].LoopSteps.append("pyautogui.screenshot(region=("+points+")).save(\""+new_file+"\")")
        Loops[LoopIndex].LoopSteps.append("RenameSameFiles(\""+new_file+"\")")

    # Display new step to user
    UpdateSteps()

"""
# Adds the start of a loop using a counter from 0 to x, where x is the value
# the user wants to end the loop. This creates a step.
"""
def AddStartLoop():
    # upadte global boolean flag
    global inLoop
    inLoop = True

    # get user's x value
    answer = simpledialog.askinteger("Input", "End Loop After X Iterations?\n"
                                    "X: ",parent=my_window,minvalue=0, maxvalue=99999)
    if answer == None:
        return # user canceled - return safe gaurd

    new_loop = Loop(answer) # create a new loop object
    Loops.append(new_loop) # add object to list
    Steps.append("PlayLoop()") # add step to list

    # Upate Steps to user
    UpdateSteps()

"""
# Adds a step to end the loop created. Additionally it changes the values of
# some global variables.
# Note: this assumes that the user started some sort of loop
"""
def AddEndLoop():
    # get global variables
    global inLoop
    global LoopIndex

    # assigns values to the global variables
    inLoop = False
    LoopIndex+=1

    # add a step to indicate we are at the end of the loop
    Steps.append("EndLoop()")

    # update all the steps created so far to the user
    UpdateSteps()
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


"""
# Initilizes the window, centering it in the middle of the screen.
# Note: that the width >= height to properly center
#
# @param width of the window to be set
# @param height of the window to be set
"""
def InitWindow(windowWidth, windowHeight):
    # Name of window
    my_window.title("Otto")
    # Icon of window
    #my_window.icon_bitmap("./PATH")

    # Scale the window
    my_window.geometry("{}x{}".format(windowWidth,windowHeight))
    # Set current scale as the minimum size
    my_window.minsize(windowWidth, windowHeight)

    # Gets the coordinates for the center of the screen using
    # the window's center as an offset to center window on screen
    positionRight = int((my_window.winfo_screenwidth()-windowWidth)/2)
    positionDown = int((my_window.winfo_screenheight()-windowHeight)/2)

    # Set the location of the window onto the user's screen
    my_window.geometry("+{}+{}".format(positionRight, positionDown))

    # Set colors for window
    my_window.configure(bg=BLACK)

    # TODO: Make My Own Title Bar

    # Update all the properties of the window
    my_window.update()

"""
# Creates the containers for the application. All new containers
# are added to the grid and Containers list and are sticky to
# the main window.
"""
def CreateContainers():
    # Create the frame on the left
    leftFrame = Frame(my_window, bg=PURPLE, height=my_window.winfo_height(), width=int(my_window.winfo_width()/2))
    leftContainer = Container(leftFrame, "leftFrame")

    # Create the frame on the right
    rightFrame = Frame(my_window, bg=LIGHT_PURPLE, height=my_window.winfo_height(), width=int(my_window.winfo_width()/2))
    rightContainer = Container(rightFrame, "rightFrame")

    # Place/position them onto the window
    leftFrame.grid(row=0,column=0, sticky="nswe")
    my_window.grid_rowconfigure(0, weight=1)
    my_window.grid_columnconfigure(0, weight=1)
    rightFrame.grid(row=0,column=1, sticky="nsew")
    my_window.grid_rowconfigure(0, weight=1)
    my_window.grid_columnconfigure(1, weight=1)

    # Append the containers
    Containers.append(leftContainer)
    Containers.append(rightContainer)

"""
# This fills the left frame of the application with an assortment of buttons
# and the title of this frame.The buttons are created with the link to the
# function they do, otherwise they buttons will do nothing.
"""
def FillLeftContainer():
    # Find the relative frame
    relative_frame = GetFrame("leftFrame")
    relative_frame.propagate(0) # prevent cildredn changin size of frame

    # Get background color
    backgroundColor = relative_frame.cget('bg')

    # Create Label Indicating What this is for
    Label(relative_frame, text="Tasks", bg=backgroundColor,fg="white", font=Text_Font).pack()
    Label(relative_frame, text="", bg=backgroundColor).pack() # a spacer

    # add buttons
    Button(relative_frame, text="Move To", bg=BLACK, fg="white", font=Text_Font,command=AddMoveTo).pack()
    Button(relative_frame, text="Click", bg=BLACK, fg="white", font=Text_Font,command=AddClick).pack()
    Button(relative_frame, text="Keyboard", bg=BLACK, fg="white", font=Text_Font,command=AddKeyboard).pack()
    Button(relative_frame, text="Type", bg=BLACK, fg="white", font=Text_Font,command=AddTyping).pack()
    Button(relative_frame, text="Hotkey", bg=BLACK, fg="white", font=Text_Font,command=AddHotKey).pack()
    Button(relative_frame, text="screenshot", bg=BLACK, fg="white", font=Text_Font,command=AddScreenshot).pack()
    #Button(relative_frame, text="Find", bg=BLACK, fg="white", font=Text_Font,command=AddFindLocation).pack()
    Button(relative_frame, text="Start Loop", bg=BLACK, fg="white", font=Text_Font,command=AddStartLoop).pack()
    Button(relative_frame, text="End Loop", bg=BLACK, fg="white", font=Text_Font,command=AddEndLoop).pack()
    Button(relative_frame, text="Run", bg=BLACK, fg="white", font=Text_Font, command=RunSteps).pack()
    Button(relative_frame, text="Clear Steps", bg=BLACK, fg="white", font=Text_Font, command=ClearAllSteps).pack()
    Button(relative_frame, text="Remove Last", bg=BLACK, fg="white", font=Text_Font, command=RemoveLast).pack()

    # Note: There is no need to save the buttons and labels to a variable since
    #       they are static and won't be updated at any given point.

"""
# This fills the right container which is just the title and the spacer
"""
def FillRightContainer():
    # Find the relative frame
    relative_frame = GetFrame("rightFrame")
    relative_frame.propagate(0) # prevent children changin size of frame

    # Get background color
    backgroundColor = relative_frame.cget('bg')

    # Display what thos conatiner is for
    Label(relative_frame,text="Steps", fg="white", bg=backgroundColor, font=Text_Font).pack()
    Label(relative_frame, text="", bg=backgroundColor).pack() # a spacer

"""
# This function updates the left side of the frame showing the user
# all the steps created so far. It does this by deleting all the children
# objects (i.e labels) and the adds new labels showing all the steps created.
"""
def UpdateSteps():
    # Find the relative frame
    relative_frame = GetFrame("rightFrame")
    relative_frame.propagate(0) # prevent children changin size of frame

    # Get background color
    backgroundColor = relative_frame.cget('bg')

    # Clear all widgets in frame
    for widget in relative_frame.winfo_children():
        widget.destroy()

    # Display what this conatiner is for
    Label(relative_frame,text="Steps", fg="white", bg=backgroundColor, font=Text_Font).pack()
    Label(relative_frame, text="", bg=backgroundColor).pack() # a spacer

    # Display steps
    for step in Steps:
        Label(relative_frame, text=step, fg="white", bg=backgroundColor, font=Text_Font).pack()


# the main (in essence)
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
InitWindow(1000,900)
CreateContainers()
FillLeftContainer()
FillRightContainer()
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

# Keep window open until closed
my_window.mainloop()


# Notes: there are 3 things that must be installed, python, pyautogui, and the pillow package
#
