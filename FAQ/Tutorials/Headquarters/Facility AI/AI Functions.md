If you are here to understand Facility AI, there's a separate post for [Facility AI](Facility%20AI.md)<br>
If you are not here to understand a specific function in more detail, please go to [Facility AI Scripting](Facility%20AI%20Scripting.md) for information on writing an AI

# AI Functions

AI Functions are blocks used when writing scripts.<br>
This is a list of all of them, separated according to the function type

For space, I've created the groups `data_type`, `buildings`, `factory_machines`, `adventure_entities`, `museum_storage`, `resources`, `elements`, `digits` and `letters`. When you see these, just know that the specified action works for for all items in its coresponding list:

`data_type` = `bool`, `double`, `int`, `string`, `vector`

`buildings` = "arcade", "construction firm", "factory", "headquarters", "laboratory", "mine", "museum", "power plant", "shipyard", "statue of cubos", "trading post", "workshop"

`factory_machines` = "oven", "assembler", "refinery", "crusher", "cutter", "presser", "mixer", "shaper", "boiler"

`adventure_entities` = "Chest", "Bomb", "Rock", "Door", "Enemy", "Elite", "Mimic"

`museum_storage` = "inventory", "loadout", "combinator", "cuboscube"

`resources` = "gameTokens", "town.resources", "gems", "gems.exotic", "powerplant.resources", "mine.resources", "factory.resources", "headquarters.resources", "arcade.resources", "laboratory.resources", "shipyard.resources", "tradingpost.resources", "workshop.resources", "museum.resources", "constructionFirm.resources", "statueofcubos.resources", "halloween.pumpkins", "halloween.souls", "halloween.blood", "christmas.cookies", "christmas.presents", "christmas.reindeers.trained", "christmas.reindeers.milk", "christmas.reindeers.raw", "christmas.milk", "christmas.trees", "christmas.wrappings", "christmas.toys", "christmas.candy", "time.offline"

`elements` = "fire", "water", "earth", "air", "nature", "light", "darkness", "electricity", "universal", "neutral"

`digits` = `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`

`letters` = `a`, `b`, `c`, `d`, `e`, `f`, `g`, `h`, `i`, `j`, `k`, `l`, `m`, `n`, `o`, `p`, `q`, `r`, `s`, `t`, `u`, `v`, `w`, `x`, `y`, `z`

The functions are written in the [External AI Editor](https://d0sboots.github.io/perfect-tower/) format first, and then written in the internal editor format in `[square brackets]`

There are 4 types of functions:

- [Impulse functions](#impulse-functions)
- [Conditional functions](#conditional-functions)
- [Atomic functions](#atomic-functions)
- [Fundamental functions](#fundamental-functions)

This post is within its own subject on my [Compendium faq posts](AI%20Functions.md), where you can find the data types and functions in their own separate subjects.

## Impulse functions

An impulse lets you activate your script by performing an action.<br>
You cannot trigger an impulse if the AI Overlay is inactive.

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

key._digits_() `[impulse key: `_digits_`]`<br>
activate the script when you press the respective number key.

key._letters_() `[impulse key: `_letters_`]`<br>
activate the script when you press the respective letter key.

## Conditional functions

A condition is computed by the script before executing any actions.<br>
If any of the conditions returns false, the script will terminate without execution.

There is a bug in how conditions handle script termination. If a script calls another script using [executesync()](#fundemental-functions), and the called script has a false condition, the called script will terminate itself. However, the calling script incorrectly continues to treat the called script as still running.

## Permited operators

### Boolean

- `==`, `=` means equal
- `!=` means not equal
- `&&`, `&` means and
- `||`, `|` means or

### Int/Double

- `==`, `=` means equal
- `!=` means not equal
- `<` means smaller than
- `<=` means smaller or equal than
- `>` means larger than
- `>=` means larger or equal than

### String

- `==`, `=` means equal
- `!=` means not equal

## Conditions

Subject is isolated in the section [R data type bool](./Data%20Types/Type%20Bool.md).<br>
All conditions are the same values as [R type: bool](#type-bool)

comparison.*data_type*(*data_type*, "operator", *data_type*)
`[comparison: `*data_type*`type: `*data_type*`, type: string, type: `*data_type*`]`<br>
Compares two values of the same *data_type* (excluding vector) based on the selected operator.

External editor specification.<br>
comparison.*data_type*(*data_type*, "operator", *data_type*) is long-form for c.*data_type*, where data_type in this context means:
```
c.b = comparison.bool
c.d = comparison.double
c.i = comparison.int
c.s = comparison.string
```
I recommend using the long-form for code clarity when you use this primitive function.<br>
arithmetic.double(value1, "operation", value2) is a primitive.<br>
Primitive operations do not get pre-computed when exporting the code.
```
var1 = arithmetic.bool(true, "==", true) ; after export var1 = true == true
var2 = true == true ; after export var2 = true
```

When in the form that gets pre-computed, you lose the `=` comparison operator.
```
var1 = comparison.bool(true, "=", true) ; valid syntax
var2 = true = true ; syntax error.
```


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

```
contains("foo", "oo") → true: "oo" is part of "foo".
contains("foo", "foo") → true: "foo" matches "foo" entirely.
contains("foo", "fooo") → false: "fooo" exceeds the length of "foo".
contains("foo", "a") → false: "a" is not part of "foo".

contains("", "") → true: an empty string contains an empty string
contains("foo", "") → true: An empty string is considered part of a string.
contains("", "foo") → false: an empty string does not contain any characters.
```

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
Returns true if the game is currently paused during Tower Testing via the Pause button. Returns false if outside of towertesting or if the game of towertesting is unpaused.

isopen("town window") `[town: window open type: string]`<br>
Returns true if the inputed [town window](#fundemental-functions) is active and visible on the screen.

anyopen() `[town: any window open]`<br>
Returns true if any window or menu in town is open.

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

An atomic function is an action that consumes 0 from your execution budget.

goto(line number) `[basic: goto type: int]`<br>
Jumps to specified `line number` of the script. Line 1 is the first action in your script.<br>
Any number bellow 1 is treated as 1, any number above your actions count will terminate the script.

gotoif(line number, condition) `[basic: goto-if type: int, type: bool]`<br>
Same as a goto() but if your condition is false it continues to the next line instead of jumping to the line number.

global.*data_type*.set("variable name", value) `[global: set (`*data_type*`) type: string, type: `*data_type*`]`<br>
Assigns the inputed `value` inside the global variable `variable name`.

global.unset("variable name") `[global: unset type: string]`<br>
Deletes the global variable with the name `variable name`. Note that unsetting a global variable will have strange side effects to the global values overlay.

local.*data_type*.set("variable name", value) `[local: set (`*data_type*`) type: string, type: `*data_type*`]`<br>
Assigns the inputed `valuse` inside of the local variable `variable name`.

local.unset("variable name") `[local: unset type: string]`<br>
Deletes the local variable with the name `variable name`.


External Editor syntactic sugar.<br>
The `line number` inside of goto and gotoif can be replaced with a label.<br>
A label is an identifier that gets computed to the line number corresponding to the position in your code.<br>
This is defined as a string that can contain any letter, number, `_` or `.` inside of it and ends once you place a `:` in the string.<br>
The first character in a label can not be a number or a `.`.

```
goto(0)
; is equivalent to
top:
goto(top)
```

### type: double

Subject is isolated in the section [R Data Type double](./Data%20Types/Type%20Double.md).

A double is any value between -1.7976931348623157E+308 to 1.7976931348623157E+308.

External Editor syntactic sugar.<br>
:const double `var_name` <double_value><br>
Defines a variable with the name "var_name" that can hold the given double value.<br>
Since this is a const definition, you can not assign a value to this after it's been defined.

The value of a const definition cannot be an expression.

:global double `var_name`<br>
Defines a variable with the name "var_name".<br>
This shortens the assignment and retrieval expressions of the global variable called `var_name`.

```
:global double test
global.double.set("test", global.double.get("test"))
; is the long form of
test = test
```

:local double `var_name`<br>
Is the same as :global bool `var_name` but instead of a global variable, this defines a local variable.

arithmetic.double(value1, "operation", value2) `[arithmetic type: double, type: string, type: double]`<br>
Performs arithmetic on the inputed values.<br>
Permited operations are:

- `^` `pow` power
- `//` `log` logarithm<br>
  a // b = log base b of a
- `*` `x` multiplication
- `/` `:` division
- `%` `mod` modulo
- `+` addition
- `-` subtraction

External Editor specifications:<br>
arithmetic.double is long-form for a.d(). The syntax is the same, however this is shorter.<br>
I recommend using the long-form for code clarity when you use this primitive function.<br>
arithmetic.double(value1, "operation", value2) is a primitive.<br>
Primitive operations do not get pre-computed when exporting the code.
```
var1 = arithmetic.double(1.0, "+", 1.0) ; after export var1 = 1.0 + 1.0
var2 = 1.0 + 1.0 ; after export var2 = 2.0
```
Additionally, when assigning a variable, you can use a prefix operation to shorten the expression.
```
var1 = var1 + 1.0
var2 += 1.0
; both get compiled to the same operation
```
However, assignment prefixes are performed last
```
var2 = var2 * 2.0 + 1.0
; can not be converted to
var2 *= 2.0 + 1.0 ; translates to var2 = var2 * 3.0 because it's treated as var2 = var2 * (2.0 + 1.0)
```

When in a form that gets pre-computed, you lose the operators `pow`, `log`, `x`, `:` and `mod`
```
var1 = arithmetic.double(2.0, "x", 5.0) ; valid syntax
var2 = 2.0 x 5.0 ; invalid syntax
```

const.e() `[constant: e]`<br>
Returns the constant e = 2.7182818284590452.

const.pi() `[constant: pi]`<br>
Returns the constant PI = 3.1415926535897931.

i2d(val) `[convert: double type: int]`<br>
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
Returns the current era count during Tower Testing or 0.0 if Tower Testing is inactive.

fixedWavesPerInterval() `[game: fixed waves per interval]`<br>
Returns the current amount of fixed waves per interval as seen in the stats menu during Tower Testing or 0 if Tower Testing is not active.

infinity() `[game: infinity]`<br>
Returns the current infinity count during Tower Testing or 0 if Tower Testing is not active.

resource("resource name") `[game: resource type: string]`<br>
Returns the amount of resources with id `resource name` you have. Returns 0 if `resource name` is not a valid id.<br>
Valid resource ID's are defined at the [top of file](#ai-functions)

wave() `[game: wave]`<br>
Returns the current wave count during Tower Testing or 0 if Tower Testing is not active.

waveAcceleration() `[game: wave acceleration]`<br>
Returns the current wave acceleration factor.

xp() `[game: xp]`<br>
Returns the current amount of Tower Testing experience or 0 if Tower Testing is not active.

global.double.get("var name") `[global: get(double) type: string]`<br>
Returns the value of the global variable `var name`.<br>

highscore.era("region", difficulty") `[highscore: era type: string, type: string]`<br>
Returns the era record of region with ID `region` on difficulty with ID `difficulty`.

highscore.infinity("region", difficulty") `[highscore: infinity type: string, type: string]`<br>
Returns the infinity record of region with ID `region` on difficulty with ID `difficulty`.

highscore.wave("region", difficulty") `[highscore: wave type: string, type: string]`<br>
Returns the wave record of region with ID `region` on difficulty with ID `difficulty`.

disable.inf.cost() `[infinity: secure module cost]`<br>
Returns the amount of Tower Testing xp required in order to secure a module during the infinity phase.

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

max(val_1, val_2) `[max: double type: double, type: double]`<br>
Returns the maximum value between val_1 and val_2.

min(val_1, val_2) `[min: double type: double, type: double]`<br>
Returns the minimum value between val_1 and val_2.

museum.timer() `[museum: market timer]`<br>
Returns the current market time until the next refresh of the offshore marker in museum.

rnd(min_val, max_val) `[random: double type: double type: double]`<br>
Returns a random value between min_val and max_val, including min_val and max_val.<br>
If max_val is smaller than min_val, min_val will always return.

height.d() `[screen: height]`<br>
Returns the height of the game window in pixels.

width.d() `[screen: width]`<br>
Returns the width of the game window in pixels.

if(cond, true_val, false_val) `[ternary: double type: bool, type: double, type: double]`<br>
Computes the condition inputed in `cond` and returns `true_val` if it's true and `false_val` if it's false.<br>
The branch that doesn't return is not computed.

time.delta() `[time: delta]`<br>
Returns the total time in seconds between the current frame and the last frame. Pausing or accelerating the game affects this value.

time.scale() `[time: scale]`<br>
Returns the factor at which the time is currently accelerated.<br>

- 0 if the game is paused
- 1 if the game runs at normal speed
- 2 if the game runs at 2x speed<br>
  and so on

time.unscaled() `[time: unscaled delta]`<br>
Returns the total time in seconds between the current frame and the previous frame. This value is neither affected by pausing nor accelerating the game.

now() `[timestamp: now]`<br>
Returns the current local time in ticks representing the time from midnight, january 1st, 0001 up until now.

utcnow() `[timestamp: utc now]`<br>
Returns the current UTC time in ticks representing the time from midnight, january 1st, 0001 up until now.

tower.range() `[tower: attack range]`<br>
Returns the towers current attack range. Default attack range without any modules or buffs is 18. Returns 0.0 if in the statue of cubos boss `Dodecai`, in a game of `perfect space` or outside of Tower Testing.

energy(percent) `[tower: energy type: bool]`<br>
Returns the current energy of the tower or 0.0 if the tower does not exist. Value is returned as a percentage from 0.0 to 1.0 if the value in `percent` is true.

energy.regen() `[tower: energy regeneration]`<br>
Returns the current energy regeneration of the tower or 0.0 if the tower does not exist.

health(percent) `[tower: health type: bool]`<br>
Returns the current health of the tower or 0.0 if the tower does not exist. Value is returned as a percentage from 0.0 to 1.0 if the value in `percent` is true. The boss `Dodecai` always returns the value 0.0

health.regen() `[tower: health regeneration]`<br>
Returns the current health regeneration of the tower or 0.0 if the tower is either dead or does not exist.

energy.max() `[tower: max. energy]`<br>
Returns the maximum energy of the tower or 0.0 if the tower does not exist.

health.max() `[tower: max. health]`<br>
Returns the maximum hitpoints of the tower or 0 if the tower is either dead or does not exist.

shield.max() `[tower: max. shield]`<br>
Returns the maximum shieldpoints of the tower or 0 if the tower is either dead or does not exist.

cooldown(skill) `[tower: module cooldown type: int]`<br>
Returns the remaining cooldown of the active module at slot 1 in seconds. Slot 1 refers to the first module in the active modules list.<br>
Returns -1 if the value of `skill` does not reprezent the index of a valid active module.

shield(percent) `[tower: shield type: bool]`<br>
Returns the current shieldpoints of the tower or 0 if the tower is dead or does not exist. Value is returned as a percentage from 0.0 to 1.0 if the value in `percent` is true.

ui.size() `[ui: size]`<br>
Returns the value of the UI size option from the options menu as a double value ranging from 0.5 (50%) to 1.0 (100%).<br>
There is a bug that prevents this value from updating when the Dynamic UI Scaling option is on.

x(vector value) `[vector2: x type: vector(2d)]`<br>
Returns the x coordinate of the inputed `vector value`.

y(vector value) `[vector2: y type: vector(2d)]`<br>
Returns the y coordinate of the inputed `vector value`.

### type: int

Subject is isolated in the section [R data type int](./Data%20Types/Type%20Int.md).

An integer value is any number between -2147483648 to 2147483647.

External Editor syntactic sugar.<br>
:const int `var_name` <int_value><br>
Defines a variable with the name "var_name" that can hold the given integer value.<br>
Since this is a const definition, you can not assign a value to this variable after it's been defined.

The value of a const definition cannot be an expression.

:global int `var_name`<br>
Defines a variable with the name "var_name".<br>
This shortens the assignment and retrieval of the variable.
```
:global int test
global.int.set("test", global.int.get("test"))
; is long form of
test = test
```

:local int `var_name`<br>
Is the same as :global int `var_name` but instead of a global variable, this defines a local variable.

adventure.armor() `[adventure: armor]`<br>
Returns the ammount of armor the player has in the game of adventure.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.

adventure.bombs() `[adventure: bombs]`<br>
Returns the ammount of bombs the player has in the game of adventure.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.

adventure.countEntities("adventure_entities") `[adventure: count entities type: string]`<br>
Returns the ammount of entities in the current room of the inputed `adventure_entities` entity type.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.<br>
Valid adventure ID's are defined at the [top of file](#ai-functions)

adventure.emeralds() `[adventure: emeralds]`<br>
Returns the ammount of emeralds the player has in the game of adventure.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.

adventure.goldenHearts() `[adventure: golden hearts]`<br>
Returns the number of golden hearts the player has collected in the game of adventure.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.

adventure.hearts() `[adventure: hearts]`<br>
Returns the ammount of hit points the player has in the game of adventure.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.

adventure.keys() `[adventure: keys]`<br>
Returns the number of keys the player has collected in the game of adventure.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.

adventure.mana() `[adventure: mana]`<br>
Returns the ammount of mana the player has in the game of adventure.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.

adventure.manaArmor() `[adventure: mana armor]`<br>
Returns the ammount of mana armor the player has in the game of adventure.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.

adventure.swords() `[adventure: swords]`<br>
Returns the ammount of damage the player can deal in adventure.<br>
If the adventure tab in the arcade isn't in focus, this will return 0.

arithmetic.int(value1, "operation", value2) `[arithmetic type: int, type: string, type: double]`<br>
Performs an arithmetic operation on the inputed values.<br>
Permited operators are:
- `^` `pow` power
- `//` `log` logarithm<br>
  a // b = log base b of a
- `*` `x` multiplication
- `/` `:` division
- `%` `mod` modulo
- `+` addition
- `-` subtraction

External Editor specifications:<br>
arithmetic.int is long-form for a.i(). The syntax is the same, however this is shorter.<br>
I recommend using the long-form for code clarity when you use this primitive function.<br>
arithmetic.int(value1, "operation", value2) is a primitive.<br>
Primitive operations do not get pre-computed when exporting the code.
```
var1 = arithmetic.int(1, "+", 1) ; after export var1 = 1 + 1
var2 = 1 + 1 ; after export var2 = 2
```
Additionally, when assigning a variable, you can use a prefix operation to shorten the expression.
```
var1 = var1 + 1
var2 += 1
; both get compiled to the same operation
```
However, assignment prefixes are performed last
```
var2 = var2 * 2 + 1
; can not be converted to
var2 *= 2 + 1 ; translates to var2 = var2 * 3 because it's treated as var2 = var2 * (2 + 1)
```

In a form that gets pre-computed, you lose the operators `pow`, `log`, `x`, `:` and `mod`.
```
var1 = arithmetic.int(10, "pow", 2) ; valid syntax
var2 = 10 pow 2 ; syntax error
```

budget() `[basic: remaining budget]`<br>
Returns the ammount of execution budget the script has left durring its execution.

d2i(val) `[convert: int type: double]`<br>
Converts the double `val` into an integer. 

s2i(val, fallback) `[convert: string type: string, type: int]`<br>
Tries to convert the string `val` into an integer value. If unsucessful, it returns the value in `fallback` instead.

active.count() `[game: active module count]`<br>
Returns the total number of active modules in the currently active blueprint of the tower. Returns 0 outside of towertesting.

active.index("module id") `[game: active module index type: string]`<br>
Returns the index of the active module with the inputed id inside the active skills list. If the module is not inside the list or towertesting is not active then it returns 0.

enemies() `[game: number of enemies]`<br>
Returns the number of enemy units which are currently present on the map. Returns 0 if towertesting is not active or if the game of towertesting has been reset.

max(val1, val2) `[max: int]`<br>
Returns the larger number between val1 and val2.

min(val1, val2) `[min: int]`<br>
Returns the smaller number between val1 and val2.

clusters() `[mine: clusters]`<br>
Returns the total amount of asteroid clusters currently in the list or 0 if the second floor of the mine hasn't been unlocked yet or if the mine isn't open.

museum.freeSlots("museum_storage") `[museum: free slots type: string]`<br>
Returns the number of free slots in the requested `museum_storage`. If outside of the museum, it returns -1<br>
Valid ID's are found at [top of file](#ai-functions).

museum.slotTier(offerSlot) `[museum: market tier type: int]`<br>
Returns the stone tier from slot `offerSlot` within the offshore market.<br>
Returns 0 if the slot hasn't been unlocked yet or if it's called while not in the museum.

museum.maxTier("element") `[museum: max tier type: string]`<br>
Returns the maximum tier of the inputed element.<br>
Returns -1 if it's called while not in the museum or if the element ID is invalid.<br>
Valid ID's are defined at [top of tile](#ai-functions), with the only exception being element "neutral".

tier("museum_storage", slot) `[museum: powerstone tier type: string, type: int]`<br>
Returns the tier of the power stone in the selected museum_storage and in the slot.<br>
Returns -1 if called outside of the museum or if the slot is unoccupied.<br>
Valid ID's are found at [top of file](#ai-functions).

museum.preferredTier() `[museum: preferred tier]`<br>
Returns the currently set preferred market tier.<br>
Returns -1 if called outside of the museum or if the offshore market is locked.

museum.trashTier(trashSlot) `[museum: trash tier type: int]`<br>
Returns the powerstones tier from the requested trash slot.<br>
Returns -1 if outside of the museum or if the requested trashSlot is empty.

rnd(minVal, maxVal) `[random: int]`<br>
Returns a random value between minVal and maxVal, both inclusive. If maxVal is smaller than minVal, it returns minVal.<br>
This always triggers a call to the internal rng.

height() `[screen: height]`<br>
Returns the height of the screen in pixels.

width() `[screen: width]`<br>
Returns the width of the screen in pixels.

index(str, substr, offset) `[string: index of type: string, type: string, type: int]`<br>
Returns the index of the first occurrence of string `substr` within string `str`. Search starts at index `offset` where 0 represents the beginning of the string.<br>
Returns -1 if substr could not be found in str at the specified offset.<br>
Note that substr is case sensitive, so `T` is not the same as `t`.
```
index("Text", "", 0) = -1
index("Text", "T", 0) = 0
index("Text", "T", 1) = -1
```

len(str) `[string: length type: string]`<br>
Returns the number of characters in the string `str`.<br>
An empty string returns 0.

if(cond, valTrue, valFalse) `[ternary: int type: bool, type: int, type: int]`<br>
If the condition is true, returns the value in valTrue, otherwise, returns the value of valFalse.
```
if(true, 1, 0) = 1
if(false, 1, 0) = 0
```

time.frame() `[time: frame]`<br>
Returns the number of frames that have occoured since starting the game.<br>
Do note that this value returns back to 0 once you exit and re-enter a save.

negative() `[tower: negative buffs]`<br>
Returns the total ammount of negative buffs currently present on the tower or 0 if the tower has no negative buffs or does not exist.<br>
Note that this only counts negative buffs, this does not count positive buffs.

offerCount() `[tradingpost: offer count]`<br>
Returns the total amount of available offers in the trading post.<br>
While outside of the tradingpost, this does not get set to 0, but it cannot detect if the number of offers has changed.

worker.group(index) `[worker: group]`<br>
Returns the group of the worker at the requested index, where 0 is the first worker in the list.<br>
If you go to settings -> graphics and set color blind mode to no shader, you can see the number correlating to the worker group on the color cube.

### type: string

Subject is isolated in the section [R data type string](./Data%20Types/Type%20String.md).

External Editor syntactic sugar.<br>
A string value is a set of characters, numbers and special characters that must be contained in a pair of single quotes `''` or double quotes `""`.<br>
```
"test'" and 'test"' are valid
; however
"test"" and 'test'' are invalid
```

:const string `var_name` <string_value><br>
Defines a variable with the name "var_name" that can hold the given string value.<br>
Since this is a const definition, you can not assign a value to this variable after it's been defined.

The value of a const definition cannot be an expression.

:global string `var_name`<br>
Defines a variable with the name "var_name".<br>
This shortens the assignment and retrieval of the variable.
```
:global string test
global.string.set("test", global.string.get("test"))
; is long form of
test = test
```

:local string `var_name`<br>
Is the same as :global string `var_name` but instead of a global variable, this defines a local variable.<br>

adventure.entityType(position) `[adventure: get entity type type: vector(2d)]`<br>
Returns the entity type of the tile corresponding to the inputed position.<br>
The returned value is of `adventure_entities` and also returns an empty string if the entity is a wall or an empty tile.

concat(str, str) `[concat type: string, type: string]`<br>
Chains the two given strings together.<br>
External editor specifications.<br>
concat(str, str) is a primitive that doesn't pre-computed. Its short-form version is `str . str`.
```
var1 = concat("test", "test") ; gets exported as var1 = "test" . "test"
var2 = "test" . "test" ; gets exported as var2 = "testtest"
```

d2s(val) `[convert: double type: double]`<br>
Converts the inputed double to a string.

i2s(val) `[convert: int type: int]`<br>
Converts the inputed integer to a string.

factory.find(name) `[factory: find id type: string]`<br>
Returns the correct item ID of the item with the closest match to the inputed name (ignores case-sensitivity). This function is very slow. Avoid using it in performance critical sections.<br>
This function has been made obselete ever since the factory drop-downs were introduced.

machine.item(factory_machines) `[factory: machine input type: string]`<br>
Returns the id of the item currently inside the factory machine with the inputed ID.<br>
Accepted ID's are written in factory_machines, found at the [top of file](#ai-functions).

active.id(index) `[game: active module id type: int]`<br>
Returns the id of the active module in slot `index` in the active modules list where 1 refers to the first module in the list. Returns an empty string if the slot index is invalid or towertesting is not active.

museum.slotElement(offerSlot) `[museum: market element type: int]`<br>
Returns the element from the requested slot in the offshore market. Returns an empty string if there's no element.

element(museum_storage, slot) `[museum: powerstone element type: string, type: int]`<br>
Returns the PowerStone element of the requested slot within the desired museum_storage.<br>
Valid ID's are defined at the [top of file](#ai-functions).

museum.trashElement(trashSlot) `[museum: trash element type: int]`<br>
Returns the PowerStone element in the requested trashSlot.

impulse() `[script: triggered impulse]`<br>
Returns the ID of the impulse that triggered this script instance. If the script was triggered by another script then this function will return the name of that script, including the package if present.

software.find(name) `[software: find id type: string]`<br>
Returns the correct software id of the software with the closest match to the inputed name (ignores case-sensitivity). This function is very slow. Avoid using it in performance critical sections.<br>
As with factory.find(name), this function has been made obselete ever since the software drop-downs were introduced.

lower(str) `[string: to lower]`<br>
Converts the inputed string into its lowercase variant.

upper(str) `[string: to upper]`<br>
Converts the inputed string to its uppercase variant.

sub(str, index, length) `[substring type: string, type: int, type: int]`<br>
Returns a part of the string `str`, starting from position `index` (0 = first character) and then going a total of `length` steps to the right.
```
sub("Test", 0, 3) = "Tes"
sub("Test", 1, 3) = "est"
sub("Test", 0, 4) = "Test"
sub("Test", 0, 0) = ""
```

if(cond, valTrue, valFalse) `[ternary: string type: bool, type: string, type: string]`<br>
If the condition is true, returns `valTrue`, otherwise, returns `valFalse`.
```
if(true, "foo", "FOO") = "foo"
if(false, "foo", "FOO") = "FOO"
```

worker.name(index) `[worker: name type: int]`<br>
Returns the name of the worker at index `index` (0 is the first worker in the list).

worker.task(workerName) `[worker: task id type: string]`<br>
Returns the id of the current task of the first worker with the name `workerName`. Returns an empty string if no worker with the given name exists or if there has been no task assigned.

### type: bool

All boolean values are [conditional functions](#conditional-functions).<br>
Subject is isolated in the section [R Data Type bool](./Data%20Types/Type%20Bool.md).

External Editor syntactic sugar.<br>
:const bool `var_name` true/false<br>
Defines a variable with the name "var_name" that can hold the values true or false.<br>
Since this is a const definition, you can not assign a value to this variable after it's been defined.

The value of a const definition cannot be an expression.

:global bool `var_name`<br>
Defines a variable with the name "var_name".<br>
This shortens the assignment and retrieval of the variable.
```
:global bool test
global.bool.set("test", global.bool.get("test"))
; is the long form of
test = test
```

:local bool `var_name`<br>
Is the same as :global bool `var_name` but instead of a global variable this defines a local variable

### type: vector(2d)

Subject is isolated in the section [R data type vector (2D)](./Data%20Types/Type%20Vector%20(2D).md).

External Editor syntactic sugar.<br>
A vector value is defined as `vec(value_x, value_y)`.<br>
while value_x and value_y are categorised as double values, they are of data type float, so performing the same operation between 2 double values and 2 vector values can lead to different results.

:const vector `var_name` <vector_value><br>
Defines a variable with the name "var_name" that can hold the given vector value.<br>
Since this is a const definition, you can not assign a value to this variable after it's been defined.

The value of a const definition cannot be an expression.

:global vector `var_name`<br>
Defines a variable with the name "var_name".<br>
This shortens the assignment and retrieval of the variable.
```
:global vector test
global.vec2.set("test", global.vec2.get("test"))
; is long form of
test = test
```

:local vector `var_name`<br>
Is the same as :global vector `var_name` but instead of a global variable, this defines a local variable.

adventure.playerPos() `[adventure: player position]`<br>
Returns the players current position in Adventure.<br>
If the arcade is closed or the adventure tab in arcade is not in focus, this returns vec(0.0, 0.0).

adventure.roomCoords() `[adventure: room coordinates]`<br>
Returns the coordinates of the current room in Adventure.<br>
If the arcade is closed or the adventure tab in arcade is not in focus, this returns vec(0.0, 0.0).

arithmetic.vec2(val, "operation", val) `[arithmetic type: vector (2D), type: string, type: vector (2D)]`<br>
Performs arithmetic on the components of the 2 inputed values.<br>
Permited operators are:

- `*` multiplication
- `/` division
- `+` addition
- `-` subtraction

External Editor specifications:<br>
arithmetic.vec2 is long-form for a.v(). The syntax is the same, however this is shorter.<br>
I recommend using the long-form for code clarity when you use this primitive function.<br>
arithmetic.vec2(value1, "operation", value2) is a primitive.<br>
Primitive operations do not get pre-computed when exporting the code.
```
var1 = arithmetic.vec2(vec(1.0, 0.0), "+", vec(1.0, 0.0)) ; after export var1 = vec(1.0, 0.0) + vec(1.0, 0.0)
var2 = vec(1.0, 0.0) + vec(1.0, 0.0) ; after export var2 = vec(2.0, 0.0)
```
Additionally, when assigning a variable, you can use a prefix operation to shorten the expression.
```
var1 = var1 + vec(1.0, 0.0)
var2 += vec(1.0, 0.0)
; both get compiled to the same operation
```
However, assignment prefixes are performed last
```
var2 = var2 * vec(2.0, 1.0) + vec(1.0, 0.0)
; can not be converted to
var2 *= vec(2.0, 1.0) + vec(1.0, 0.0) ; translates to var2 = var2 * vec(3.0, 1.0) because it's treated as var2 = var2 * (vec(2.0, 1.0) + vec(1.0, 0.0))
```

mouse.position() `[mouse: position]`<br>
Returns the current position of the mouse cursor.

if(cond, valTrue, valFalse) `[ternary: vector (2d) type: bool, type: vector (2d), type: vector (2d)]`<br>
If cond is true, returns valTrue, otherwise returns valFalse.
```
if(true, vec(1.0, 1.0), vec(0.0, 0.0)) = vec(1.0, 1.0)
if(false, vec(1.0, 1.0), vec(0.0, 0.0)) = vec(0.0, 0.0)
```

vec(value_x, value_y) `[vector2: from coordinates type: double, type: double]`<br>
Returns a vector with the inputed value_x and value_y.<br>
External editor specifications:<br>
If either value_x or value_y can't be pre-computed, the export uses vector2: from coordinates, otherwise, it uses the simple vector (2D).

## Fundamental functions

A fundamental function is an action that consumes 100 budget from your execution budget.<br>
These are the actions used to interact with the game.

### General purpose

click(clickPosition) `[basic: click type: vector(2D)]`<br>
Performs a click in the inputed position. If that position has a button, it will interact with it.

slider(sliderPosition, slide) `[basic: slider type: vector(2D), type: double]`<br>
Sets the slider at position `sliderPosition` on the screen to `slide`. Where 0.0 is the leftmost and 1.0 is the rightmost end.

scrollbar(scrollbarPosition, horisontal, vertical) `[basic: scrollrect type: vector(2D), type: double, type: double]`<br>
Scrolls within the scrollable container at `scrollbarPosition` to `horisontal` and `vertical`. Where 0 is the left/lower end and 1 being the right/upper end.<br>
Using a negative value ignores the axis entirely.
```
scrollbar(vec(0.0),  1, -1) ; only scrolls horisontally
scrollbar(vec(0.0), -1,  1) ; only scrolls vertically
scrollbar(vec(0.0),  1,  1) ; scrolls both horisontally and vertically
```

wait(ammount) `[basic: wait type: double]`<br>
Waits for the inputed ammount of seconds.<br>
Inputting a negative value acts as tho you inputed 0.<br>
Inputting any non-0 value will consume the rest of your execution budget.

waituntil(cond) `[basic: wait until type: bool]`<br>
Waits for as long as the inputed condition `cond` is false.<br>
Inputting a true condition only consumes 100 budget, inputting a false condition consumes all of your budget.

waitwhile(cond) `[basic: wait while type: bool]`<br>
Waits for as long as the inputed condition `cond` is true.<br>
Inputting a false condition only consumes 100 budget, inputting a true condition consumes all of your budget.

waitframe() `[basic: wait frame]`<br>
Consumes all of your budget.

execute(script_name) `[basic: execute type: string]`<br>
Executes the script with the name script_name without the called script needing a user impulse.<br>
The executed script will not be able to run if its script conditions are not met.<br>
If execute() is used in a package, the scripts within the package will first be checked to see if they match the inputed script_name, if none of them do, the search will continue from the top of the scripts.<br>
When calling a script from a package that we're not in, script_name must also include the package_name, followed by the `:` marker and then the script_name.
```
execute("me") ; executes the script called me within my package first, if none is found, looks at the other scripts
execute("package:me") ; executes the script called "me" from the package called "package"
```

executesync(script_name) `[basic: execute (sync) type: string]`<br>
Equivalent to execute(script_name), however, execution is stopped until the script we called finishes its execution.
```
executesync("foo") ; execute the script called "foo" and wait for it to finish execution

:global string status
status = "finish" ; status will only get set to "finish" after script "foo: finishes execution
```
executesync(script_name) has a bug where, if the called script does not start execution because the conditions aren't met, executesync will continue to wait, indefinitely.<br>
If executesync does not find a valid script to execute, it will just consume 100 budget, however, if it does succeed, it will consume the rest of the budget and then consume an extra 100, leaving you with budget_cap - 100 left, where-as usually, you're left with budget_cap left.

stop(script_name) `[basic: stop type: string]`<br>
Stops the execution of all scripts and script instances which are named `script_name`.<br>
This action also clears the execution stack, which is what makes systems such as budget_exec work.

### UI

These can be used anywhere, like the [General purpose](#general-purpose) actions, but specialized for user interface.

These are for managing the user interface.<br>
canvas specific actions require the boots.dos ingame software to be unlocked and installed.

canvas.rect(where, size, color) `[canvas: draw rect type: vector(2d), type: vector(2d), type: string]`<br>
Function that's added by the software boots.d0s, which lets you draw on the canvas.<br>
Draws a square starting from the position specified in `where`, to the position correlating to `where` + `size`, of color `color`.<br>
The color is in hex code, and accepts the formats `#RGB`, `#RGBA`, `#RRGGBB` and `#RRGGBBAA`, representing the values Red Green Blue and Alpha (Opacity).

canvas.clear() `[canvas: clear]`<br>
Function that's added by the software boots.d0s, which lets you clear the canvas.<br>
Clears the canvas that's been drawn on through canvas.rect

create(windowID, windowType) `[window: create type: string, type: string]`<br>
Creates a window with the unique identifier `windowID` (used to address the new instance) of type `windowType` (window name inside of windows list).

text.set(windowID, textElementId, value) `[window: set text type: string, type: string, type: string]`<br>
Sets the content inside the window with the ID `windowID` of the text label with the id `textElementID` to `value`.

sprite.set(windowID, ElementID, sprite) `[window: set sprite type: string, type: string, type: string]`<br>
Sets the sprite inside the window with the id `windowID` of the button/image with the id `elementID` to `sprite`.

visibility.set(windowID, isVisible) `[window: set visibility type: string, type: bool]`<br>
Set the window with id ``windowID` to visible if `isVisible` is true. Otherwise, the window will be hidden.

child.visibility.set(windowID, elementID, isVisible) `[window: set child visibility type: string, type: string, type: bool]`<br>
Set child with ID `elementID` of window `windowID` to visible if `isVisible` is true. Otherwise, it will be hidden.

position.set(windowID, position) `[window: set position type: string, type: vector (2D)]`<br>
Changed the position of the window with ID `windowID` to `position` based on the anchor of its root element. Per default, the anchor is set to the genter of the window and 0, 0 represents the center of the screen.

distroy(windowID) `[window: destroy type: string]`<br>
Destroys the window with the ID `windowID`.

destroy.all() `[window: destroy all]`<br>
Ddestroys all active windows.

### Tower Testing

The actions that only work in tower testing.

useinstant(spell_index) `[tower: use (instantly) type: int]`<br>
Uses the spell at slot `spell_index`, where slot 1 refers to the first skill.<br>
Entering an invalid slot will do nothing.<br>
If the spell at slot `spell_index` needs a position, useinstant will activate the spell, but you will need to click on the place to cast it.

useposition(spell_index, position) `[tower: use (position) type: int, type: vector(2D)]`<br>
Uses the spell at slot `spell_index`, where 1 refers to the first skill, at an offset of `position` of its current world position.<br>
Activate the spell and press f2 in order to get the position.

restart() `[tower: restart]`<br>
Restarts the current game of towertesting. Can only be executed after 1 second in the game has passed.<br>
restart() triggers the impulse game.newround(), so it can lead to duplication.<br>
restart() also sets enemies() to 0, which can't easily happen in endless mode, so it's a reliable way to detect if a restart has happened.

exit() `[tower: exit]`<br>
Exits the current game of towertesting and puts you back in town.

software.toggle(name, on) `[software: toggle type: string, type: bool]`<br>
Enables the software `name` if the condition `on` is true or disables it if the condition is false.

pause.set(pause) `[game: set pause type: bool]`<br>
Pauses towertesting if `pause` is true. Otherwise, it will unpause the game.

pause() `[game: pause]`<br>
equivalent to `pause.set(true)`.

unpause() `[game: unpause]`<br>
equivalent to `pause.set(false)`.

disable.era(element) `[era: disable power type: string]`<br>
Tries to disable the era powers of enemies of the inputed `element` by purchasing the according upgrade using xp.

upgrade.era(divider, ammount) `[era: upgrade divider type: string, type: int]`<br>
Attempts to upgrade the specified era divider by the inputed ammount by using xp.

disable.inf(moduleID) `[infinity: secure module type: string]`<br>
Attempts to secure the module with the specified `moduleID` to prevent enemies from mimicking it during the infinity phase.

### Town and workers

These can be used anywhere, like the [General purpose](#general-purpose) actions, but specialized for town and workers

open(building, open) `[town: open window type: string, type: bool]`<br>
Opens the `building` window if `open` is true, otherwise it will be closed. Opening or closing windows this way does not play the transition animation.

worker.toggleGroup(group) `[worker: toggle group type: int]`<br>
Toggles the group state of all workers in group `group`.

worker.pauseGroup(group, pause) `[worker: pause group type: int, type: bool]`<br>
Sets the paused state of all workers in group `group` to `pause`.

worker.toggleName(name) `[worker: toggle type: string]`<br>
Toggles the paused state of all workers with the name `name`.

worker.pauseName(name, pause) `[worker: pause type: string, type: bool]`<br>
Sets the paused state of all workers with the name `name` to `pause`

worker.assignGroup(task, subtask, group) `[worker: assign group type: string, type: int, type: int]`<br>
Assigns the task with id `task` and optional parameter `subtask` (0 is the leftmost) to all workers in group `group`.

worker.assignName(task, subtask, name) `[worker: assign type: string, type: int, type: string]`<br>
Assigns the task with id `task` and optional parameter `subtask` (0 is the leftmost) to all workers with the name `name`.

worker.setName(index, name) `[worker: set name type: int, type: string]`<br>
Sets the name of the worker at index `index` (0 is the first worker) to `name`.

worker.setGroup(index, group) `[worker: set group type: int, type: int]`<br>
Sets the group of the worker at index `index` (0 is the first worker) to the group with id `group`.

### Mine

dig(x, y) `[mine: dig type: int, type: int]`<br>
Digs up the tile at `x` and `y` of the currently selected resource in the mine with (0, 0) being the top left corner.<br>
Only works if the mine window is active.

newlayer() `[mine: new layer]`<br>
Generates a new later of the currently selected resources in the mine.<br>
Only works if the mine window is active.

tab(tab) `[mine: open tab type: int]`<br>
Opens the mining tab at position `tab`. Position 1 is the first tab (orage) and position 12 is the last tab (black).

remove(cluster) `[mine: delete cluster type: int]`<br>
Removes the asteroid cluster at list position `cluster` where 1 represents the first cluster in the list.

### Arcade

wheel.spin(wager) `[arcade: spin lucky wheel type: double]`<br>
Spin the lucky wheel with the given wager. Wager represents the number of recources to spend for the spin.

jumble.new(waget) `[arcade: jumble new game type: double]`<br>
Start a new game of jumble with the given wager.

jumble.stop() `[arcade: jumble stop]`<br>
Stop the current column in jumble.

adventure.move(direction) `[adventure: move type: vector(2d)]`<br>
Moves the player in the specified directions.<br>
You can only move left `(-1, 0)`, right `(1, 0)`, up `(0, 1)` or down `(0, -1)`. Any invalid direction will result in doing nothing.

adventure.wait() `[adventure: wait]`<br>
Skip the current turn.

adventure.placeBomb() `[adventure: place bomb]`<br>
Place a bomb on the current tile. If the current tile already has a bomb on it, it does nothing.

adventure.useSpell(spell) `[adventure: cast spell type: string]`<br>
Cast the specified spell.<br>
Valid spells are the strings `identifyRoom`, `manaArmor`. Inputing an invalid spell or not having the mana required for the spell will do nothing.<br>
Note that using a spell does use up your turn. So enemies will move while you use spells.

adventure.teleport(completedRoom) `[adventure: teleport type: vector(2d)]`<br>
Teleports you to the specified completed room.<br>
If the room you are currently in isn't cleared, the room you are teleporting to hasn't been completed or you don't have the mana to teleport, it does nothing.

adventure.buyMarketItem(item) `[adventure: buy market items type: string]`<br>
Buys the specified market item. Does nothing if you don't have the gems for it or if the `item` string is invalid.<br>
Valid item id's are: `eodArmor`, `thornsArmor`, `bootsPhasing`, `leechSword`, `impaler`, `manaReaver`, `hammer`, `holyBomb`, `bookSpells`

### Factory

craft(item, tier, ammount) `[factory: try craft type: string, type: int, type: double]`<br>
Tries to craft the requested item, of the specified tier. Does nothing if the item, of the specified tier doesn't exist or if you can't make the requested ammount.<br>
Valid item ID's are `chip.basic`, `chip.advanced`, `chip.hitech`, `chip.nano`, `chip.quantum`, `chip`, `hammer`, `sapling.rubber`, `sapling.void`, `dust.rainbow`, `cable.insulated`, `plate`, `motor`, `pump`, `block`, `plate.stack`, `lump`, `producer.town`, `producer.statueofcubos`, `producer.workshop`, `producer.shipyard`, `producer.laboratory`, `producer.constructionFirm`, `producer.mine`, `producer.powerplant`, `producer.arcade`, `producer.headquarters`, `producer.tradingpost`, `producer.museum`, `producer.factory`, `producer.exoticgems`, `producer.gems`, `booster.acceleration`, `booster.machines`, `booster.production.regular`, `booster.resource.drops`, `booster.trees`, `pumpkin.stack`, `pumpkin.producer`, `machine.oven`, `machine.assembler`, `machine.refinery`, `machine.crusher`, `machine.cutter`, `machine.presser`, `machine.mixer`, `machine.transportbelt`, `machine.shaper`, `machine.boiler`.

produce(item, tier, ammount, machine) `[factory: try produce type: string, type: int, type: double, type: string]`<br>
Parameters similar to craft, but needs the corresponding machine to produce your item. If the specified machine is invalud (see `factory_machines up top`) or if the machine is busy (not empty), it does nothing.<br>
Valid item ID's are `rubber`, `dust.rainbow`, `ingot.rainbow`, `cable`, `ore`, `dust`, `ingot`, `plate`, `block`, `plate.stack`, `rod`, `lump`, `pumpkin`, `pumpkin.stack`

trash(item, tier, ammount) `[factory: trash type: string, type: int, type: double]`<br>
Same parameters as craft, but instead of crafting that item, it puts them in the trash.<br>
Valid item ID's are `plate.rubber`, `plate.rainbow`, `essence.void`, `circuit`, `wire`, `screw`, `pipe`, `ring`, `block.dense`, `plate.dense`, `plate.circuit`, `pumpkin.plate`, `pumpkin.carved`, `pumpkin.anti`, `chip.basic`, `chip.advanced`, `chip.hitech`, `chip.nano`, `chip.quantum`, `chip`, `hammer`, `sapling.rubber`, `sapling.void`, `dust.rainbow`, `cable.insulated`, `plate`, `motor`, `pump`, `block`, `plate.stack`, `lump`, `producer.town`, `producer.statueofcubos`, `producer.workshop`, `producer.shipyard`, `producer.laboratory`, `producer.constructionFirm`, `producer.mine`, `producer.powerplant`, `producer.arcade`, `producer.headquarters`, `producer.tradingpost`, `producer.museum`, `producer.factory`, `producer.exoticgems`, `producer.gems`, `booster.acceleration`, `booster.machines`, `booster.production.regular`, `booster.resource.drops`, `booster.trees`, `pumpkin.stack`, `pumpkin.producer`, `machine.oven`, `machine.assembler`, `machine.refinery`, `machine.crusher`, `machine.cutter`, `machine.presser`, `machine.mixer`, `machine.transportbelt`, `machine.shaper`, `machine.boiler`, `rubber`, `ingot.rainbow`, `cable`, `ore`, `dust`, `ingot`, `rod`, `pumpkin`.

cancel(machine) `[factory: cancel machine type: string]`<br>
Stops the specified machine and exects all items in the inventory if possible. Does nothing it can't place the items somewhere. Valid machine ID's are specified at the top under `factory_machines`.

### Powerplant

sell(x, y) `[powerplant: sell type: int, type: int]`<br>
Sells the powerplant component at the specified tile, where (0,0) is the bottom left corner and (18,12) is the top right corner. Giving an invalid tile will default to and sell (0,0).

### Trading Post

refresh() `[tradingpost: refresh]`<br>
Generates new offers in the place of all offers you haven't locked. Requires mt12+ to use.

trade(offer, pct) `[tradingpost: trade type: int, type: double]`<br>
Accepts the trade at index `offer` using `pct` percent of your resources for the trade. Does nothing if the `offer` is not a valid index.

### Museum

museum.buyTier(element, tier, quantity) `[museum: buy type: string, type: int, type: int]`<br>
Buys the PowerStone of the requested element and tier, quantity number of times. Buys all the stones it can, even if you can't afford the given quantity.

museum.buyRange(element, tierMin, tierMax, quantity) `[museum: buy range type: string, type: int, type: int, type: int]`<br>
Similar to museum.buyTier, but it tries to get the highest tier it can.

combine(tierMax) `[museum: combine type: int]`<br>
Combines all PowerStones in the inventory up to tierMax. If tierMax < 1, there's no limit, so implicitly 50 or higher if updates change this.

transmute() `[museum: transmute]`<br>
Transmute PowerStones currently inside the Cubos Cube.

move(from, slot, to) `[museum: move type: string, type: int, type: string]`<br>
Move the PowerStone from `slot` within `from` inside of `to`. Example default `Move from inventory in slot 0 to loadout`.

museum.moveTo(from, flomSlot, to, toSlot) `[museum: move slot type: string, type: int, type: string, type: int]`<br>
Move the Powerstone from `fromSlot` within `from` inside of `to` at `toSlot`. Example default `Move from inventory slot 0 to loadout slot 0`.

museum.swap(invA, slotA, invB, slotB) `[museum: swap type: string, type: int, type: string, type: int]`<br>
Same parameters as in museum.moveTo. Swaps the PowerStones between containers.

delete(inventory, slot) `[museum: sell type: string, type: int]`<br>
Sells the stone in slot, within the inventory. Default example `Sell from inventory in slot 0`.

clear(inventory) `[museum: sell all type: string]`<br>
Sells every stone within the inventory.

museum.setPreferredTied(tier) `[museum: set preferred tier type: int]`<br>
Sets the preferred offshore market tier.

museum.setPreference(element, bool) `[museum: set preference type: string, type: bool]`<br>
Set the offshore market preference for element to bool. If bool is false, you won't get offers of that element, if bool is true, you will get offers of that tier.

museum.refresh() `[museum: market refresh]`<br>
Refreshes offshore market offers. Requires mt12+ to use.

museum.buyOffer(offerSlot, ammount) `[museum: buy market type: int, type: int]`<br>
Buy the PowerStone from offshore market at `offerSlot` `ammount` times. Default example `Buy from offshore market from slot 0 1 times`.

museum.setSlotLocked(offerSlot, locked) `[museum: lock market slot type: int, type: bool]`<br>
Set the lock state of offshore market `offerslot` to `locked`. Default example `Set the lock state of slot 0 to false`.

museum.rebuy(trashSlot) `[museum: rebuy type: int]`<br>
Rebuy the PowerStone from tashSlot.