# Perfect Tower lib

This is a library you import into desmos by pasting in this link into your graph https://www.desmos.com/calculator/0ggizwae6x.

It consists of a UI size slider, a game screen rectangle, a game mouse and a button to reset the UI status to the default state of an 800x450 resolution with a 100% ui size.

There's also a dark mode you can chose to disable. Reseting to default does not re-activate dark mode

## Notation Rules

For organization, it follows notation rules that I recommend to be followed as well if you're using the library.

The naming scheme is {Ruleset}_{variable name}.<br>
The rulesets are as follows:
- C reprezents a constant variable. This variable holds a value that'd not modified by any other variable.
- D reprezents a dynamic variable. This variable holds a value composing of other values.
- F is a function. Functions are like dynamic variables but they have function parameters.
- P is a function parameter. These are defined within a function.

## Variables

### UI Colors

C_{uiSliderColor} = rgb(3, 167, 254)<br>
This is the color of the games UI slider trail

C_{uiButtonColor} = rgb(234, 234, 234)<br>
This is the color of the ingame UI button

### Perfect UI Control

C_{ui} is a 0.5-1 value that's used to contol the UI.<br>
D_{percentUI} = C_{ui} * 100

C_{width} and C_{height} are your game windows width and height.<br>
C_{maxWidth} and C_{maxHeight} are the maximum limits of your game windows width and height.<br>
By default, your game screen is restricted to a minimum size of `11x11` (like it is ingame) and a maximum size of `1920x1080` which is my maximum resolution.

D_{gameScreen} is a point that lets you change C_{width} and C_{height} without needing to find the slider. It'll make more sense if you look at the graph.

D_{resolutionFactor} is the factor between your curent game window resolution and the maximum resolution.

C_{mousePosition} is your game mouse.

## Functions

Importing the library adds 3 functions. They're separated into their own folders.

### Static Vector

vec is the ordinary vector syntax. This function creates a point in desmos.

F_{vec}(P_{coordX}, P_{coordY}) = (P_{coordX}, P_{coordY})

### Relative Vector

pos.relative is a macro from [the external editor by d0sboots](https://d0sboots.github.io/perfect-tower/) that creates a relative position by taking into account the game screens resolution and its UI size.

```
D_{relativeWidth} = min(C_{width}, C_{height} * 16 / 9)
D_{relativeHeight} = min(C_{height}, C_{width} * 9 / 16)

Relative width/height are used to determine if the game window is tall or wide.

F_{anchoredCoord}(P_{coord}, P_{anchor}) = C_{ui} * (P_{coord} - P_{anchor})
Adds an offset based on the ui size.

F_{posRelative}(P_{relativeX}, P_{relativeY}, P_{anchorX}, P_{anchorY}) = F_{vec}(
  D_{relative Width} * P_{anchored Coord} (P_{relativeX}, P_{anchorX}) + C_{width} * P_{anchorX},
  D_{relative Height} * P_{anchored Coord} (P_{relativeY}, P_{anchorY}) + C_{height} * P_{anchorY}
)
```

All spaces added in the variable names in the function are purely so it's easier to read

### Canvas Drawing

canvas.rect is a function from the game that you unlock with the boots.d0s software.<br>
It takes in a starting point and a rectangle size to draw you a rectangle.

```
F_{canvasRect}(P_{origin}, P_{size}) = polygon(
  P_{origin}, 
  F_{vec}(P_{origin}.x, (P_{origin} + P_{size}).y), 
  P_{origin} + P_{size}, 
  F_{vec}((P_{origin} + P_{size}).x, P_{origin}.y)
)
```
