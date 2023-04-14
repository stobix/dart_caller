A simple utility to extract info about who called a function.

Simply call `Caller.whoCalledMe` to get a `Caller` instance with info about the calling function, such as path, line number etc.

Useful every time you wish you'd know who called your function, which for me seems to be all the time when I'm debugging.

Handles `package:` and `file:` paths.

## Usage

someFun.dart:
```dart
void someFun() {
  var caller = Caller.whoCalledMe;
  print("I got called by ${caller.functionName} in ${caller.path}");
}
```

main.dart:
```dart
void main() {
  someFun();
}
```
Will print out `I got called by main in file://main.dart 2:2`