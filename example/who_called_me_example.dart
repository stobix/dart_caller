import 'package:who_called_me/who_called_me.dart';

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