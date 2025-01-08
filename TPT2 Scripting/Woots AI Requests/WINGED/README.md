# WINGED

This is a general era disabler that you can easily modify ingame to choose the order in which you'd like to disable the era abilities.<br>

It uses a block hider to determine if the user reset or not. This is accomplished by taking a global snapshot of time.tick() on startup and checking against a local copy to see if another script has started up.

It builds a priority list through the local string variable "era_priority" by having 10 actions that each concatenates ontop of the variable a new era ability name. Since all of these are separate actions, you can simply drag them up or down to change which element is prioritized first.

The Disable sequence is also rather simple. It uses a helper variable "era" to get the element name. Era is the substring of era_priority at position idx of length index(era_priority, "|", idx) - idx. We have to subtract idx from this index to get the true element size because the value returned by index() is taken from position 0.0 + offset.

Then, we wait until we have enought xp to disable the era power or we've detected a restart.<br>
Neat little trick here is that, if we're outside of towertesting, disable cost becomes -1 but the xp becomes 0, so -1 < 0 is true, thus we exit the waituntil<br>
Once we pass this waituntil, we try to disable the era power. We exit if we've detected a restart or if we're no longer in towertesting, otherwise, if we didn't disable the era power, we go back to the waitwhile, else we increase our idx.

When we increase idx, we turn it into 1 + index(era_priority, "|", idx). This index will give us the next position of `|`, thus taking us to the next era name, and we add 1 so we're pointing past the `|` character

A nice fact about index is that it'll return -1 if it can't find the character sequence you're looking for, this means that, if we've reached the end of our string, we'll give idx the value of 1 + -1 which is 0. So the script will stay in the loop as long as we're in towertesting and idx > 0.
If idx == 0, 0 > 0 is false as zero is not bigger than zero.

# AI import
```
zVfNbhMxEH6V4kMvhGWT9Eeqkh4QCLjAgUocSFV5vbObURx7NZ4lDW3fiTdAghdD9qZtmjohgQrtZXY1np9vfjy2r4RThBU7cfLlSkjFaI3/F6M6TVMotc2kTtBw4oBHmbLGsTQcVg887fYHDr/BMD0lcMB7agxqMjKMU0gKklMQHTEibdUGMxRUL5SdVpLgkedyB8/em1/rLvQdE5pyLfjuJ7bV3jvM0ZR7r7RVk5hYejx46V2d3lpPm3g2GC+A5EVFaAl5HnhHyholOaIfi++hfgzTgUS6bgsgziVNDDjXGkTBHkjicWsgFaBBMaFCnrcGlKeHBRK0CtGRxnLMrYJ0bCTXLUpTZqBmkro1gExt8CuQaxGkYG8mGXaZlJ72geSIXZ01cn8FZstjLO1jftkIS0IeT4FReYWGt3CHJofLj8WTZaV7vRu+qI0XO9m4P5rBAKFKZhK5Now6iBTN8Y/OmiSzVjeyS8zc1pkOt4PuYSmnkOToZKYhAZKJsm7blrmrbzSmwYgrLedAyWUVlehdL1K3BM1Xa+mOE/O6cseJWn42fJK7T7qanR0T4+0Ut0UqLduwkjGQkTS/a81YwVqYlY1F7BvbtE0/5AzdmZ0BnYFjv+sfavZU+KSP6Gpm/n/X9obDFX5/DdYH9Nf3nz9WgwxwehGNiFxaPJZbNOE2T4f1ky/mq/tHTIsd/LxNg/M+HUv7CYtohLCmTtHJuEXDLnpjfz+6M/99/J9Go4j0mTjvCGVNjrevy/OOwGlVawfhrRlCMTAjW5vcCxv/bjwRn99/ePvmteiISqqJLD1L3Jzf/AY=
```

## AI Requirements
- 1 impulse
- 0 conditions
- 19 actions
- 1 script
- no budget cap

# AI Source

To see the AI source, you just have to look at [WINGED.tpt2](WINGED.tpt2).