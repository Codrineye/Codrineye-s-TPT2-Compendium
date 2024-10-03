# IronClicker
IronClicker is a script created by [discord user Eisenefaust](<https://discord.com/channels/488444879836413975/783731338304946217/1291271243630252112>)

Its purpose is to automate activities inside of both [Construction firm](<https://www.perfecttower2.com/wiki/Construction_Firm>) and [Era essence research](https://www.perfecttower2.com/wiki/Era#Era_Powers)

```
{"workspaces":{"IronClick":[["Point&Mouse(P)","; Original Point&Mouse\n:import IronClick_lib\n:name {package(Point&Mouse(P))}\n\n:global int click_instances\n\nkey.p()\n\n; Originating from D0S.Superclick\n; Fibonacci multi-exec. Each new instance increments the counter as\n; the first thing it does, so that happens on the frame it's executed.\n; On the next frame, we launch a new copy, as well as on the frame after\n; that. This leads to a Fibonacci sequence of new copies, where the number\n; spawned each frame is 1, 1, 2, 3, 5, 8, 13, 21\n; As a consequence, the total number running is the partial sums:\n; 1, 2, 4, 7, 12, 20, 33, 54 (This is just F(n+2) - 1).\n; We choose 54 as a nice stopping point, because it's a lot but not\n; too close to the limit of 100.\n\nclick_instances = click_instances + 1\nexecute(if(click_instances < 54, \"IronClick:Point&Mouse (P)\", \"IronClick:NULL\"))\nexecute(if(click_instances < 54, \"IronClick:Point&Mouse (P)\", \"IronClick:NULL\"))\n\n; It's important to keep this loop tight, so we get as many clicks/frame\n; as possible.\nloop:\nclick(position())\nclick(Point)\ngotoif(loop, click_instances <= 54)\n\n; The exit check. We count the number of copies exiting (with\n; the same counter), so we know when they've all exited.\n; This is because it takes the script that was launched via impulse\n; (the one that signals we should quit) longer to reach this point,\n; and we don't want to unset the variable prematurely or that copy\n; won't exit.\n\nclick_instances = click_instances + 1\nglobal.unset(if(click_instances > 109, \"click_instances\", \"\"))\n"],["Points (L)","; Original Points\n\n:import IronClick_lib\n:name {package(Points(L))}\n\nkey.l()\n\n#Ship {pos.relative(695.0/800.0, 224.0/450.0, 1.0, 1.0)}\ngoto(if(\\\n  x(Point) == x({Era}) && y(Point) == y({Era}), \\\n  update,\\\n  reset\\\n))\n\nupdate:\nPoint = {Construction}\ngoto(99)\n\nreset:\nPoint = {Era}\n"],["IronClick_lib","#package(name) IronClick:{name}\n\n:global vector Point\n#Construction {pos.relative(287.0/800.0, 332.0/450.0, 1.0, 0.0)}\n#Era {pos.relative(437.0/800.0, 30.0/450.0, 0.0, 0.0)}\n"],["Main",":import IronClick_lib\n:name {package(Main)}\n\nkey.p()\nkey.l()\n\ngotoif(points, contains(impulse(), \"key.l\"))\n\n; This function does not change the value inside Point\n; It only ensures the user cannot make the clicker\n; click on coordinates 0,0\nPoint = if(\\\n  x(Point) == y({Era}) && y(Point) == y({Era}), \\\n  {Era}, \\\n  {Construction}\\\n)\n\n; enter a modification of D0S.Superclick\n; D0S.Superclick link\n; https://github.com/d0sboots/PerfectTower/blob/main/D0S.Crates_Idler_v2\n:global int click_instances\n\nclick_instances += 1\nexecute(if(click_instances < 54, \"{package(Main)}\", \"{package(Null)}\"))\nexecute(if(click_instances < 54, \"{package(Main)}\", \"{package(Null)}\"))\n\nloop:\nclick(position())\nclick(Point)\ngotoif(loop, click_instances <= 54)\n\nclick_instances += 1\nglobal.unset(if(\\\n  click_instances > 109, \\\n  \"click_instances\", \\\n  \"{package(NULL)}\"\\\n))\ngoto(99)\n\npoints:\n; Switching through points\n\nPoint = if(\\\n  x(Point) == x({Era}) && y(Point) == y({Era}), \\\n  {Construction}, \\\n  {Era}\\\n)\n"]]}}
```
This script contains 3 scripts, 2 of them were the creation of Eisenfaust, called "Point&Mouse(P)" and "Point(L)"<br>
I compacted them all inside of Main

## Requirements
- 2 impulses
- 0 conditions
- 12 actions
- 1 script in use

## In action
The script works by copying itself to perform the click-spamming of [D0S.Superclick](<https://github.com/d0sboots/PerfectTower/blob/main/D0S.Crates_Idler_v2>)

use the impulse P to activate the clicker, and the impulse L to change between the different modes<br>
the clicker will initialise the point if it has no value

## Thoughts
This project was not created by me, however it shows to be interesting as a project<br>
Tho this is a script for a simple task, I believe it shows that there's room in the world of scripts for a tool such as [Codrineye's Compact Spell-Caster](/Codrineye's%20Compact%20Spell-Caster/) that, instead of compacting spells for use in towertesting, permits compacting the coordinates for relative vectors inside of a string, like I do in [Cods TowerTesting](/Cods%20TowerTesting/Stats%20Exit%20Diff_Change.tpt2) to determine the difficulty my AI enters

