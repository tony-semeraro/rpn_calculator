## rpn_calculator A console based RPN calculator


### Features:

 - supports `+`, `-`, `/` and `*` math operations
 - stack reset with `c`, `r`, `clear`

Interactive cli interface for a simple, stack based rpn calculator.

Launch from the terminal as follows from the root of this repo:
`bin/console`

Typing a number and enter will push it onto the stack. The contents of the entire stack are visible. Enter key on an empty line will quit the calculator.

 ### simple demo:
```
%bin/console
1 (enter)
-> 1.0
1 (enter)
-> stack: 1.0, 1.0
+ (enter)
-> 2.0
(enter to quit)
```

Piping and input files are also supported
```
# one plus one
% echo  '1 1 + '| bin/console
2.0

# average three numbers
% echo '1 2 3 + + 3 /' | bin/console
2.0

# input file
% echo  '1 2 -' >> testfile
% bin/console testfile
-1.0
```

### Tests:
`rake test # from root of project`


