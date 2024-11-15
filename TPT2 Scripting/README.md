[Codrineye's TowerTesting](#codrineyes-towertesting)<br>
[WS.Fragzilla](#wsfragzilla)<br>
[Universal Challenge Solver](#universal-challenge-solver)

# Codrineye's TowerTesting

### UNDER RECONSTRUCTION

[Version 2.0.0](/TPT2%20Scripting/Codrineye's%20TowerTesting/README.md)

This package handles all movement needed to enter dificulties and regions for TowerTesting.<br>
For customized impulses, import the scripts source code

```
7VpNj9tEGP4rwUhlS3enttPdLqv9qFiQyqFIhQqQSFmN7YkzWmcmOzMmG7o9cKCIG7cKLhROIDhw4MABCSn+Y2g8zpczjsfeJFuJZCU768z4feZ5P+fjmcV9hnuCWwefP7OgLzAl8rvVim3bsSPqwwgENPYiBDgSLc+nhAtIhPzdvqdaCQYJx7LrWYAiOMi1aqZXe/E1eXVibSupThhRD0aAC4ZJmIqVTfZ8Snw4+z0Pxzvk+Ct0ZB/rgNroE8gw9CLUeIgDxLSD2T+lJMAEDdBbvPGE9hF7grjAJFRvEIgRyAYZtvRZ26fdHmSYUwI8SiP1MBuDfADCeeLACGiRuMO7ssExF1BsfXZbOxz36EjJyojyKREQE66QKr0C3O3FEUfaF+yeowG41NLgndJgFlADc0nbaNRFGpBX72NBe6PGugb3s9FJjbdDRBDDPgipoKr7iGScdao7QKnMgBUqc17OSpXmKuPWOECunV/gI+W86DhwpJIvruS1f6UUXk6fO6WsOkAqWWDeEd2WtR7B+lGjcg29Od8kC16zNqSJmFVt6GYjzBtLiTCm3OwbQv4IhZiSxunAjzAJtz69Bkv1Ra6Or/6CRJjrtGsI/zRmiIjGIxqgrce3i1OZBncehYbEmii0EVsRffwebrexH0dikPWthNmc6ws9ion4TPMjFNUwV3r3yEvQdELEbdPsoDd/gwxhe5PccGHMnnt1ld6bhK4keU5iRsYGukR+LCrm+YknZW/pQyz6HRyhQs6cZgi7CGA+Uy9oKbh1a4Ujn8UcE4GjZWBej9pmwbcZ7KKxeas5RVEOUKBgEKTzCRid+ZQEuUbObMotcRhl45W8RkexM/VQTYhabSF5AB0EI9HRY9QOz8lHBqMZ0oKCZKX2uFDW2I6m1aqRqVWrVCBRHKJLLGZmA9JuWvNz0IJXz89BTacWRlHzWlXlehyv7iTCJHQY18UtMd+mgt87Du9j4XfOgnGKrKak16VWWeQxaGowUgdM8YKJ0Bq351MZ+wvCuXNoqiqphilROg0UiXKLolCN7LrW4LSUVOk0Be0T0MckoH0AyYD2EBmN3J7+jXdof+5NKkcIrRyVI5wKeczZv24e2zhTscKPjmoGvtkQ/7oyXGVSs9ZwtVeRYOMcWnt2v/RShI1e5kfYP1fMfol80Ga0e0opCzKDgAyLThcJ7I+KzILHJEPRxWRcniAkY1EgOiAo6qapOx0/+fZi/CX550SvurczM1ZiOgiHHQHylflMW0R7kgQQYyBZLmqag6Q+ycuTioQY8jQ3AHOiSrcwfllIXV5DS2du+HL49YfpeLzk1+Ffyc/Df/U972iZGOe00k0fkqvPmtwNWoLHXrYso/MK5L5jA9vd3QO269wHtrPvAtu5twtsx3GBYhBNqcEg1qRgJ1DOMAmQdjdjnisVd3ZL445puxL7aLAHBvWXfjyxbtpiMNsqKqbzJK+W+DtaQss3QVT3Zpfm/aQ4Y9QBvYnzNxbnhz8Ofxj9JT9ton0pf9UJKrfj6UiuFXu3YqC7eqB/z04tiv8soLg4gW2c+UacOfnj8fDvFA4afpP8nny38eeqFD784tFhatcOTH6rXrkZr+3UyPclkzrjHL+MpcDXdxq9jn2bwsUok6XuJa+86YVslpxWs367WXFa6ppe+ZKTWm/VpQ5du3rHutLArTbAGOICsuXvgS29hvm/lTbt9JO8WJiSC4gyrRrqlCuvNiVW5Sr1++TFxLKGRZa1UKOmBldPpdbTbUvujOPZc9jTZw+mjj4tOIPruO9DPmjsHDc+6PYo53heZWbrctqgmh1zWyh/IleikGj08lMxSqAUnYJQcCQwSUi2457SMTpPmB5Wyu797C6yO8ruTHYm8ujJgbXggFAP+ucwlI2sbcuLgxAJ62DH2bZijt7N/hUsRs+fPv8P
```

## Requirements
- 6 impulses
- 1 condition
- 36 actions
- 1 script

Avoid using Dynamic UI Scaling as it will mess with click positions

## Details

During activation, you'll 

The boolean Region_Cycling representing if the AI will cycle through regions or not, and CurentMode, which has the modes `Difficulty>Region` meaning that the AI will first cycle through difficulties before changing regions, and `Region>Difficulty` meaning that the AI will first cycle through regions before changing difficulties.<br>
If you'd like to change the order the AI enters difficulties, I've put a condition which gives you the list for Easy->Impossible (the default configuration) and Impossible->Easy, you can find this list in the script called [Stats Exit Diff_Change](Cods%20TowerTesting/Stats%20Exit%20Diff_Change.tpt2) and you need to paste it in

## The impulses
<details>
  <summary>
    Table View
  </summary>
    r will restart<br>
    e will exit<br>
    t will open stats and move to the Wave tab<br>
    x will start/stop the AI<br>
    w will toggle Region_Cycling<br>
    q will toggle through your modes
</details>
<details>
  <summary>
    Complete descreption
  </summary>
  To start the AI, you may use `x`, `q` or `w`, and press `x` to stop it.<br>
  To cycle through the modes mentioned previously, you press `q`, and to toggle Region_Cycling use `w`.<br>
  You can restart instantly by pressing `r`, or if you're running the game in a difficulty with a wavegoal that's less than era 1, you will reset after a set timer, its default set to 30 seconds.<br>
  To exit the round of tower testing, you can press `e`<br>
  While in tower testing, pressing `t` will toggle the stats to the Waves tab
</details>

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

This AI will hammer the sellected node in the anvil.<br>
It uses a toggle boolean `running` to determine the scripts state, true means it's running and false means it's off.

```
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
```

## Script Requirements
- impulse: 1
- conditions: 1
- max_lines: 11

# Script interraction

This package is activated/deactivated with the key "f", this action must be performed inside of town.<br>
You can tweak the variables within the script called `Init`, where the number after 'cooldown=' represents how long the AI will wait on the idle screen for fragment collecting, and the number after 'hammercount=' represents how many times the sellected nodes will be hammered<br> 
To use the package, you must turn dynamic UI scaling off, as it breaks the arithmetic due to an ingame bug.
