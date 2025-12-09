# Version History

### 1.2
Added crates_per_second calculation given the new resource("crates").<br>
Updated [Main](Main.tpt2) to new budget_exec version.<br>
Removed the frame counter entirely since the bug that it was in place to prevent should have been fixed.

### 1.1
Add versioning to the package.<br>
Half the maximum number of frames from 50000 to 25000 to prevent large memory usage.<br>
This has the side effect of lowering how effective the AI is, but it's better than risking a crash.

### 1.0
Original release of C0D.Trader.<br>
Package has no version.