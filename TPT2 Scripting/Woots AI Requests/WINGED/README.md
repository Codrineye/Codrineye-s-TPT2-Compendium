# WINGED

This is a general era disabler that you can easily modify ingame to choose the order in which you'd like to disable the era abilities.

It uses a block hider to determine if the user reset or not. This is accomplished by taking a global snapshot of time.tick() on startup and checking against a local copy to see if another script has started up.

It builds a priority list through the local string variable "era_priority" by having 10 actions that each concatenates ontop of the variable a new era ability name. Since all of these are separate actions, you can simply drag them up or down to change which element is prioritized first.

The Disable sequence is also rather simple. It uses a helper variable "era" to get the element name. Era is the substring of era_priority at position idx of length index(era_priority, "|", idx) - idx. We have to subtract idx from this index to get the true element size because the value returned by index() is taken from position 0.0 + offset.

Then, we wait until we have enought xp to disable the era power or we've detected a restart.<br>
Neat little trick here is that, if we're outside of towertesting, disable cost becomes -1 but the xp becomes 0, so -1 < 0 is true, thus we exit the waituntil<br>
Once we pass this waituntil, we try to disable the era power. We exit if we've detected a restart or if we're no longer in towertesting, otherwise, if we didn't disable the era power, we go back to the waitwhile, else we increase our idx.

When we increase idx, we turn it into 1 + index(era_priority, "|", idx). This index will give us the next position of `|`, thus taking us to the next era name, and we add 1 so we're pointing past the `|` character

A nice fact about index is that it'll return -1 if it can't find the character sequence you're looking for, this means that, if we've reached the end of our string, we'll give idx the value of 1 + -1 which is 0. So the script will stay in the loop as long as we're in towertesting and idx > 0.<br>
If idx == 0, 0 > 0 is false as zero is not bigger than zero.

# AI import
```
zVfNbtswDH6VTIdelnlO0j8ETQ/Fhm2X7bACOyxFIcu0Q0SRDIpemjV9p77BgO3FBtlpl6RKmhbF4AttUKT48VfStXCKsGAn+t+vhVSM1vh/MSzjOIZc20TqCA1HDniYKGscS8PV6r6nnd6Jw58wiE8JHHBLjUCNh4ZxAlFGcgKiLYakrdqyDVWql8pOCknwwHL+BMveml/rLPQdE5p8I/jjr2yL1rdPnz+8f9f6iCmavHWmrRqHpOOjk7fe4umdkbh2a4uNDEheFoSWkGcV71BZoyQH9ENuruqHMO1LpHlTAHEqaWzAucYgqvYDSTxqDKQMNCgmVMizxoDy9CBDgkYhOtSYj7hRkI6M5LJBYUoMlExSNwaQKQ3+AHINglTtN5UMT5mUnvaA5JBdmdRyzwKzdPZtOMjiHqZX9aknCXk0AUblFWrewhKaFK6+ZC8WkM58Z2hB9Te7qv87ksEAoYqmErk0jLoSyepjH501UWKtrmWXmKktE13dCjoHuZxAlKKTiYYISEbKul1r5D6hQXdOhlxoOQOKroqgRHc+r/OxBM3n6JEorN1tgju/GrzInSdej84TA+P3ye6SlFu21UrCQEbS7L4gQwlrYFS2JrFnbF02vSpm6M7tFOgcHPs2X9XsquoTP6Drkfn/VdsdDNb4vQ1YV+if29+/1p2s4HQDGgG5OHsot8M1f+uoC5npPApn0byvGzIpF50Yw3IXYRZ0DjZkJzgPdyjTRUXs7T2nH7eP+tOgA4HCEhdtoaxJ8e4ZedEWOClK7aB6VFZeGJiSLU3qhY1/IPZF/QATbVFINZa5Z4m2SMo0Bxb9znEct0Xp4GzBYCrh5uLmLw==
```

## AI Requirements
- 1 impulse
- 0 conditions
- 19 actions
- 1 script
- optional budget cap of 1800 if you want it to exit quickly.

# AI Source

To see the AI source, you just have to look at [WINGED.tpt2](WINGED.tpt2).