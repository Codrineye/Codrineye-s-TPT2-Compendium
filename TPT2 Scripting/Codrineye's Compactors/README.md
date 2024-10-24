# Codrineye's Compactors
Codrineye's Compactors are scripts formed out of 3 parts
1. [The Compactor](#the-compactor)
2. [The Configuration Workspace](#the-configuration-script)
3. [The Reading Script](#the-reading-script)

These parts have comments included that work to make using the compactor as simple and user friendly as possible.

## The compactor
The compactor is a lua macro that 'compacts' the data needed to perform the task it's designed for.<br>
It requires little to no user interaction, but I try to include options for the user to personalize the output.<br>
Personalization will generally require modifying specified values within the compactor itself.

I want to make it as easy as possible for users to make modifications, so every compactor comes with a debugging mode (not universally present, but soon to be seen in all compactors), where you can have debugging that simply prints out general debugging messages, or debugging that halts compilation for individual analysis.

## The configuration script
The configuration script is the space in which the user comunicates with [the compactor](#the-compactor).<br>
It uses macros defined at the bottom of the compactor, to create a syntax simple to use for adding elements.

It ends with defining constant values

## The reading script
The reading script is the end result program that uses the compacted data to finalize the result.<br>
Each compactor features a README.md which explains what its reading script accomplishes and wether it's a standard script that handles all actions itself, or if it's a library that permits the application of this compactor in a broad set of scripts

# But why
Why would you use a compactor?

The compactor is a category of scripts designed to work with large sets of inputs.<br>
Compactors are quality of life tools that turn the inputs into a format and provide functions that can read this data with minimal user input

<br><br><br><br>
***old contents kept so I know what I wanted to write here***

The compactors are formed to condense tasks that could span several scripts and actions into one single contained script<br>
Using a compactor takes away a lot of the headache that comes with programming lengthy operations to go smoothly, and diverts it my way<br>
The compactor is first and foremost a quality of life improvement for those who want to perform lengthy tasks
