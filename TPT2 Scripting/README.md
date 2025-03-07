[Codrineye's TowerTesting](#codrineyes-towertesting)<br>
[WS.Fragzilla](#wsfragzilla)<br>
[The Blueprint Compactor](#the-blueprint-compactor)<br>
[Universal Challenge Solver](#universal-challenge-solver)

# Codrineye's TowerTesting

[Version 2.0.1](./Codrineye's%20TowerTesting/README.md)

This package handles all movement needed to enter dificulties and regions for TowerTesting in Endless mode.<br>
Please keep in mind that the script does not know what region or difficulty you're on, nor does it try to interact with blueprints. This is purely for movement automation, not for entire TowerTesting automation.<br>
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

The TowerTesting manager ensures you exit TowerTesting as soon as your goal in `additional_cond` is reached, your tower health reaches 0 or if you manually exit TowerTesting. As there are game-modes such as `challenges` or `normal mode` where your run can end without your tower dying, this AI cannot cycle through them as it'll cause.

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
- - `Difficulty>Region` means that the script will cycle through every difficulty before changing region
- - `Region>Difficulty` means that the script will cycle through every region before changing difficulty

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

# The Blueprint Compactor

[Version 2.7.7](./Codrineye's%20Compactors/Codrineye's%20Blueprint%20Compactor/README.md)

This package is an addition to your blueprint AI that handles spell activations and module secures.<br>
To make a blueprint AI that can talk to the compactor, please head over to its [source code](./Codrineye's%20Compactors/Codrineye's%20Blueprint%20Compactor/README.md) readme to understand how to use it internally.

## Script Requirements

- 0 impulses
- 0 conditions
- 34 max actions
- 1 script

```
7Vzdbts2FH4VR8V60Tiq5GxLF9ht0O5mV+v9HAQURTlEKVEgqTpd22fYq+wNCrQvVsiUElk6dCXLrmObCCDEtM4PD7/zI1qHHx2JBU2VdC7/+eggrChP8v+daeZ5HpmRhAiK3RlXnEaLsUARkSDxwaWJygd8H/M4RYJKnrghzwJG9PCM8QCxYsidETUNME+kQprO+3Vx9eHh0WRSGz9fXL0O12X60UIr3PI+k7RIKkGTmYt5ohBNpDaTtqFL4zRjkkAT8s9fs4ykgiZq8Ca3F1ZcOENnKhjHiOXGdKXBRBcpp4kiolgSbdacALDpk7Gk/5KJ9xIQN3ir+eRic5U8LbqYkVF6Dor3RC4takEDKPALIBhhTKQcFIwGUt2rUOMH6HAyfp7PCJwPRoyVZilRqTn1WivPv5wqmQUVVqupRiuBSAo1aBKSu7+jLlp0E7PEsrCwF5UuTO4IzlQ3cFZQUrgxhJJE0ZiImwBJoj1VjsKaAWtYMwWDKtY8ggRVtzFRFC9iTcVTjPSlp4D2PAXtabJqXbxhKbvODNTs064nDJKf7VqrhXlzcEmF4tTNFE74vAQ20XoEnDNj7CIhUTfL6DSlq2WYQzOrwhxMWSeTlRq38KT8+htmHL9bDmoPenpRRf187vrGyuAm1qiZfc2xB6R/+rSxRiZFwDWqYK6Y+xrFwLf/X5kQGBWLEDHOhUlk/yrGf94bW53LnofUWgT+OaJqfkvZSvgbpt/fK/xnLRlVsA/yedltPdoXOYFMCWM3f/25hZz185OGlXgYEned/GFy35I3rrvHipVoJdooc2Tk8NPZMYDWSrSh4EjJ195K2NKenHWMA3KMx2HuY5B4NJCylYtd99a7tV+/bHTvst/W7XnMw2kz1a61BTpuySi7z9mlIS4UnxPhxjzMGHEzSegDgf9ihmJSfqfRqHHcEsX3G5+ltBd1aSmXNH8jYLPitGu8J9iNBI/fcC5CXV3YImWPJB5pLLNVlZVofWAT5MdbBlqg7gdQW9et+m5bvViJ1gVtuWUlHoxE67S2PrQSrWcdCHnXjdhGAxAg1jdl4Ub7Rb/aeH3AdESGBHehI4Fisk7DTr1fam/t8gQkN8FoC/6e6YcsehAPWfsT/x6HvewK7Wn5tK9mHH37ov/yoB9V82DLsA5p4+0w2Cc/njLUHQtNFvolNtI/Ht4SxNRtjbG/YoFG4813+jot57FWg1JdWNBCofz6e/O+bq9z+XS9cu5Vx4ZfSXAmNtHwWzDq1vDbjh/sXaWUUfWnak21puOVtujieFuIu6UahrjbO8aedWHR5eHgDxiWplc5LpoL52IuDWcEjCdTlTL0gQj3Lt1u1b4Rhcsetp7djVdf/7sC+Z+nfA7EE+ObLxSEas8n08eD9O6Qbh+IF7NstuceLkzW7xAFU5ehOGvd19tFdNsCDuqshs6QaJEUW5xaUaM4XXFwR8GMhowMYh4a2s8/FfV3rRf88fgjqHWz07ysu9sUp1DKWVFn1V4JNPq3MiF+8aqfGxKmEEz5bP1a9mpjR3bAKfDnGOAUkvPDNu1WtQSBLbcUcysV3ja8VGtzUsdsJ+/tvhY9H482ethOn4lfDx3Mk5CWh0xdD53itJriU5JD9dKBoZ0i/A7N8u+doRNk4Ywo5/LMHzqZJK+Lj0pk5PP15+8=
```

If you are confused about something that the compactor is doing, you should use its [Debugger Version](./Codrineye's%20Compactors/Codrineye's%20Blueprint%20Compactor/README.md).

## The interface

The compactor uses a global hiding blocker to hide the transfer of strigns. Once the compactor is running, this blocker will end and show the string `Blueprint Compactor Caller` with the name of the package/script that called it.<br>
This information is given for you to see if there are any blueprint AI's that might interfere with your run.

## Behaveour

While the compactor is active, there will be at most 1 instance of it running. This is the instance that's updating the timer.

It is made to handle as many instances of it you create as you want, as it cannot create a second timer. 

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
- **_NOT USE DYNAMIC UI SCALING_** as the relative clicks are likely to break due to an ingame bug

```
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
```
