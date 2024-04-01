## Fragzilla originally made by Florin_TK on [discord](https://discord.com/channels/488444879836413975/1223940533844705320)

```
{"workspaces":{"fragment something":[["WS.Fragzilla:Activate","key.w()\n\nisopen(\"towertesting\") || isopen(\"workshop\")\n\nexecute(\"WS.Fragzilla:Configuration\")\nexecute(\"WS.Fragzilla:Farm\")"],["WS.Fragzilla:Configuration",":global double latency\n:global double farm_duration\n:global int hammers\n\nhammers = 3\nfarm_duration = 3.0\nlatency = 0.75"],["WS.Fragzilla:Farm",":global double farm_duration\n:global double latency\n\nisopen(\"towertesting\") || isopen(\"workshop\")\n\ngotoif(6, isopen(\"towertesting\"))\nclick(vec(1530.0, 840.0))\nclick(vec(1890.0, 1050.0))\nwait(latency)\nclick(vec(461.0, 1024.0))\nclick(vec(150.0, 50.0))\nwait(farm_duration)\nexecute(\"WS.Fragzilla:Hammer\")"],["WS.Fragzilla:Hammer",":local int remClicks\n:global int hammers\n\nisopen(\"towertesting\")\n\nclick(vec(1890.0, 1050.0))\nclick(vec(1890.0, 1050.0))\nclick(vec(1220.0, 1024.0))\nwait(0.75)\nclick(vec(600.0, 80.0))\nremClicks = hammers\nclick(vec(1473.0, 250.0))\nremClicks = remClicks - 1\ngotoif(7, remClicks != 0)\nexecute(\"WS.Fragzilla:Farm\")"],["WS.Fragzilla:Stop","key.s()\n\nisopen(\"towertesting\") || isopen(\"workshop\")\n\nstop(\"WS.Fragzilla:Farm\")\nstop(\"WS.Fragzilla:Hammer\")\ngu(\"farm_duration\")\ngu(\"hammers\")\ngu(\"latency\")"]]}}
```

## What do

- no clue
