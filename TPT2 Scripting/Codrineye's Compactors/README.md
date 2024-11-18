# Codrineye's Compactors

Codrineye's Compactors are scripts formed out of 3 components

1. [The Compactor](#the-compactor)
1. [The Configuration Workspace](#the-configuration-script)
1. [The Reading Script](#the-reading-script)

These have comments included, to make using the compactor as simple and user friendly as possible.

## The compactor

The compactor is a system mostly composing of lua macros that works to `compact` a sequence of information needed to perform a set task.<br>
Its design is self sufficient, meaning that no modifications should be needed on the user end to be able to use it.

A compactor made by me will generaly consist of 2 systems:

1. The compression system, that takes in a user input, stores it and outputs it coresponding to what the task requires. Its output is usually a string.
1. The debugger system, that handles edge-cases such as sending error messages and data validation to ensure none of the inputed values can cause a malformed output string.

Personalyzations is typicall handled by the debugging functions, that permit you to display the internal data.<br>
The output string, however, is usually a generalized output that looks the same for all applications.

## The configuration script

The configuration script is the space in which the user comunicates with [the compactor](#the-compactor).<br>
It uses macros defined at the bottom of the compactor, to create a syntax simple to use for adding elements.

## The reading script

The reading script is the end result program that uses the compacted data to finalize the task.<br>
Each compactor features a README.md which explains what its reading script accomplishes.

# But why

Why would you use a compactor?

The compactor is a category of scripts designed to work with large sets of data.<br>
They act as tools that improve your quality of life if a task you're performing has a compactor.<br>
Additionally, they're made to be easy to follow and understand, providing comments that explain the system
