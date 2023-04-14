import 'package:who_called_me/who_called_me.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';


caller(Function f) {
  return f();
}

callerCaller(Function f) => caller(f);


main(){
  group("Calling tests",(){
    test("caller finds correct call stack",(){
      var callers = callerCaller(() => Caller.callStack);
      expect(callers[2]?.functionName, "caller");
      expect(callers[3]?.functionName, "callerCaller");
    });
    test("caller finds correct parent",() {
      expect(callerCaller(() => Caller.whoCalledMe)?.functionName, "caller");
    });
    test("caller finds correct grandparent",() {
      expect(callerCaller(() => Caller.whoCalledWhoCalledMe)?.functionName,
          "callerCaller");
    });
    test("caller finds correct self",() {
      expect(Caller.whoAmI?.functionName, "main.<anonymous closure>.<anonymous closure>");
    });
  });
}
