# User Manual

To use the package, it's recommended that you first import the library via

```
:import budget exec_lib
```

After that, you can request an acceleration by using

```
execute("{accelerate_budget}")
```

Which can be inside of a ternary, exaple taken from D0S.Crates:Idler_v3:

```
execute(if(\
  loops % traders == 0,\
  "{accelerate_budget}",\
  "{package(Idler_v3)}"\
))

end:
```

Since the execution stack does not move to the next script until the active script stops running (from running out of budget or running past the final action), you can start the next script before you start working if you can guarantee that you'll need more budget.

To check if your script can access the budget accelerator, you check

```
global.string.get(budget_exec_var) == "</size>"
```

If true, then it should be safe to run the script.<br>
There is, however, nothing stopping the user from deactivating the package after the budget_exec_var was set, or from someone else setting budget_exec_var to `</size>` directly while not having this package.

The only way to truly guarantee that the script is running is by having a sequence similar to

```

gotoif(skip_check, impulse() == "{accelerate_budget}")

executesync("{accelerate_budget}")
skip_check:

checker = checker || impulse() == "{accelerate_budget}"
```

In this example, checker is a boolean, it's false by default and becomes true if the accelerator really is up and running.<br>
This extra precaution is likely useless to include into your code, as any user should expect things to break if they manipulate budget_exec_var directly or disable the package after startup, but it's your choice.

## Impulse rules

If your script can activate via `impulse: wakeup()`, please make it a package.<br>
As explained in [init](init.tpt2), the game executes the scripts outside of packages before those in packages, so if your script is executed before the budget exec is initialized, you could end up throwing an error when the user does have the script installed and running correctly.

If you'd rather not use a package, you can place a sequence like

```
gotoif(no_wakeup, impulse() != "wakeup")
waitframe()
no_wakeup:
```

So you can guarantee that your script is running after budget_exec_var has been set. But, if you're going through the effort to do this, you might as well just put your script in a package

# Import

To take full advantage of the script, you should make sure that you understand _why_ you want to use it.<br>
You should avoid adding dependencies if you can, as the end user can, and is likely to, not import them and you'll have to tell them why they can't use the script.<br>
Being able to guarantee that everything your script needs to function is in your own import is the best course of action.

```
{"workspaces":{"budget exec":[["budget exec_lib","#budget_exec BudEx\n; This is the identifier for the script. It's also the scripts package name\n\n#accelerate_budget {budget_exec}:accelerate\n; The purpose of this library is so that people can use this macro\n; so that they can update their scripts with ease if the name gets updated\n\n:const string budget_exec_var \"<size=0>{budget_exec}.state\"\n; A hiding block that's used to signal to scripts that use this library\n; if the user has the package installed or not"],["accelerate",":import budget exec_lib\n:name {accelerate_budget}\n; Set the scripts name\n; This is its own package so that people can have scripts called \"accelerate\"\n; without interfering with this package\n\n:budget_cap 200\n; budget cap of 200 so that every action is done instantly\n\nglobal.string.set(budget_exec_var, \"</size>\")\n; Signal to any scripts that use this library that we're up and running.\n; If the user shuts us off afterwards, that's on them, as we can't protect against that\n;\n; We're woken up by our init script, which is outside the package, so that we're started before\n; any other script that might require us.\n;\n; budget_exec_var isn't set in the init script, as no other script is meant to interact with it\n; we're the ones that scripts use, so init should make sure that we're working properly\n\n\nstop(impulse())\n; Stop the script that has called us and remove all instances of the parent from the execution queue\n;\n; Start the script that we just stopped so it can continue execution\nexecute(impulse())"],["init",":import budget exec_lib\n:name {budget_exec} init\n; Set the scripts name\n; This is not included in the package so that impulse:wakeup() initializes our package\n\n:budget_cap 100\n; budget cap of 100 so that every action is done instantly\n\nwakeup()\n; This script will start once the user first activates the AI overlay.\n; As scripts outside of packages are executed before scripts in packages,\n; we guarantee that every package that uses our library start\n; after budget_exec_var has been initialized\n; \n\ngotoif(99, impulse() != \"wakeup\")\n; We kill the instance if our impulse wasn't wakeup, as we've already initialized the variable\n;\n; If we're here, we want to initialize budget_exec_var by starting up our package.\n; If budget_exec_var is empty after this initialization,\n; the script that uses this package will show an error\nexecute(\"{accelerate_budget}\")"]]}}
```
