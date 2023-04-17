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
      for(final caller in callers) {
        print(caller);
      }
      expect(callers[1]?.functionName, "caller");
      expect(callers[2]?.functionName, "callerCaller");
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
