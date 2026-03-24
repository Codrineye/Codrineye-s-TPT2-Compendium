# Creating a script

![New Script](New%20Script.webp)

Creating a script requires you to click the `new` button in the Facility AI Interface.<br>
This action will create a new script titled `New Script` by default. Clicking on this script will update the interface as seen in the provided image.

The name and package form the scripts identifier. For the script I just made, that identifier is `:New Script`, which you get by typing the package name, followed by a `:` separator, and then the script name. This identifier will be seen when the script is running, if you haven't hidden script names on the overlay.

The execution budget determines how many fundamental actions the script can make. If the scripts budget reaches 0, it will stop executing until the next cycle.

And finally, the checkbox to determine if the script is enabled or not. If a script is enabled, activating the AI overlay will let you interact with it.

# Editing a script

![Internal Editor](./Internal%20Editor.webp)

When editing a script, you can either use the internal editor (as shown above), or the external editor. We'll cover the external editor a bit later, but keep it in mind.

Here we have the 3 components of a script.<br>
- impulse defines what user action needs to be made for the script to activate.
- conditions are a set of pre-defined conditions that must be true for the script to activate.
- actions are the set of instructions your script performs.

For a full list of all AI actions, you can look at `Redirect` [AI Functions](./AI%20Functions.md).

To the left, you have a scrollbar and a search box that lets you find any component you may want.

Every script has access to 10 impulses, 10 conditions and 50 actions. You can not go over these limits.<br>
To add actions, impulses and conditions, you simply click on the components and do whatever you'd like.

Variable scopes:
- local variables hold their value only in the 1 script instance.
- global variables hold their values in the global scope, where any script can access them and their values are kept as long as they're not unset and the AI overlay stays on. If you turn off the AI overlay by pressing the key to toggle it on/off or by crashing facility AI, all global variables and running script instances will be lost.

The blue fundamental actions take 100 budget to execute, the red atomic actions take 0 budget to execute.


Now that the fundamentals are defined, let's get into scripting proper.

# The editors

There are 2 editors at our disposal.<br>
The internal editor, contained fully within the game, using blocky-style syntax.<br>
The external editor, a separate website maintained by d0sboots that uses typed syntax.

Both editors have their goods and bads, but complexity is usually achieved within the external editor for convenience.

If you're making a script, you should know your tools.<br>
From personal experience, the internal editor is best at small changes, with the benefit of being able to test instantly, whereas the external editor is best for both small and big changes, code clarity, and development structure, with the one downside being that you have to import a script to test it.

Your own preferences will determine which editor you use and how you use it. Do not compare your workspace with someone elses and be confused if they're different. Everybody codes in their own way.

The internal editor doesn't offer quality of life improvements to make your life easier, so I recommend using the external editor. It has been linked to death in this entire FAQ cluster, and here's the final link to it. `Direct` [The external editor by d0sboots](https://d0sboots.github.io/perfect-tower/).

# Making a script

When developing a script, you should know what you want to do.<br>
If you don't know, look around in the game, actions or in other scripts and test curiousities if any form. Play around and familiarise yourself with the editors, trust me, there's no shortage of places where scripts can be used.

There are a few implementation principles we'll cover.

## Script Execution



## Handling clicks

For the times when you need a click position to be relative to the resolution. If you're not making something for others to use, you can ignore most of this.

If your script needs to use clicks or relative positions, then you're going to have a bad time.<br>
`click`, `scrollrect` and `scrollbar` need relative positions which will make your life hard.

It's simple in theory. Activate the AI overlay, press F7 (default hotkey) to activate AI learning, record your clicks, press f and done, you've now got your positions.<br>
But if you want to make them relative to the resolution, here's the added steps.

First, set your window to a 16:9 resolution. I prefer 800x450 for recording clicks, but as long as it's still 16:9 you can use whatever.<br>
Next, make sure your UI scale is at 100% and that you have Dynamic UI Scale turned off. Dynamic UI Scale doesn't update the ui.size() variable, so you'll have to pray that nobody using your script has that option active. Record all the clicks you want and press `f`.<br>
You can now get back to full screen and set your UI scale to 50%. Note down the direction it approaches to find the elements anchor, and you're now good to go.<br>
For coordinate debugging, boots.d0s is your best friend. canvas.rect({pos.relative()}, vec(5.0, 5.0), "#FFF") is my personal go-to. It shows you the relative coordinate, and you can check if your anchor is off by updating your UI scale to make sure no matter the scale, you still start on your target.

I also created a little desmos thingy for this. [Redirect Perfect Tower lib](../../../../Desmos%20Graphs/Perfect%20Tower%20lib.md) is a helper library that you can import inside of a desmos graph to gain the function definitions. It also includes a little example for how to record relative vectors.

Relative vectors require some trial and error, but clicks can be used to achieve some pretty neat stuff, so have fun.

## Handling state

For the times when your script needs to keep a state. This is almost always a necessity for towertesting scripts.

A common towertesting script is the following
```
game.newround()

wait(300.0)
restart()
```
Created at mt7 to achieve era1 for mt8. The script starts up when you enter towertesting, waits for 300 seconds and then restarts. However, if your tower dies and have auto-restart, or you restart manually, this will create another copy of the script, and this happens over and over again.<br>
The simple solution is to add a state.
```
game.newround()
:global bool running

gotoif(99, running)
running = true
wait(300.0)
restart()
running = false
```
By adding the global boolean running, we now only keep 1 instance of the script running at any point in time. It is important that you keep this as a global, as a local can not be read by the new script instance.

This solution has a problem, our game restarted but we didn't refresh the wait() time. This means that, if we manually restarted or died 200 seconds into the run, this script will restart after 100 seconds pass instead of 300. There are many ways to fix this, however, this solution also keeps the intent clear.
```
game.newround()
:global bool running

gotoif(99, running)
running = true
waitwhile(game.realtime() < 300.0)
restart()
running = false
```
As wait(300.0) waits in real time, we wait for as long as the real time spent in the game is less than 300. This takes advantage of the fact that starting a new game in towertesting resets game.realtime() and game.time() to 0.

## User Communication

There are times where communicating with the user can be beneficial. Be it for runtime debugging, making a feature work better or simply decoration, it's an important aspect to keep in mind

Communication can only happen via UI, and this is achieved in 2 ways

### Custom Overlay

The Custom AI Overlay is the intended method for performing this communication, however, it is rarely used as Overlay creation is rather clunky.<br>
Overlays also hit the execution budget, but this is secondary to the problem of outright creating the overlay.

For more details, head over to [Facility AI Windows](Facility%20AI%20windows.md).

### Global Variables

The most common UI is formed via global variables, as these give more freedom compared to the custom overlay.

Global overlays are usually action efficient, as what could take multiple actions with a custom overlay can be done through concatenation of 1 single string variable. This was especially important back when scripts had 25 max actions.<br>
They also mix well with state-dependent scripts, as script state typically requires global variables, so adding an overlay can be integrated.

The caveat when using global variables for the UI is that they're generally fragile, being global, and thus, any script being able to access them. Additionally, the option to hide global variables completely hides the UI, as one would expect.

## Decided on what to do

Wonderful, you can now plan out the implementation.<br>
Remember that even though it's a game, you're still using a programming language, so there are infinitely many ways to implement your ideas.

You now know the extent of AI scripting.

## Best Practices

Programming has best practices, so it might as well get covered here, right?

### Basic implementation

Use goto(51) or higher to terminate the script.<br>
You can also use stop(self), however that removes all instances of the script, so if you have another instance which you'd like to stay running, stop() will remove it too.<br>
Don't treat global variables as tho they're local variables.

Avoid unsetting global variables at all cost. This gets covered under [Avoiding Clutter](#avoiding-clutter).

### Avoiding Clutter

When your script uses global variables, it's also important to clean up the interface.

Your first instinct might be to use global.unset if you didn't know of the tags `<size=0>` and `<line-height=0>` tags, however, global.unset must be avoided at all costs.<br>
Global variables are stored inside of a list, and if a global is unset, the unset variable leaves a hole. When somebody or even yourself sets a new global variable, instead of getting a new variable at the bottom of the list, it will get added inside that hole left in the list.

Instead of global.unset, we use the afformentioned TeXtmesh tags of `<size=0>` and `<line-height=0>` to leave no sign of our existence.

We call a hiding block a string which contains the tag `<size=0>` and the hiding block ends when the tags `</size>` or `</size=0>` are encountered.
```
global.string.set("<size=0>start hiding_block", "end hiding_block</size>")
```
This snippet creates a variable `<size=0>start hiding_block` which starts a hiding block, and the rest of the string `=end hiding_block` is hidden, up until `</size>`, which is itself replaced with a hidden control character.<br>
To release a hiding block, simply remove the `</size>` tag at the end. 

