These settings are found in the Facility AI interface<br>
Please go to `Redirect` [Facility AI](Facility%20AI.md) if you're looking for the Facility AI settings under Controls

# Facility AI Settings

![Facility AI Settings](Facility%20AI%20Settings.webp)

`ms max. execution time per tick` is an integer field that represents the number of miliseconds permited for actions to occour in one tick.<br>
If actions halt the game for more than the inputed amount permits, the AI Overlay will shut down.

`ms between AI overlay refreshes` is an integer field that represents the number of miliseconst that must pass for the AI overlay to update.

`Hide global variables in overlay` and `Hide active scripts in overlay` are checkboxes that do exactly what they say they will do.<br>
For more information on active scripts and global variables, check out [Facility AI Scripting](Facility%20AI%20Scripting.md)

`Disable scripts on inport` is a checkbox that determines if importing scripts sets the new scripts to disabled or enabled.

`Hotkey to activate/deactivate AI` is a box that lets you change the hotkey needed to toggle the AI overlay on or off. The reset button changes it back to f4 (the default value). This does the same thing as the button under controls.

Note that these settings are subject to change in the future, this is why I have made this section separate to the explanation in [Facility AI](Facility%20AI.md)
