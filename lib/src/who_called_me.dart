class PackageCaller extends Caller {
  PackageCaller._(
      {required super.stackPos,
      required super.functionName,
      required super.package,
      required super.fileName,
      required super.lineNumber,
      required super.columnNumber})
      : super._();

  @override
  String get path => "package:$package/$fileName:$lineNumber:$columnNumber";
}

class FileCaller extends Caller {
  FileCaller._(
      {required super.stackPos,
      required super.functionName,
      required super.fileName,
      required super.lineNumber,
      required super.columnNumber})
      : super._(package: null);

  @override
  String get path => "file://$fileName $lineNumber:$columnNumber";
}

/// Contains info on the calling function.
abstract class Caller {
  /// The position in the stacktrace.
  final int stackPos;

  /// The name of the calling function.
  final String functionName;

  /// The name of the package, if available, else null.
  final String? package;

  /// The file name of the calling function.
  final String fileName;

  /// The line number of the file of the calling function.
  final int lineNumber;

  /// The column of the line of the file of the calling function.
  final int columnNumber;

  /// A path to where the function got called, either a `file:` or a `package:` path.
  String get path;

  Caller._({
    required this.stackPos,
    required this.functionName,
    required this.package,
    required this.fileName,
    required this.lineNumber,
    required this.columnNumber,
  });

  @override
  String toString() => "Caller( $functionName $path )";

  static Caller? _parseCaller(String s) {
    var packagePattern = RegExp(
        r'^#(?<index>\d+) +(?<fnname>.+) +\((package:)(?<package>[^/]+)/(?<filnamn>.*):(?<ln>\d+):(?<cn>\d+)\)*');
    var filePattern = RegExp(
        r'^#(?<index>\d+) +(?<fnname>.+) +\(file://(?<filnamn>.*):(?<ln>\d+):(?<cn>\d+)\)*');
    var suspensionPattern = RegExp(r'^<asynchronous suspension>');

    var matches = packagePattern.allMatches(s);

    try {
      var match = matches.elementAt(0);
      return PackageCaller._(
          stackPos: int.parse(match.namedGroup("index")!),
          functionName: match.namedGroup("fnname")!,
          package: match.namedGroup("package")!,
          fileName: match.namedGroup("filnamn")!,
          lineNumber: int.parse(match.namedGroup("ln")!),
          columnNumber: int.parse(match.namedGroup("cn")!));
    } catch (e) {
      try {
        var matches = filePattern.allMatches(s);
        var match = matches.elementAt(0);
        return FileCaller._(
            stackPos: int.parse(match.namedGroup("index")!),
            functionName: match.namedGroup("fnname")!,
            fileName: match.namedGroup("filnamn")!,
            lineNumber: int.parse(match.namedGroup("ln")!),
            columnNumber: int.parse(match.namedGroup("cn")!));
      } catch (e) {
        try {
          // Ignoring lines with no info other than "<asynchronous suspension>"
          // ignore: unused_local_variable
          var matches = suspensionPattern.allMatches(s);
          // print("Anonymous closure: ${matches.elementAt(0)} $s");
          return null;
        } catch (e) {
          // print("error parsing $s: $e");
          return null;
        }
      }
    }
  }

  /// Returns info on the function calling the function calling the current function.
  static Caller? get whoCalledWhoCalledMe {
    var frames = StackTrace.current.toString().split("\n");
    frames.removeLast();
    return _parseCaller(frames[3]);
  }

  /// Returns info on the function calling the current function.
  static Caller? get whoCalledMe {
    var frames = StackTrace.current.toString().split("\n");
    frames.removeLast();
    return _parseCaller(frames[2]);
  }

  /// Returns info on the current function.
  static Caller? get whoAmI {
    var frames = StackTrace.current.toString().split("\n");
    frames.removeLast();
    return _parseCaller(frames[1]);
  }

  /// Returns info on each function in the full callstack of the current function.
  static List<Caller?> get callStack {
    var frames = StackTrace.current.toString().split("\n")
      // Skip parsing the last newline
      ..removeLast()
      // Skip parsing the call to callStack
      ..removeAt(0);
    return [...frames.map(_parseCaller)];
  }
}
