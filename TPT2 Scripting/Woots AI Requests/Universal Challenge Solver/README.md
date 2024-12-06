# Universal Challenge Solver
v 1.0.0

# Development
This section is specifically for the development side of this AI, if you want the import, you [already passed it](#ai-import).<br>
Source code to be imported in [the external AI editor by d0sboots](https://d0sboots.github.io/perfect-tower/).
```
{"workspaces":{"Universal Challenge Solver":[["New 1",";1. 600.0\n;2. 800.0\n;3. 1000.0\n\n; 1152x864\n; vec(600.0, 378.0)\n; vec(811.0, 378.0)\n; vec(1039.0, 378.0)\n"],["Check Coordinates ","\nkey.x()\n\n:const double increment 67.5\n:local double inc\n:local double x\n\ncanvas.clear()\ncanvas.rect(\\\n  {pos.relative(750.0/800.0, 5.0/450.0, 1.0, 1.0)}, \\\n  {pos.relative(5.0/800.0, 250.0/450.0, 0.0, 0.0)}, \\\n  \"#FFFFFF\"\\\n)\n\nx = 320.0\nloop:\nx = x + increment\ncanvas.rect(\\\n  {pos.relative(x / 800.0, 235.0/450.0, 0.5, 0.5)}, \\\n  vec(5.0, 5.0), \\\n  \"#000\"\\\n)\nx = x + increment\ninc = inc + 1.0\ngotoif(loop, inc < 3.0)\n"],["Challenge_lib","#package(name) Challenge Solver:{name}\n#identifier \"Challenge Solver\"\n\n#up w\n#down s\n#left a\n#right d\n#start t\n\n#instructions \"<size=0>\" . {identifier} . \"instructions\"\n#status \"<size=0>\" . {identifier} . \"status\"\n#visual {identifier} . \"visual\"\n#output {visual} . \"</size>\" . \"Challenge\"\n#get_visual(x) global.int.get({visual} . ({x}))\n\n:const int challenge_length 4\n\n:const string challenge1 '290.0'\n:const string challenge2 '256.0'\n:const string challenge3 '217.0'\n:const string challenge4 '182.0'\n:const string challenge5 '145.0'\n:const string challenge6 '112.0'\n:const string challenge_type '77.0'\n\n#challenges challenge1 . challenge2 . challenge3 . challenge4 . challenge5 . challenge6 . challenge_type\n\n\n"],["New 3","\nkey.x()\n\ncanvas.clear()\ncanvas.rect({pos.relative(615.0/800.0, 380.0/450.0, 0.7, 1.0)}, vec(5.0, 5.0), \"#FFFFFF\")\n\n; Challange = C00-0\n"],["ui",":import Challenge_lib\n:name {package(ui)}\n\n:local int limit\n:local int region\n\nkey.{up}()\nkey.{down}()\n\nexecutesync(if(\\\n  contains(impulse(), \"key.\"), \\\n  \"{package(init)}\", \\\n  \"{package(N/A)}\"\\\n))\ngotoif(change, contains(impulse(), \"key.\"))\nwaitwhile(isTowerTesting())\n\nshow(\"towertesting\", true)\nregion = 14 - {get_visual(0)}\nloop:\n; move regions\n{click.relative(290.0/800.0, 201.0/450.0, 0.0, 1.0)}\nregion = region - 1\ngotoif(loop, region > 0)\nshow(\"towertesting\", false)\ngoto(99)\n\nchange:\nlimit = if(global.int.get({status}) == 0, 14, 5)\nglobal.int.set({visual} . i2s(global.int.get({status})), max(\\\n  0, \\\n  min(limit, if(\\\n    contains(impulse(), \"key.{up}\"),\\\n    {get_visual(global.int.get({status}))} + 1, \\\n    {get_visual(global.int.get({status}))} - 1\\\n  ))\\\n))\nexecute(\"{package(init)}\")\n"],["TowerTesting",":import Challenge_lib\n:name {package(TowerTesting)}\n\nkey.{left}()\nkey.{right}()\n\n:local int region\n\nexecutesync(if(\\\n  contains(impulse(), \"key.\"), \\\n  \"{package(init)}\", \\\n  \"{package(N/A)}\"\\\n))\ngotoif(change, contains(impulse(), \"key.\"))\n; enter challenge mode\n{click.relative(615.0/800.0, 380.0/450.0, 0.7, 1.0)}\n\nregion = {get_visual(0)}\nloop:\n; move regions\n{click.relative(290.0/800.0, 201.0/450.0, 0.0, 1.0)}\nregion = region - 1\ngotoif(loop, region > 0)\n\n#curent_challenge s2d(sub({challenges}, {get_visual(1)} * challenge_length, challenge_length), 290.0)\n; Sellect the challenge\n{click.relative(395.0/800.0, {curent_challenge}/450.0, 0.0, 1.0)}\n\n; launch tower testing\n{click.relative(162.0/800.0, 97.0/450.0, 0.0, 1.0)}\nexecutesync(\"{package(ui)}\")\ngoto(99)\nchange:\nglobal.int.set({status}, if(\\\n  contains(impulse(), \"key.{left}\"), \\\n  0, \\\n  1\\\n))\nexecute(\"{package(init)}\")\n"],["init",":import Challenge_lib\n:name {package(init)}\n\nwakeup()\nkey.{start}()\n\n#target(selection) \"<color=#00A0F0>\" . ({selection}) . \"</color>\"\nglobal.int.set({status}, if(\\\n  contains(impulse(), \"key.\"), \\\n  2, \\\n  global.int.get({status})\\\n))\nglobal.int.set({visual} . \"0\", {get_visual(0)})\nglobal.int.set({visual} . \"1\", {get_visual(1)})\nglobal.string.set({output}, if(\\\n  global.int.get({status}) == 0, \\\n  \"C\" . {target(sub(i2s(101 + {get_visual(0)}), 1, 2))} . \"-\" . i2s(1 + {get_visual(1)}), \\\n  if(\\\n    global.int.get({status}) == 1, \\\n    \"C\" . sub(i2s(101 + {get_visual(0)}), 1, 2) . \"-\" . {target(1 + {get_visual(1)})}, \\\n    \"C\" . sub(i2s(101 + {get_visual(0)}), 1, 2) . \"-\" . i2s(1 + {get_visual(1)})\\\n  )\\\n))\n\nglobal.string.set({instructions}, if(\\\n  contains(impulse(), \"key.\"), \\\n  \"</size>\", \\\n  \"</size>\" . \"Challenge=C<region>-<challenge>\" . \"<br>\" \\\n    . \"<color=#00A0F0>\" . \"{up}{left}{down}{right} moves, {start} begins the challenge\" . \"</color>\"\\\n))\n\ngoto(if(\\\n  contains(impulse(), \"{package()}\") || contains(impulse(), \"wakeup\"), \\\n  99, \\\n  if(anyopen() || isTowerTesting() || isBossFight(), warn, skip)\\\n))\nwarn:\nglobal.string.set(\\\n  \"<color=#F00>\" . \"<b>\" . \"warning\", \"Exit All Buildings and/or active games\" . \"</b>\" . \"</color>\"\\\n)\nwaitwhile(anyopen() || isTowerTesting() || isBossFight())\nglobal.unset(\"<color=#F00>\" . \"<b>\" . \"warning\")\nskip:\nshow(\"towertesting\", true)\nexecutesync(\"{package(TowerTesting)}\")\nexecute(\"{package(init)}\")\n\n"]]}}
```

## To be done
needs better variable names<br>
figure out the formula to make Check Coordinates work as expected<br>
figure out the UI scale breakpoint for module shifts<br>
find the old document which had the needed data for this AI<br>
add comments to every document, no matter how redundant

## versions

version 1.0.0

- AI published
- Added movement system to change regions and challenges
- Implemented a primitive library
- Decided on a formal release schematic