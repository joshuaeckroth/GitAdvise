# Git Planner

## Java connector

Build:

```
javac -cp /opt/swiprolog/lib/swipl-7.4.0-rc2/lib/jpl.jar PlanWrapper.java
```

Run:

```
LD_PRELOAD=/opt/swiprolog/lib/swipl-7.4.0-rc2/lib/x86_64-linux/libswipl.so \
    java -Djava.library.path=/opt/swiprolog/lib/swipl-7.4.0-rc2/lib/x86_64-linux/ \
        -cp .:/opt/swiprolog/lib/swipl-7.4.0-rc2/lib/jpl.jar PlanWrapper
```

Example output:

```
swipl.version = 7.4.0
swipl.syntax = modern
swipl.home = /opt/swiprolog/lib/swipl-7.4.0-rc2
jpl.jar = 7.4.0-alpha
jpl.dll = 7.4.0-alpha
jpl.pl = 7.4.0-alpha
consult('gitplanner.pl') succeeded
...
All solutions:
========= Solution 1 ==========
add 'prolog/b.txt'  ==> 'Changes prolog/b.txt state from untracked to addedToIndex'
commit  ==> 'No expl!'
========= Solution 2 ==========
commit  ==> 'No expl!'
add 'prolog/b.txt'  ==> 'Changes prolog/b.txt state from untracked to addedToIndex'
commit  ==> 'No expl!'
```

## Contributors

- Michael Clay
- Joshua Eckroth

