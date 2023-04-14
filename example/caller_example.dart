import 'package:caller/caller.dart';

void debug(s) {
  var caller = Caller.whoCalledMe;
  print("$s happened at ${caller?.path}");
}

void main() {
  debug("hello");
  f();
}

void f() {
  debug("world");
}