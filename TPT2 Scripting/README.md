[Codrineye's TowerTesting](#codrineyes-towertesting)<br>
[WS.Fragzilla](#wsfragzilla)<br>
[Universal Challenge Solver](#universal-challenge-solver)

# Codrineye's TowerTesting

[Version 2.0.0](./Codrineye's%20TowerTesting/README.md)

This package handles all movement needed to enter dificulties and regions for TowerTesting.<br>
Please keep in mind that the script does not know what region or difficulty you're on, nor does it try to interact with blueprint. This is purely for movement automation, not for entire TowerTesting automation.<br>
For script comments and easier script customization, import the scripts [source code](./Codrineye's%20TowerTesting/README.md).

```
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
```

## Requirements
- 6 impulses
- 2 condition
- 31 actions
- 1 script

## Details

The script runs 2 instances of itself. One TowerTesting manager and one Movement manager.

The TowerTesting manager ensures you exit TowerTesting as soon as your goal in `additional_cond` is reached, your towers health reaches 0 or if you manually exit TowerTesting.

`additional_cond` is an additional condition to the exit condition. This is used to exit your run early if you want multiple difficulties and regions to be at equal wave-goals.

The Movement manager handles moving in the TowerTesting menu.<br>
(Note that the TowerTesting menu is where you press the Launch button to start a TowerTesting instance).

This handles clicking on the arrow to change regions, clicking on the difficulty buttons and clicking on the Launch Button.<br>
For these clicks to work, you need to turn off Dynamic UI Scaling.

The Movement manager will wait until you're no longer in any screens. This means that, if you activate the script while you have a menu open, it will wait until you close that menu.

## The Impulses

You have 6 impulses that let you interract with the script.

Three of them control the scripts global variables.<br>
These variables are hidden until you press either of them.
- `status(X)` is the scripts status. You press `x` to activate or deactivate the script. The variables will hide themselves when you deactivate the script.
- `Region Cycling(W)` determines if the script is allowed to change regions or not
- `Curent Mode(Q)` shows the scripts mode. There are 2 modes the script can be in:
- * `Difficulty>Region` means that the script will cycle through every difficulty before changing region
- * `Region>Difficulty` means that the script will cycle through every region before changing difficulty

The key inbetween `(parenthesies)` is the key you press to change the value. This value is calculated within the source, so changing the impulse key macros will automatically change what's displayed

The other three impulses are for Quality Of Life (QOL) features.<br>
The values outlined here are from the default version, they do not apply to any version with customized impulses.
- `e` to exit TowerTesting
- `r` to restart TowerTesting
- `t` to open up the stats menu and open the Wave tab. This impulse assumes that your ingame hotkey to open the stats menu is `t`.

The script is able to cycle as long as it's active, by default you'll be cycling from `Easy to Impossible`, once it reaches Impossible, it will cycle back from Easy.

The script has always true conditions, the first one contains the strings reprezenting the cycling direction, the second one is used to tell you the line at which you change the directional string and the line at which you add your additional_cond

## The Budget

The scripts budget is set to -1 by default, this is because the AI uses that extra speed to ensure you do not enter another building while it's trying to perform the actions needed to cycle. You can savely remove its budget, if you're setting it to idle for you, as it can run perfectly fine without it.


# Universal Challenge Solver

[version 1.0.0](/TPT2%20Scripting/Universal%20Challenge%20Solver/README.md)

This set of scripts manages to enter the inputed challenge once prompted to.<br>
Tho the task is simple, this package provides the building blocks of a system which can perform a large majority of tasks needed to complete a challenge.<br>
All this to say that this is a prototypical build.

## AI Import

REQUIREMENTS:
- impulse count: 2
- conditions count: 0
- actions count: 13

To use this AI, you will need to:
- position your region on forest, as the AI cycles through regions assuming it starts on Forest
- enable Hard Mode if desired
- ***NOT USE DYNAMIC UI SCALING*** as the relative clicks are likely to break due to an ingame bug

```
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
```

# WS.Fragzilla

[Version 2](/TPT2%20Scripting/WS.Fragzilla/README.md)

This AI will hammer all nodes within the selection circle.<br>
It uses a hidden string to determine the scripts status, `WSFrag is running` means it's running and `WSFrag is offline` means it's off.

```
5VdJa9wwFP4rxaWXdqJ4shXCZIY2MNcecsihCUWWZVuMredKcky2cy/tqafkVEouPZZeSgkUxn+sSLaD47FnYwJpi0G2pbfove8t0rkliWCxktbu23MLE8WA62/rKLHtbtcPwcEhkkow7iNJ1ZFDgEuFudIE9pYh2+pJdkb37P7hwVBgXyqsEmnWdwhwghu57Je9dc3WNz9UUcGxOC1UmTmvUEuAK8x4LpHm+0UsipNQ0kbJ2yN6ioLGJbtdG4EoxoJJ4MgBCI1lmwpSjlLGXUgR5qcQU94od+PionXPdTf6C7mxRvmsRyAEsffUHpaET5h8IhLOGfd762a138o1tKtc4Hkh43Qm11RdVicPFjsEgkPkQuKEtDFWHAIQupDWXbg5vh5flU/2faAlilwa46pRlBfgKKLiHYGE11c3zNit4F2MWq7nU04FI8gHBWbaKYOBFfyPE8Pcqu1Jq+p0pNlwA1E1nGUA6SREKYiRDCCureTe7JaCuqUXU8yUJ3BE58BMCRrth4yMZJWyyZP30F1MsklvLJgKIqoYMaDO0Fbhbkrt7toi8SVKzxAtMd/OCSXIExDtAwi3CKfKFvOMWXCaF3kWMX5XFynV4LoqQG4bWy3xDBnJPry/+8huB81eeF7kRq4moMwPFHKn0VKIdTtBCUM6KdpIp9WCq5bNvJjirQlXzKe3IbEmxuzL4GHQm3Dr/PDN3PPXqYDO6azl8cx+jm/eZL/0cD3+vQSc84bccnhOr2jG7GrHYN5EMXBapNPKgWIFVai5HzQYtapib093zV/eSL0HbqSegpQKRaXSB8xlmumqG8k/2zGyT9nH8hnfLlqh/6NSPL7pZ9/Gn/XwY3Avh3XkHU0e4puS8+4Qv8pcmFFr5inDScvp+BEVIuu4YxHgLitv2ccdq7jHmju3vrZ6Vse8A03Mtf27ViHwZKNy5YoxGWFfr5aqd14N+4cHSJOesTDEVsdyEtenytpd63asRNLXxa8SCb08vvwD
```

## Script Requirements
- 2 impulse
- 0 conditions
- 21 max actions
- 1 script

# Script interraction

The script is within a WS.Fragzilla package for the script color.

This script is toggled on/off with the key "f", the script will quit execution if this action is performed outside of town.<br>
Its status has 3 modes, `hidden`, `script on` and `script off`. `script on/off` can be triggered by "f", `hidden` is triggered by "h"<br>
At the top of the script you have 2 local variables:
- cooldown is a double that informs the script for how much it should wait in the idle screen
- hammer_count is an int that indicates how many times you will hammer the nodes before returning to the idle screen

To use this script, you must turn off dynamic UI scaling, as it breaks relative vectors
