# IncludeUpdator

I have old C++ projects which still use the '.h' extension for the header files.  
I can easily rename the files with a shell command.  
But the source code must be updated too, namely the #include directives.  
I decided to write a simple application in Elixir to do it for me.  
It assumes that the files are already renamed and updates only '.hpp' and '.cpp' files.   
An include directive is updated only if:
  - it uses quotation marks: `#include "header.h"`
  - begins with `#include`, ignoring whitespaces. (which means commented-out directives will be skipped)
  - includes a '.h' file    
Other source is left untouched.  

## Example  
### Before:  
```c++
#include "some_header.h"
#include   "  another_header.h  "
//#include "untouched.h"
#include <functional>

int f();
double g();
```

### After:
```c++
#include "some_header.hpp"
#include   "  another_header.hpp"
//#include "untouched.h"
#include <functional>

int f();
double g();
```
