# Codrineye's Compactors

Compactors are systems that work with large sets of data by forming a lookup string.<br>
These are broken up in the following 3 components:

1. [The Compactor](#the-compactor)
2. [The Configuration Workspace](#the-configuration-script)
3. [The Reading Script](#the-reading-script)

Each component features comments that explain what is happening and its purpose.

# Purpose of a compactor

These systems are specialized tools that give you a formatted string and the tools to work with them.<br>
By having the format already defined, it lets you concentrate more on your code and have to worry less on how your data is stored.<br>
Any tasks that involves processing strings can be converted into a compactor, and it is my hope that by making these systems easy to understand, less people will be driven away from creating tools.

## The compactor

The compactor is a system built entirely within lua macros.<br>
These are further divided into the `header` and the `source`.

#### The compactor header

This header file is used to create the macros through which the end user will communicate with the compactor.<br>
Macros defined in the header file do not create any code, so they can be used in the [configuration script](#the-configuration-script) comments to provide a short code snippet.

The header file should follow this structure

```
; comment explaining the use of the compactor
{lua(\
  --[[lua macro to make relevant comments within]]\
  Compactor_table = {};\
  --[[Define the root table global table that's used by your compactor]]\
  \
  function Compactor_table.macro_body(id)\
  end\
  --[[/*\
    * Define a *stub* function that produces no code that the macros use to get defined.\
    *\
    * While this function gets overwritten in the source,\
    * you should still outline all of the parameters that will be used by your function\
    * The first parameter of the function should be the macro ID.\
  */]]\
)}
; finish the definition of your lua macro
; Define all the macros the user will work with
; All macro definitions should start with an id. This is important for the source
#macro_name {lua(return Compactor_table.macro_body("name"))}
```

#### The compactor source

This source file is what processes the input and formats everything in a compacted form.<br>
It features all computation, and thus, holds the complexity of the compactor.<br>
The most important thing to keep in mind is to make sure that your function names corelate with the macro ID's, but you can easily change the macro ID's after you've built the compactor.

For your macros defined in the header to interact with your code, you'll want to re-define the macro_body function at the end of this lua macro.

```
{lua(\
  --[[Place all of your code before this]]\
  function Compactor_table.macro_body(id)\
    return Compactor_table[id]();\
  end\
)}
```

This simply links up your macros to the lua definitions. In this case, if all you had was 1 macro with the id `name`, you'd need to define the function Compactor_table.name().

## The configuration script

This script is the workspace in which the user uses the compactor to _compact_ their data.<br>
By having a header -> source system you can first import the header to explain how to interact with the macros and then you import the source file for the user to use the compactor.

Here is an example

```
:import Example_compactor hdr
;
; Import the header file to explain what you can work with
; use {example1("test")} to define your test environment
; {debug(true)} enables debugging and {debug(false)} disables it
; {output.1} outputs the first character of {example1}

:import Example_compactor src
{debug(false)}
{example1("1 + 1")}
:const string t {example.3}
```

## The reading script

This is the script that's imported in the game.<br>
Reading scripts fall in 2 categories:<br>
1. The stand-alone script that's integrated within your script package without issues.
2. The communication script.

#### What is a communication script?

This script comes into play if your compactor performs tasks so complex that you need to create a library for it.<br>
The communication script is used to transmit data from your script to the execution script.

# But why

Why would you use a compactor?

The compactor is a category of scripts designed to work with large sets of data.<br>
They act as tools that improve your quality of life if a task you're performing has a compactor.<br>
Additionally, they're made to be easy to follow and understand, providing comments that explain the system
