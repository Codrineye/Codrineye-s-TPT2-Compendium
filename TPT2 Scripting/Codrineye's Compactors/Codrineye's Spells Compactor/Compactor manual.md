# Using the Spell Compactor

This is a tool that lets you record multiple spell activation sequence of multiple blueprints.<br>
For the purposes of this manual, an activation sequence is called a `recording`.

To make a recording of your blueprint, I recommend you copy over the `Config` file from [the pre-made template](./template%20using%20spells%20compactor/Spell%20Config_template.tpt2) into the editor.

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

Please note that, since these are macros, commenting them does not prevent the action from being taken.<br>
If you want to comment out a spell or a synchronization, you should make a comment that contains the macros inputs but that ***`DOES NOT CALL THE MACRO`***.

recorded_blueprint tells the compactor that the recording it has made is a blueprint. This macro returns a const int value that holds the current ammount of space in the recording. This variable is called blueprint_`value within blueprint_name`, so that you can cut up the recorded string

add_spell.`spell_type` also returns a const int, irelevant of the spell type. Similar to recorded_blueprint, this variable contains the space in the recording _after_ adding the spell. The difference being that this constant is called spell_`spell_number`.

Your recording gets compacted and stored in the string `recorded_actives` and, in addition, your recordings size is stored in the integer `recording_size`.

recording_size holds the same value as spell_`number of spells recorded`.

For an example of how these functions can be interacted with, please look at the recording within the Spell_Config you saw in the pre-template.

## Using the recording

Now that you've got the recording, you're going to have to send it over to the compactor.<br>
Luckily, the way to do this is already explained in the [template caller script](./template%20using%20spells%20compactor/blueprint%20AI%20caller.tpt2).

You will need to use {pointer.set} and {compactor.set} in this exact order.<br>
Setting the pointer starts a block hider that hides all global variables that get defined ofter it.<br>
Setting the compactor sends the recording string over to the compctor script for it to get processed and executed.

Once you execute the compactor, it'll stop the block hider when setting the caller_ID. This variable tells you who started the script.<br>
This is a signal used by the compactor internally and tells you if there's any blueprint AI's active that you wouldn't want to be.

You can add an offset to the pointer by setting pointer.set to a space value. To do this, you just have to take the spell_`number` value you want to start at and subtract from it blueprint_`blueprint name` of the blueprint that you recorded before this blueprint.<br>
It's complicated to describe, so if anybody has a suggestion on how to better explain this, feel free to create a pull request or message me on discord.

The Compactor can only reset the timer when it enters idle mode, as it's made to support multiple compactors running at the same time, even if these copies weren't started for your blueprint.<br>
This design decision was made to support cases in which you'd want to send an additional recording after the previous one was finalized.
