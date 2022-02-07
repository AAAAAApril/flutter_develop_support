///函数多返回值包装类
///Tips：在需要同时返回多个值的时候也许会用到
class FuncResult2<A, B> {
  const FuncResult2({
    required this.aValue,
    required this.bValue,
  });

  final A aValue;
  final B bValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuncResult2 &&
          runtimeType == other.runtimeType &&
          aValue == other.aValue &&
          bValue == other.bValue;

  @override
  int get hashCode => aValue.hashCode ^ bValue.hashCode;

  @override
  String toString() {
    return 'FuncResult2{aValue: $aValue, bValue: $bValue}';
  }
}

class FuncResult3<A, B, C> {
  const FuncResult3({
    required this.aValue,
    required this.bValue,
    required this.cValue,
  });

  final A aValue;
  final B bValue;
  final C cValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuncResult3 &&
          runtimeType == other.runtimeType &&
          aValue == other.aValue &&
          bValue == other.bValue &&
          cValue == other.cValue;

  @override
  int get hashCode => aValue.hashCode ^ bValue.hashCode ^ cValue.hashCode;

  @override
  String toString() {
    return 'FuncResult3{aValue: $aValue, bValue: $bValue, cValue: $cValue}';
  }
}

class FuncResult4<A, B, C, D> {
  const FuncResult4({
    required this.aValue,
    required this.bValue,
    required this.cValue,
    required this.dValue,
  });

  final A aValue;
  final B bValue;
  final C cValue;
  final D dValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuncResult4 &&
          runtimeType == other.runtimeType &&
          aValue == other.aValue &&
          bValue == other.bValue &&
          cValue == other.cValue &&
          dValue == other.dValue;

  @override
  int get hashCode =>
      aValue.hashCode ^ bValue.hashCode ^ cValue.hashCode ^ dValue.hashCode;

  @override
  String toString() {
    return 'FuncResult4{aValue: $aValue, bValue: $bValue, cValue: $cValue, dValue: $dValue}';
  }
}

class FuncResult5<A, B, C, D, E> {
  const FuncResult5({
    required this.aValue,
    required this.bValue,
    required this.cValue,
    required this.dValue,
    required this.eValue,
  });

  final A aValue;
  final B bValue;
  final C cValue;
  final D dValue;
  final E eValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuncResult5 &&
          runtimeType == other.runtimeType &&
          aValue == other.aValue &&
          bValue == other.bValue &&
          cValue == other.cValue &&
          dValue == other.dValue &&
          eValue == other.eValue;

  @override
  int get hashCode =>
      aValue.hashCode ^
      bValue.hashCode ^
      cValue.hashCode ^
      dValue.hashCode ^
      eValue.hashCode;

  @override
  String toString() {
    return 'FuncResult5{aValue: $aValue, bValue: $bValue, cValue: $cValue, dValue: $dValue, eValue: $eValue}';
  }
}
