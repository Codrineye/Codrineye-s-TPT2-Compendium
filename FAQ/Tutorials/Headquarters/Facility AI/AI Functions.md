If you are here to understand Facility AI, there's a separate post for [Facility AI](Facility%20AI.md)<br>
If you are not here to understand a specific function in more detail, please go to [Facility AI Scripting](Facility%20AI%20Scripting.md) for information on writing an AI

# AI Functions

AI Functions are blocks used when writing scripts.<br>
This is a list of all of them, separated according to the function type

For space, I've created the groups `data_type`, buildings, `digits` and `letters`. When you see these, just know that the specified action works for for all items in its coresponding list:

`data_type` = `bool`, `double`, `int`, `string`, `vector`

buildings = "arcade", "construction firm", "factory", "headquarters", "laboratory", "mine", "museum", "power plant", "shipyard", "statue of cubos", "trading post", "workshop"

`digits` = `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`

`letters` = `a`, `b`, `c`, `d`, `e`, `f`, `g`, `h`, `i`, `j`, `k`, `l`, `m`, `n`, `o`, `p`, `q`, `r`, `s`, `t`, `u`, `v`, `w`, `x`, `y`, `z`

The functions are written in the [External AI Editor](https://d0sboots.github.io/perfect-tower/) format first, and then written in the internal editor format in `[square brackets]`

There are 4 types of functions:
- [Impulse functions](#impulse-functions)
- [Conditional functions](#conditional-functions)
- [Atomic functions](#atomic-functions)
- [Fundemental functions](#fundemental-functions)

## Impulse functions

An impulse lets you activate your script by performing an action
You cannot trigger an impulse if the AI Overlay is inactive

wakeup() `[impulse wakeup]`<br>
activate the script when the AI Overlay is activated.

newround() `[impulse newround]`<br>
activate the script when you start a game of towertesting.

open.buildings() `[impulse open: buildings]`<br>
activate the script when you enter the respective buildings.

close.buildings() `[impulse close: buildings]`<br>
activate the script when you exit the respective buildings.

mouse.0.down() `[impulse mouse: left down]`<br>
activate the script when your left mouse button is pressed down.

mouse.0.up() `[impulse mouse: left up]`<br>
activate the script when your left mouse button is no longer being pressed down.

mouse.1.down() `[impulse mouse: right down]`<br>
activate the script when your right mouse button is pressed down.

mouse.1.up() `[impulse mouse: right up]`<br>
activate the script when your right mouse button is no longer being pressed down.

mouse.2.down() `[impulse mouse: middle down]`<br>
activate the script when your middle mouse button is pressed down.

mouse.2.up() `[impulse mouse: middle up]`<br>
activate the script when your middle mouse button is no longer being pressed down.

key.`digits`() `[impulse key: `digits`]`<br>
activate the script when you press the respective number key.

key.`letters`() `[impulse key: `letters`]`<br>
activate the script when you press the respective letter key.

## Conditional functions

A condition is computed by the script before executing any actions.<br>
If any of the conditions returns false, the script will terminate without execution

There is a bug in how conditions handle script termination. If a script calls another script using [executesync()](#fundemental-functions), and the called script has a false condition, the called script will terminate itself. However, the calling script incorrectly continues to treat the called script as still running. 

## Permited operators

### Boolean

`==`, `=` means equal<br>
`!=` means not equal<br>
`&&`, `&` means and<br>
`||`, `|` means or

### Int/Double
`==`, `=` means equal<br>
`!=` means not equal<br>
`<` means smaller than<br>
`<=` means smaller or equal than<br>
`>` means larger than<br>
`>=` means larger or equal than

### String
`==`, `=` means equal<br>
`!=` means not equal

## Conditions

comparison.`data_type`(`data_type`, "operator", `data_type`) 
`[comparison: `data_type` type: `data_type`, type: string, type`data_type`]`<br>
Compares two values of the same `data_type` (excluding vector) based on the selected operator.

global.bool.get("variable name") `[global: get (bool) type: string]`<br>
Returns the value of the global bool variable with the coresponding name.

local.bool.get("variable name") `[local: get (bool) type: string]`<br>
Returns the value of the local bool variable with the coresponding name<br>
please keep in mind that the value of a local bool will always be false on script activation.

stunned() `[tower: is stunned]`<br>
Returns true if the tower is stunned. Returns false if the tower is not stunned or if towertesting is not active.

isTowerTesting() `[game: is tower testing]`<br>
Returns true if the game is currently in the Tower Testing screen, even if the game is paused or the tower is destroyed.

isBossFight() `[game: is boss fight]`<br>
Returns true if a boss fight is currently active. Returns false otherwise.

contains(string1, string2) `[string: contains type: string, type: string]`<br>
Returns true if string1 contains the same character sequence of string2.

contains("foo", "oo") → true: "oo" is part of "foo".
contains("foo", "foo") → true: "foo" matches "foo" entirely.
contains("foo", "fooo") → false: "fooo" exceeds the length of "foo".
contains("foo", "a") → false: "a" is not part of "foo".
contains("foo", "") → false: An empty string is not considered part of a string.

not(bool value) `[bool: not type: bool]`<br>
Returns the opposite of the given bool value. not(true) = false; not(false) = true.

mouse.0.state() `[mouse: left]`<br>
Returns true if the left mouse button is being held down.

mouse.1.state() `[mouse: right]`<br>
Returns true if the right mouse button is being held down.

mouse.2.state() `[mouse: middle]`<br>
Returns true if the middle mouse button is being held down.

visibility.get("windowID") `[window: is visible type: string]`<br>
Returns true if the window with id `windowID` is visible.

child.visibility.get("windowID", "elementID") `[window: is visible type: string, type: string]`<br>
Returns true if the child of window `windowID` with id `elementID` is visible.

software.enabled("software name") `[software: is enabled type: string]`<br>
Returns true if the software with id [software name](#fundemental-functions) has been enabled. Returns false if software is disabled or not installed.

pause.get() `[game: is paused]`<br>
Returns true if the game is currently paused during Tower Testing via the Pause button. Returns false if outside of towertesting

isopen("town window") `[town: window open type: string]`<br>
Returns true if the inputed [town window](#fundemental-functions) is active and visible on the screen.

anyopen() `[town: any window open]`<br>
Returns true if any window in town is open.

worker.paused("worker name") `[worker: is paused type: string]`<br>
Returns true if the first worker with the name `worker name` is paused or if no worker with the given name exists.

mine.hasLayers() `[mine: has layers]`<br>
Returns true if the current active mining tab can generate at least 1 layer.

wheel.isSpinning() `[arcade: lucky wheel is spinning]`<br>
Returns true if the Lucky Wheel in Arcade is currently spinning.

jumble.isActive() `[arcade: jumble is active]`<br>
Returns true if there is an active game of Jumble in the Arcade.

hasPheonixFeather() `[adventure: has pheonix feather]`<br>
Returns true if Pheonix Feather is available.

adventure.isWall(vector) `[adventure: is wall type: vector(2d)]`<br>
Returns true if the tile in the specified position is Wall.

adventure.isBomb(vector) `[adventure: is bomb type: vector(2d)]`<br>
Returns true if the tile in the specified position is Bomb.

adventure.isEnemy(vector) `[adventure: is enemy type: vector(2d)]`<br>
Returns true if the tile in the specified position has an enemy.

adventure.isCompleted(vector) `[adventure: is room completed: type: vector(2d)]`<br>
Returns true if the room at the specified position is completed **only** if you have map and compass unlocked.

adventure.hasItem("item name") `[adventure: has item type: string]`<br>
Returns true if the item with id `item name` is unlocked.

active("machine name") `[factory: is processing type: string]`<br>
Returns true if the machine with id `machine name` is currently processing items.

museum.preference("element name") `[museum: preference type: string]`<br>
Returns the current market preference for the element with id `element name`.

museum.isSlotLocked(offer Slot) `[museum: market lock type: int]`<br>
Returns the lock state of market slot `offer Slot`.

## Atomic functions

An atomic function is an action with an execution budget of 0.

goto(line number) `[basic: goto type: int]`<br>
Jumps to specified `line number` of the script. Line 1 is the first action in your script.<br>
Any number bellow 1 is treated as 1, any number above your actions count will terminate the script.

gotoif(line number, condition) `[basic: goto-if type: int, type: bool]`<br>
Same as a goto() but if your condition is false it continues to the next line instead of jumping to the line number.

global.`data_type`.set("variable name", value) `[global: set (`data_type`) type: string, type: `data_type`]`<br>
Assigns the inputed `value` inside the global variable `variable name`.

global.unset("variable name") `[global: unset type: string]`<br>
Deletes the global variable with the name `variable name`.

local.`data_type`.set("variable name", value) `[local: set (`data_type`) type: string, type: `data_type`]`<br>
Assigns the inputed `valuse` inside of the local variable `variable name`.

local.unset("variable name") `[local: unset type: string]`<br>
Deletes the local variable with the name `variable name`.

type: bool<br>
look at the functions in conditions

type: double<br>
arithmetic.double(value1, "operation", value2) `[arithmetic type:double, type:string, type:double]`<br>
Performs arithmetic on the inputed values.<br>
Permited operations are:
- `+` addition
- `-` subtraction
- `*` multiplication
- `/` division
- `%` `mod` modulo
- `^` `pow` power
- `//` `log` logarithm<br>
a // b = log base b of a

const.e() `[constant: e]`<br>
Returns the constant e = 2.7182818284590452.

const.pi() `[constant: pi]`<br>
Returns the constant PI = 3.1415926535897931.

i2d(val) `[convert: int type: int]`<br>
Converts the integer `val` into a double.

s2d(val, fallback) `[convert: string type: string, type: double]`<br>
Tries to convert `val` into a double value. If unsucessful, it returns the value in `fallback` instead.

disable.cost("element") `[era: disable cost type: string]`<br>
Returns the xp cost of the upgrade that disables the era powers of enemies with element id `element`. Returns -1 if outside of Tower Testing or if the upgrade cannot be disabled, it's either already disabled or it's not in the curent region.

count("item name", tier) `[factory: item count type: string, type: int]`<br>
Returns the total amount of items with id `item name` of tier `tier` from the inventory of the factory.

machine.item.count("machine name") `[factory: machine input count type: string]`<br>
Returns the total amount of items currently inside of the factory machine with id `machine name`.

era() `[game: era]`<br>
Returns the current era during Tower Testing or 0 if Tower Testing is not active.

fixedWavesPerInterval() `[game: fixed waves per interval]`<br>
Returns the current amount of fixed waves per interval as seen in the stats menu during Tower Testing or 0 if Tower Testing is not active.

infinity() `[game: infinity]`<br>
Returns the current infinity during Tower Testing or 0 if Tower Testing is not active.

resource("resource name") `[game: resource type: string]`<br>
Returns the amount of resources with id `resource name` you have. Returns 0 if `resource name` is not a valid id.

wave() `[game: wave]`<br>
Returns the current wave during Tower Testing or 0 if Tower Testing is not active.

waveAcceleration() `[game: wave acceleration]`<br>
Returns the current wave acceleration factor.

xp() `[game: xp]`<br>
Returns the current amount of Tower Testing experience or 0 if Tower Testing is not active.

global.double.get("var name") `[global: get(double) type: string]`<br>
Returns the value of the global variable `var name`.

highscore.era("region", difficulty") `[highscore: era type: string, type: string]`<br>
Returns the era record of region `region` on difficulty `difficulty`.

highscore.infinity("region", difficulty") `[highscore: infinity type: string, type: string]`<br>
Returns the infinity record of region `region` on difficulty `difficulty`.

highscore.wave("region", difficulty") `[highscore: wave type: string, type: string]`<br>
Returns the wave record of region `region` on difficulty `difficulty`.

disable.inf.cost() `[infinity: secure module cost]`<br>
Returns the amount of Tower Testing xp required in order to secure/disable a module during the infinity phase.

local.double.get("var name") `[local: get (double) type: string]`<br>
Returns the value of the local variable `var name`.

acos(val) `[math: acos type: double]`<br>
returns the inverse cosine (in radians) of the number `val`.

asin(val) `[math: asin type: double]`<br>
returns the inverse sine (in radians) of the number `val`.

atan(val) `[math: atan type: double]`<br>
returns the inverse tangent (in radians) of the number `val`.

atan2(vector) `[math: atan2 type: vector(2d)]`<br>
Returns the angle in the plane (in radians) between the positive x-axis and the ray from (0.0) to the point `vector`.

ceil(val) `[math: ceiling type: double]`<br>
Rounds the given number up to the closest integer. ceil(3.2) = 4.0

cos(val) `[math: cos type: double]`<br>
Returns the cosine of the number `val`.

floor(val) `[math: floor type: double]`<br>
Rounds the given number down to the closest intger. floor(2.9) = 2.0

round(val) `[math: round type: double]`<br>
Rounds the given number to the closest integer. round(3.2) = 3, round(1.6) = 2

sin(val) `[math: sin type: double]`<br>
Returns the sine of the number `val`.

tan(val) `[math: tan type: double]`<br>
Returns the tangent of the number `val`.

max(val_1, val_2) `[max: double]`

## Fundemental functions

