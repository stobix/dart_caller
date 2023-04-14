A simple utility to extract info about who called a function.

Simply call `Caller.whoCalledMe` to get a `Caller` instance with info about the calling function, such as path, line number etc.

Useful every time you wish you'd know who called your function, which for me seems to be all the time when I'm debugging.

Handles `package:` and `file:` paths.

## Usage

Just call one of `Caller.whoCalledMe`, `Caller.whoCalledWhoCalledMe` or `Caller.whoAmI` to get a Caller instance with info about the caller, the caller's caller or the function you're in, respectively.

## Example



main.dart:
```dart
void main() {
  someFun();
  //  Will print out either 
  // `Called by 'main' in file://main.dart 2:2` 
  //  or 
  // `Called by 'main' in package:yourPackage/main.dart:2:2`
  //  depending on calling context. 
  // Both links seems to be clickable and take you to the correct calling location if you click it, at least in Android Studio.
  f();
}

void f(){
  someFun();
  // Prints out either
  // `Called by 'f' in file://main.dart 13:2` 
  //  or 
  // `Called by 'f' in package:yourPackage/main.dart:13:2`
}


void someFun() {
  var caller = Caller.whoCalledMe;
  print("Called by '${caller.functionName}' in ${caller.path}");
}

```
