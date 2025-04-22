This is a script made for standardisation.<br>
It is made to act as a dependency for complex scripts that require it to achieve optimal performance. Do keep in mind that, even tho the primary purpose of this logic is to increase performance, there's nothing stopping you from using this script to make your script logic easier either, it's just unlikely that the end result is easier because you added this script.

You can read below to understand why scripts need what this does, or jump to the imports

## Why this exists

As of update `0.49.0`, when the execution budget got implemented, scripts that require high execution speeds are more accessible than they were before (when TE2.2 was required), setting a standard helps new developers understand the limitations they'll have to overcome, and helps experienced developers work with the tools they have at their disposal.

The logic inside of this package makes it possible for you to extend your execution runtime by removing the complications that come with high execution speeds.

## What this does

All that this script does is to stop the script that called it and then create a new instance of it.

#### ***But why***

The maximum execution budget that a script can have is 10000 (10 ^ 4).<br>
Since this is not infinite, scripts that require more budget need to execute themselves, thus effectovely turning their budget of 1e4 into a budget of 2e4, and then 3e4 and so on until they're done.<br>
While doing this works in theory, you can reach at most a budget of 1e6, which is still not infinite. This limitation is caused by what I'll refer to as the "execution stack".

## The execution stack

The execution stack keeps count of all running scripts in the order that they're executed, be it from an impulse, an `execute()` or `executesync()`. This stack is used to dictate how scripts are run, once the script above ends, the script after it starts, but it still keeps track of the script that stopped execution, be it because it hit an action that drained its budget or because it passed the last action. These "dead" instances are then removed from the execution stack once the frame passes.

There can be up to 100 scripts on the execution stacks before Facility AI stops creating new script instances on the execution stack, once the frame passes, if there are more than 100 running scripts on the stack (meaning that no scripts got removed from the cleanup), Facility AI crashes, turning off the AI overlay.

## How this prevents the crash

To re-iterate, the execution stack removes all "dead" instances once the frame ends, key phrase being `"dead" instances`. The stop() action does not create such instances, but instead removes all instances of the stop()'ed script from the execution stack, so stop()ing and creating a new instance of the script we just stop()'ed lets more instances run. For even better control, the script we just executed can also stop us as well, to have the full execution stack at their disposal again.

### Why this isn't done internally

As explained in [Why this exists](#why-this-exists), fast execution is more accessible now than it was before, so more scripts would require this budget "acceleration". If 20 scripts use this system, even if the core program is in just 1 script, their package requires 2 scripts, so having 20 such scripts would mean that 40 script slots are taken up, and 20 of are the same 2 lines, just with a different script that they're stop()ing and execue()ing.

If you'd think that this stop/execute() system could be inserted in the same script as the logic script, that doesn't work for 2 reasons:
1. The turbo bug will exist up until version 1.0.0, so until then, if a script stop()s itself, all running scripts will be turbo-ified, which you should avoid at all costs.
2. Even after the turbo bug is patched out, once a script stop()'s itself, it's removed from the execution stack, so it can't reach the next action to execute() another worker instance of itself.

# The imports

For the source code, you'll have to go over to [the manual](./MANUAL.md), which explains what the source offers you.

The game import has 2 scripts.<br>
First is `BudEx init`, this script is not inside of the package, as its sole purpose is to initialize the accelerator. This script starts as soon as you activate the AI overlay and it calls the accelerator to let all scripts that use this know if you've installed the package or not.<br>
Second is `BudEx:accelerate`, this script is within a package to not interfere with any script that called "accelerate", this is what the script will use to accelerate their budget

### Requirements

- 2 scripts
- 1 max impulse
- 0 conditions
- 3 max actions
- max budget_cap of 200, but the scripts that use this will likely require a max budget_cap of 10000

```
fZHBbsMgDIZfZfMZZSSbNilqe6jUp1hyIMRFqAkgMFq1qu8+wdKt69gugO1f9u+PEwTptaMA7esJhCRtTXpDFzmvazXZQUxVIK+NqgJSN0hrAglDScCfsuxxFfQ7rvlmG8fdsQokCEtC/rJ6SMoNMOj2Cg16LatA1uUqflqp9OziFDCJUvpLiEeUkbCo7RlIa0Z98d8zWEpLZMSM0IKQEif0glJ7J+RBqJTOxoHBEEeFBG3DOYMYcLvE5COe2S9AHC/elCWr9zdLNzJf/Pasa2lnJ7wO1ixsS0sVETb362L++U0cMLo/oZX+jee12ysm/2OEZcY3ztzgThtNP3BekaxLJPvzBw==
```
