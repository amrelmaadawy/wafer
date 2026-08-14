import 'package:equatable/equatable.dart';

class ScopeValueId extends Equatable {
  final Object value;

  const ScopeValueId._(this.value);

  factory ScopeValueId.from(dynamic val) {
    if (val is ScopeValueId) return val;
    if (val is int) return ScopeValueId._(val);
    if (val is String) return ScopeValueId._(val);
    throw FormatException('ScopeValueId must be int or String, got ${val.runtimeType}: $val');
  }

  /// Converts the underlying value to JSON, preserving its original type.
  Object toJson() => value;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value.toString();
}
