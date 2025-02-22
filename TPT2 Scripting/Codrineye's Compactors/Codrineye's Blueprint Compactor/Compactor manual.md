# The Blueprint Compactor

This library handles multiple functions needed for defining a blueprint AI.<br>
EasyEra cat and WaterCat are implemented in your blueprint AI (because it's more efficient)<br>
The Spell and Secures Compactors are strings used by the compactor executor.

- [Using EasyEra cat](#using-easyera-cat)
- [Using WaterCat](#using-watercat)
- [Spell Compactor](#using-the-spell-compactor)
- [Secures Compactor](#usign-the-secures-compactor)

# Using EasyEra cat

When you import the Blueprint Compactor resources, you gain access to 3 macros that solve era handling for you.
- `set_priority(element_name)` defines that you want the element with element_name to be disabled. This is a `first in first out` (FIFA) priority system, meaning that you will not be able to disable the elements with a priority set after an element.
- `disable.era` is a macro you use in the function `disable.era()`. 
- `disabled_era` is a macro you use to detect if all elements you wanted to disable are disabled.

You can see how it works by looking at [The blueprint handler](./template%20using%20blueprint%20compactor/blueprint%20handler.tpt2).

# Using WaterCat

You will have to copy the [Software Config](./template%20using%20blueprint%20compactor/Software%20Config_template.tpt2) file to use watercat.<br>
You set the security level for your software. You do this by changing the parameter inside of the macro with the software name.

To use watercat, you'll need to use the macros watercat_line1, _line2 and _line3.<br>
- `line1` sets the jump lable `software_toggle_loop` and is the line that toggles the software. This is the only line macro that has a parameter.<br>
This parameter is used to determine the security level. If you have a known security level that you know should not ever change, you can just use a constant value. If you know that you'll want to change this security value eventually, you just set it to the name of an integer value.
- `line2` is the line that updates the index.
- `line3` is a gotoif that loops through all the software until you've gone through them all.

An example using watercat with a static security level can be seen in [The blueprint handler](./template%20using%20blueprint%20compactor/blueprint%20handler.tpt2) and with a dynamic security level, see [The dynamic version](./template%20using%20blueprint%20compactor/watercat%20with%20dynamic%20security.tpt2).

# Using the Spell Compactor

This tool lets you record multiple spell activation sequence of multiple blueprints.<br>
For the purposes of this manual, an activation sequence is called a `recording`.

To make a recording of your blueprint, I recommend you copy over the `Config` file from [the pre-made template](./template%20using%20blueprint%20compactor/Spell%20Config_template.tpt2) into the editor.

Now that you have a configuration file, follow the instructions outlined in the config file.

## Creating a recording

Making a recording is similar to making a program. You will, eventually, have to fix something.<br>
This is why, the compactor comes with debugging macros that let you better understand the tool you're using.

The debugging macros at the top of the file let you
* `log` every spell individually to your browsers developer console.
* `halt` the recording process to let you analyze a moment in time.
* define a `halting limit` that determines how many spells to record before halting takes place.
* `display` your recording so that you can, yet again, better analyze what's happening.
* define a `display format` that determines the format used when displaying your recording.

Additionally, you can add a breakpoint via the {spell_debug.breakpoint} macro.

The recording macros are used to let you communicate with the compactor.
* `recorded_blueprint` takes in a blueprint_name and a true/false value determening if you want the recording to loop.
* `synchronize` takes in the number of spells you want to synchronize.
* `add_spell.instant` takes in the spell name and the time at which you want the spell to execute.
* `add_spell.grounded` takes in the name and timer, like .instant, but also x/y coordinates for where you want to cast it.
* `timer_modulo` takes in a double value that's used to determine the base used for the defined blueprint. The base means the largest value the timer can have before it should be considered 0.0 again.

Please note that, since these are macros, commenting them does not prevent the action from being taken.<br>
If you want to comment out a spell or a synchronization, you should make a comment that contains the macros inputs but that ***`DOES NOT CALL THE MACRO ITSELF`***.

add_spell.`spell_type` returns a const int, irelevant of the spell type. Similar to recorded_blueprint, this variable contains the space in the recording _after_ adding the spell. The difference being that this constant is called spell_`spell_number`.

recorded_blueprint tells the compactor that the recording it has made is a blueprint. This macro returns a const int value that holds the current ammount of space in the recording. This variable is called blueprint_`value within blueprint_name`, so that you can cut up the recorded string.

timer_modulo is best used before calling recorded_blueprint for clarity.<br>
Adding a modulo adds extra space to the recording, making the value in spell_`spell_number` of the previous add_spell no longer be accurate.<br>
recorded_blueprint sends the accurate space ammount.

Your recording gets compacted and stored in the string `recorded_actives` and, in addition, your recordings size is stored in the integer `recording_size`.

recording_size holds the same value as spell_`number of spells recorded`.

For an example of how these functions can be interacted with, please look at the recording within the Spell_Config you saw in the pre-template.

## Using the spells recording

Now that you've got the recording, you're going to have to send it over to the compactor.<br>
Luckily, the way to do this is already explained in the [template caller script](./template%20using%20blueprint%20compactor/blueprint%20AI%20caller.tpt2).

You will need to use `{pointer.set}` and `{comp_actives.set}` in this exact order.<br>
Setting the pointer starts a block hider that hides all global variables that get defined ofter it.<br>
Setting the compactor sends the recording string over to the compctor script for it to get processed and executed.

Once you execute the compactor, it'll stop the block hider when setting the caller_ID. This variable tells you who started the script.<br>
This is a signal used by the compactor internally and tells you if there's any blueprint AI's active that you wouldn't want to be.

You can add an offset to the pointer by setting pointer.set to a space value. To do this, you just have to take the spell_`number` value you want to start at and subtract from it blueprint_`blueprint name` of the blueprint that you recorded before this blueprint.<br>
It's complicated to describe, so if anybody has a suggestion on how to better explain this, feel free to create a pull request or message me on discord.

The Compactor can only reset the timer when it enters idle mode, as it's made to support multiple compactors running at the same time, even if these copies weren't started for your blueprint.<br>
This design decision was made to support cases in which you'd want to send an additional recording after the previous one was finalized.

# Usign the Secures Compactor

The secures compactor lets you record a sequence of modules that you want to secure.<br>
You will not be able to secure the next module until the previous one is secured.

Adding secures is performed using the following macros
* `add_secure(module_ID)` adds the module with ID `module_ID` to the security sequence.
* `recorded_secures(blueprint_name)` returns the current ammount of space taken up in the recording through a const int with the name `secures_<blueprint_name>`. Additionally, an entry is made in the global table BP.comp.defined_secures at index `blueprint_name` with the space ammount, so that you can retrieve the space ammount in a lua macro.

Your security recording is concatenated in the const string `recorded_secures` and its size is saved in the const int `secures_space`.

## Using the secures recording

Now that you've got the secures recording you want, you can use the macro `{comp_secure.set}` to set the string over to the compactor.

Keep in mind that you should do this with a hiding blocker still active, or else your displayed global variables will include the string you send over. Thus, it's best to set `comp_secure` next to when you set `comp_actives`.<br>
Additionally, remember that the global variable "Caller ID" is what stops the block hider, so you should make sure that you don't execute the compactor before these global variables get initialized.
