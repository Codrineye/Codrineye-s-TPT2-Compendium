[Codrineye's TowerTesting](#codrineyes-towertesting)<br>
[WS.Fragzilla](#wsfragzilla)<br>
[Universal Challenge Solver](#universal-challenge-solver)

# Codrineye's TowerTesting

[Version 2.0.0](/TPT2%20Scripting/Codrineye's%20TowerTesting/README.md)

This package handles all movement needed to enter dificulties and regions for TowerTesting.<br>
For customized impulses, import the scripts source code.

```
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
```

## Requirements
- 6 impulses
- 2 condition
- 31 actions
- 1 script

Avoid using Dynamic UI Scaling as it will mess with click positions

## Details

The script has 2 instances running. The first instance exits tower testing for you, and the second one handles region/difficulty cycling.

It uses 3 variables:
- `status(X)` represents the scripts state, if it's active this value will be true, if the script is inactive its value will be false
- `Region Cycling(W)` represents if the script is able to change regions or not
- `Curent Mode(Q)` shows the mode the script is in

The key inbetween (patenthesies) is the key you press to change its state. This value is given from the source, so changing the impulse key macros will automatically change what's displayed

`Curent Mode` can have 2 modes, mode 1 is `Difficulty>Region` which means that the script will first cycle through all the difficulties and then change your region, and mode 2 is `Region>Difficulty` which means that the script will first cycle through all the regions and then change your difficulty.

The script can cycle as long as its active, by default you'll be cycling from `Easy to Impossible`, once it reaches Impossible it will cycle back to Easy.

The script has always true conditions, the first one contains the strings reprezenting the cycling direction, the second one is used to tell you the line at which you change the directional string and the line at which you add your additional_cond

## The impulses
<details>
  <summary>
    Table View
  </summary>
    x will start/stop the AI<br>
    w will toggle Region_Cycling<br>
    q will toggle through your modes<br>
    r will restart<br>
    e will exit<br>
    t will open stats and move to the Wave tab
</details>
<details>
  <summary>
    Complete descreption
  </summary>
    The AI's variables start hidden, you can press `x`, `q` or `w` to show them<br>
    You start and stop the AI by pressing `x`.<br>
    You can restart instantly by pressing `r`, exit by pressing `e` or showing stats by pressing `t`, crucially this qol feature only works if it's impulse is set as the same key that the game uses to open stats.<br>
    Once the AI is shut down, the variables will be hidden again, pressing `q` or `w` will still stop them from hiding, as it assumes you're attemting to communicate with it. You can hide it again by pressing x twice or you can disable the script while you don't use it.<br>
    If you are in a towertesting run and want to stop the AI, it will exit this round of towertesting.
</details>

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
