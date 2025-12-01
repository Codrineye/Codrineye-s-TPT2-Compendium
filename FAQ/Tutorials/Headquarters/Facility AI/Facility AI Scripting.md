# Creating a script

![New Script](New%20Script.webp)

Creating a script requires you to click the `new` button in the Facility AI Interface.<br>
This action will create a new script titled `New Script` by default. Clicking on this script will update the interface as seen in the provided image.

The name and package form the scripts identifier. For the script I just made, that identifier is `:New Script`, which you get by typing the package name, followed by a `:` separator, and then the script name. This identifier will be seen when the script is running, if you haven't hidden script names on the overlay.

The execution budget determines how many fundemental actions the script can make. If the scripts budget reaches 0, it will stop executing until the next cycle.

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

The blue fundemental actions take 100 budget to execute, the red atomic actions take 0 budget to execute.


Now that the fundamentals are defined, let's get into scripting propper.

# The editors

There are 2 editors at our disposal.<br>
The internal editor, contained fully within the game, using blocky-style syntax.<br>
The external editor, a separate website maintained by d0sboots that uses typed syntax.

Both editors have their goods and bads, but complexity is usually achieved within the external editor for convenience.

If you're making a script, you should know your tools.<br>
From personal experience, the internal editor is best at small changes, with the benefit of being able to test instantly, and the external editor is best for both small and big changes, code clarity, and development structure, with the one downside being that you have to import a script to test it.

Your own preferences will determine which editor you use and how you use it. Do not compare your workspace with someone elses and be confused if they're diffrent. Everybody codes in their own way.

The internal editor doesn't offer quality of life improvements to make your life easier, so I recommend using the external editor. It has been linked to death in this entire FAQ cluster, and here's the final link to it. `Direct` [The external editor by d0sboots](https://d0sboots.github.io/perfect-tower/).

# Making a script

When developing a script, you should know what you want to do.

## Handeling clicks

For the times when you need a click position to be relative to the resolution. If you're not making something for others to use, you can ignore most of this.

If your script needs to use clicks or relative positions, then you're going to have a bad time.<br>
`click`, `scrollrect` and `scrollbar` need relative positions which will make your life hard.

It's simple in theory. Activate the AI overlay, press F7 (default hotkey) to activate AI learning, record your clicks, press f and done, you've now got your positions.<br>
But if you want to make them relative to the resolution, here's the added steps.

First, set your window to a 16:9 resolution. I prefer 800x450 for recording clicks, but as long as it's still 16:9 you can use whatever.<br>
Next, make sure your UI scale is at 100% and that you have Dynamic UI Scale turned off. Dynamic UI Scale doesn't update the ui.size() variable, so 