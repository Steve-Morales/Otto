# Otto
Windows OS User Automation Tool

# What is Otto?
Otto automates your interactions with your Windows computer using Python and Pyautogui.
Automate mundate tasks like clicking on the cookie from Cookie Clicker! ... okay, maybe something more useful than that.

# What can I do with Otto?
You can automate clicking, mouse movement, take screenshots, loop steps, and keyboard events.

# How do I use Otto?
The application has to two sides named "Tasks" and "Steps".

The "Tasks" side is where you are given a small quantity of options which allow you to create a step, which as the names infer, is some action your computer will do.

The "Steps" side just indicates that you created some step that the computer will do. You do not need to worry what it's printing out, but just make sure it prints, otherwise you MUST START OVER FROM THE START BY REOPENING THE APPLIACTION.

MoveTo

Basically, you just move your mouse to the location when you want to click or need to hover over. You are given 3 seconds to do this, but you can always redo if you messed up.

Click

This too is simple, it just asks if you want to left, right, or middle click. Note: if you submit a typo, you must restart the application!

Keyboard

This may be a little confusing but this functionality should be used to press a button that is not a letter or number. Look at the Keys page for more information on these types of keys.

Type

As the name suggests, you are simply asked what you want to type. However, there is an implication that you are already added steps to be able to type in some textbox.

Hotkey

This is similar to the Keyboard functionality, but multiple keys of any type can be pressed at once in the order they are entered. 

Screenshot

As the name states, it takes a screenshot from position 1 to position 2. These positions are added by the location of your mouse which is similar to MoveTo. Note: do not worry about same named files, but make sure you save it into a folder that is empty!

Start Loop

This creates the start of the loop where you will loop the upcoming steps that you will create. It will loop those steps x amount of times.

End Loop

This just indicates the end of the loop and the steps following this one will not be looped.

Run

Assuming you did everything properly, the window will be minimized and it will commence all the steps you have outlined. 

Clear Steps

This clears all the steps you have done. Note: There are still some bugs with this...probably (I didn't really use it all too much)

The Failsafe

Because I know this application is buggy and not everything goes according to plan, I added a Failsafe which prevents whatever steps you are doing from going haywire. All you have to do to trigger it is, move your mouse very quickly to any of the 4 corners of your screen. Keep moving it until you see that your mouse stays still and nothing is being done/typed. Exit the application and restart (no need to restart your device, just your steps). 


# How do I install Otto?
You can download the executable [here](https://dsbetn.weebly.com/) **or** you can install Python, then you need to install the Pyautogui and Pillow packages.
