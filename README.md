A simple utility to extract info about who called a function. Simply call `Caller.whoCalledMe` to get a `Caller` instance with info about the calling function, such as path, line number etc.

## Usage

```dart
void someFun() {
  var caller = Caller.whoCalledMe;
  print("I got called by ${caller.functionName} in ${caller.path}");
}
```
