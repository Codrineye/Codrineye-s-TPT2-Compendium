# C0D.DustManager

A rework of D0S.DustManager.


This is an ore crushing/dust up-tiering combo. It works stand-alone, but pairs nicely with other factory automation that expects dust to beavailable. It tries to crush any un-crushed ores, and up-tiers dust while trying to make the dust distribution match its built-in target ratios.

`C0D.DustManager 2 1 13`

```
7VxPb9s2FP8qnjC0wOKpkvwnQ9AswVZgp64fYC4MSqIdohIpUNScru11u63n3drrMGy9bbcC1hcb9C9RZNKmZFmRAyKIHMgi+d7vPb734yOVN1roUBSwUDv76Y0GHIYITv7WZpFhmIZHHODpLolsD+ohZDPbIThkALPke2M8w4TCuR0tFpBWvhulV0N0vVy/v9SGd4YJGUV4yR0mfcqNQjb3I4+hwEOQhtWnHpsDc6BPrclAnwx04/SbU2ugG9ORmXyY+a9hmZVhS9ol3Uwdgh3AFcGY5pqm+iErTP+AgCJ25UOGHB3lj1fv0WwohJm+5KtnmIh/+0nltpXJ/vgOpNyWJ7yWhimwyCi03BkLIzszA8cwAsk5hmkXgpFPXBkQhMbI5UfYhdcvFnesvI+WXBUGotv3gwm3y697IcyOAJFd4//iz8l8LQkniA+JcC1PvRNuh82nY/JhM0gxoK9vvdMhfgAoCgne5rFte2kfPCBra52fV5vGn7MfbgAT+YpMHFbhYK880adokmdxAy4hhhQ5+pIwghZcXUShpjr39ogVT6sDrz+sfy0DKWYd1f4WDo3CK0jnDNVlVdn1yyqz2kbg0sHmDPkwbWGW7Jg1ayKBZDTkjdauEOb4kj/+V016/FHQmVCZg0BXU/TB+q8a/pA+FZAVpIEHMJvbhITVp+Qy96cLycQ9CRlgsF4Mb4dz5yPL827Dbmqkms35ZMGcLoDDCH2t+8C5QhjqyYrtZ74Gp3kY2b+niY+uNyKROBnLKs6VyyyF5FJEGBXiIgb9UHdItMHE8uxBaFUJa4YlYbeens9wPjl8hDlThudJ5TVwLVnHCYeQErY7qNgxQcUTtjuoZCdzL6C63wmYxqNjgkskcLeQTY8NMp7A3UI2OTbIeAJ3C9n42CDjCdwtZDwG3GvIRJS9O8h4fLHXkIkIbneQyZZgegOZaG+hj6uPZoDL+rJsmJCNwLLJTZY3yFIyGZYrs2iQX4Pxyn/OZtuiomEW5b8VQGx1hbLJZyxKc9ImxEtvckvtS4/YO8oEMPfWOQNU9Iz1xUYVW9JF8/Zv3woF33+65GM8elS7u6KKkNZyinYOBQtBbPAiP8hA271tIl9j5u/EyN6730rQZnldtim3Ei5a88Iixt6mIP4skJ8arcIoKutLA9nSDNs7XU8QXpJeImR+e5CCcwHc3lGovjiCsnqV7OyuvJ+sf8t0iP+If4//jf+5EJVtt2xL1GRIslFQlhmrKFi/TDkKyKrqC/HHX1Jzjtd//xB/jP+82GbzVm4fyHFU+jyc4xSYcbKqTK5U5urWXJxDJJKYN0tK8jP6hhCfJhbxwXWtlbOMX8nmceVXDcJARgg2qylRG0dFFRvo2JrpWaV+JG9l56NK3spcKnkfInkrUviQkrey5gGt+WS2JUsrIz8MI7d5lHYgPPurOP1D8pgGrhF/uCheIFgUbCCgxI2cnCYW1PH2bTi1caI2TsRXrlybBzuqvHLjdTDlZMrJtl7vUSve8IogHS7dRXW29VWMUDEiuUrsjdc/ndhHqLJabv1zjq3s6O4eVuZFul2HDhr7An/hk26G76XUtldTb8zShI5/2noeQ8LIpddY6xcPDg99pkiyanR7OpkaWq1hPVXRiHuiEWo9q2iEzJXX7c0bxVx90hN/sv+VQeCnpsXICusrhF2y0lFIAoj5ouRG0l4ONYdgF939x1VNukF+EHkhTDtZgVcwCrShlrTUSw9h4EPtTPveeKY/i0L2HGCwTLUOgPMKLJPvtKFmR+4SMu1sZBjGUItC+F1+g9EIvnv57n8=
```

Source code can be found at [C0D.DustManager](C0D.DustManager.tpt2), with a dependency on [Editor_actions lib](../../Editor%20Actions%20lib/README.md).

## Details

Edit the first line which sets the variable `ore_buffer`. The default of 1000 means that 1000 of each ore tier will be kept, although initially it will be crushed so that you have dust to work with. This buffer amount is so that you can scan it with the Crafter. If you've already scanned all the ore tiers, or don't have access to the crafter, you can set `ore_buffer` to 0.

You can edit the second line which sets the variable "dust_multipliers" to customize the ratios, this sets the shape of the target distriburions as a space-separated list. Each number is a multiple of the previous tier dust amount. The default of "1 1 0.625 0.5 0.07872 0.06312 0.01 0.01 0.0021" is based on making high-level producers and should be reasonable for everything.

The newest addition to the editable lines are actions 6, 7 and 8. Together, they determine how much ore to crush based on a defined `crush_time`, which means that your crusher will never be occupied for more than `crush_time` ammount of time.<br>
Line 6 defines the crusher tier, it's assumed that you have a T10 crusher by default.<br>
Line 7 is the crush time. This is a `second + minute + hour` calculation with the default value of 5 minutes.<br>
Line 8 holds your powerplant boost. It's set to 1.0 by default, but you can increase it to your boost if the crusher isn't being used for as long as you'd like.

This version also fixes a newly introduced bug in the original D0S.DustManager where the script would no longer uptier dust if you only have 1 of it.

There's now also a budget_cap of `3000` so that every tier is processed in 1 frame.