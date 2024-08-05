# Codrineye's TowerTesting
My first public project which got me to create this entire repo

It returns, but this time, it's with better logic<br>
There are 2 versions in this repo, [Codrineye's TowerTesting](#codrineyes-towertesting-v-10) and [Cod TT](#cod-tt)

# Codrineye's TowerTesting v 1.0
Codrineye's TowerTesting is a fully automated AI which will cycle through every single Region and Difficulty in accordance to both its Mode and wether or not its cycling mechanic is toggled on.

# What the AI does
On startup you will activate every global variable, the state of the script, the double Curent_Diff representing which difficulty will be entered, here's the list:<br>
- 290 is Easy
- 256 is Normal
- 217 is Hard
- 182 is Insane
- 145 is Nightmare
- 112 is Impossible

The boolean Region_Cycling representing if the AI will cycle through regions or not, and CurentMode, which has the modes `Difficulty>Region` meaning that the AI will first cycle through difficulties before changing regions, and `Region>Difficulty` meaning that the AI will first cycle through regions before changing difficulties.<br>
If you'd like to change the order the AI enters difficulties, I've put a condition which gives you the list for Easy->Impossible (the default configuration) and Impossible->Easy, you can find this list in the script called `Stats|Exit|Diff_Change` and you need to paste it in 

Once you shut doen the AI, you will get the message `Codrineye's TowerTesting Is Shutdown` which you can remove by pressing z

# The impulses
You can use x, q and w to start the AI and you can shut down the AI overlay with F4 or press x again.<br>
After startup, pressing q will cycle between the 2 modes previously mentioned, each time you change the mode your Region_Cycling will be toggled on, and pressing w will toggle the cycling on and off.<br>
Pressing r will instantly restart, and you also have a builtin timer so that you will always restart at the desired time.<br>
Pressing e will exit the curent round of tower testing and pressing t will toggle the stats to the Waves tab.

# Requirements
- 2 impulses
- 1 condition
- 14 actions

# Cod TT
Thank you bluecat for making an attempt to rework this mess

Cod TT is a version of Codrineye's TowerTesting made by bluecat, who tried to take my original idea and condense it into a more compact AI.<br>
While the attempt was great, and it lead to a functional product, it still has the same shortcomings my original AI had

```
{"workspaces":{"Cod TT":[["Tower_Automation lib","\n#package Codrineye's TowerTesting\n\n\n#init Init\n#logic Core\n#difficulty Difficulty Cycle\n#region Region Cycle\n#toggles QOL\n"],["init","\n:import Tower_Automation lib\n:name {package}:{init}\n\n:global bool CdTTRunning\n:global bool RegionCycle\n:global double ClickPos\n:global string difficultyClickPositions\n\n\n\nkey.x()\n\nstart:\ngss(\"OnName\", \"<color=#FF0000><b>PLEASE INPUT CUSTOM NAME IN HERE</b></color>\")\ngss(\"<size=0>\", \"##--STARTHIDING--##\")\nCdTTRunning = CdTTRunning == false ;starts true, if called again goes false and ends script\nRegionCycle = RegionCycle\nClickPos = ClickPos\ndifficultyClickPositions = \"112.0;145.0;182.0;217.0;256.0;290.0;</size><color=\" . if(CdTTRunning, \"#00FF00\", \"#FF0000\") . \">\" \ngss(gsg(\"OnName\") . if(false, \"\", \"<size=0>\"), \"</size></color><color=\" . if(RegionCycle, \"#FF0000\", \"#00FF00\"))\ngss(\"Cycle Region<size=0>\", \"</size>\")\nloop:\nexecutesync(\"{package}:{logic}\")\nwaituntil((tower.health(false) == 0.0) && isTowerTesting())\nexit()\ngotoif(loop, CdTTRunning)\ngu(gsg(\"OnName\"))"],["Instant Restart || Stats Button","\n:import Tower_Automation lib\n:name {package}:{toggles}\n\nkey.r() ;restart\nkey.t() ;stats\n\nisTowerTesting()\n\ngotoif(stats, impulse() == \"key.t\")\n\nrestart:\nrestart()\n\nstats:\n{click.relative(230.0/800.0, 275.0/450.0, 0.5, 0.5)}"],["Region Cycle Toggle || Region Move","\n:import Tower_Automation lib\n:name {package}:{region}\n\n:global bool CdTTRunning\n:global bool RegionCycle\n\nkey.w() ; toggle cycle\n\n\ngotoif(toggleCycle, contains(impulse(), \"key.\") || CdTTRunning == false)\n\nmoveRegion:\nwaitwhile(isTowerTesting() && RegionCycle)\ngotoif(99, RegionCycle == false)\nshow(\"towertesting\", true)\nwait(0.2)\n{click.relative(290.0/800.0, 201.0/450.0, 0.0, 1.0)}\nwait(0.2)\nshow(\"towertesting\", false)\ngoto(99)\n\ntoggleCycle:\nRegionCycle = (RegionCycle == false)\n"],["Difficulty Move || Auto Exit","\n:import Tower_Automation lib\n:name {package}:{difficulty}\n\n:global double ClickPos\n\ngame.newround()\nkey.e()\n\ngotoif(changeDiff, contains(impulse(), \"{package}\"))\n\nexit:\nwait(if(impulse() == \"game.newround\", 10.0, 0.0))\nexit()\ngoto(99)\n\nchangeDiff:\nshow(\"towertesting\", true)\nwait(0.2)\n{click.relative(395.0/800.0, ClickPos/450.0, 0.0, 1.0)}\nwait(0.2)\n{click.relative(162.0/800.0, 97.0/450.0, 0.0, 1.0)}\n"],["Movement Logic","\n:import Tower_Automation lib\n:name {package}:{logic}\n\n#subList sub(difficultyClickPositions, index, index(difficultyClickPositions, \";\", index) - index)\n\n:global double ClickPos\n:local int index\n:global string difficultyClickPositions\n\n\n\ngotoif(99, false)\nloop:\nwaitwhile(isTowerTesting()) \n; waits until the restart triggers from auto restart\n\nClickPos = s2d({subList}, 290.0) \n; sets the new position to go to diff\n    \nexecutesync(\"{package}:{difficulty}\") \n; runs position\n    \nindex = (index(difficultyClickPositions, \";\", index) + 1) \n; updates index to set up next click\n    \nwaituntil(isTowerTesting()) \n; run waituntil to make sure we get in TT before updating region if needed\n\nrepeat:\ngotoif(loop, {subList} != \"\") ; if next click is blank, list is over so lets restart\nexecutesync(\"{package}:{region}\") ; when there's no diffs start the region move\nlu(\"index\") ; remove this once I fix index\ngoto(loop)\n\n\n\n\n"]]}}
```
