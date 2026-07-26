import 'package:equatable/equatable.dart';

class UnitsStatusStatusFilterEntity extends Equatable {
  final String value;
  final String label;

  const UnitsStatusStatusFilterEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class UnitsStatusPropertyFilterEntity extends Equatable {
  final int id;
  final String? name;
  final String code;

  const UnitsStatusPropertyFilterEntity({
    required this.id,
    this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}

class UnitsStatusFilterOptionsEntity extends Equatable {
  final List<UnitsStatusStatusFilterEntity> statuses;
  final List<UnitsStatusPropertyFilterEntity> properties;

  const UnitsStatusFilterOptionsEntity({
    required this.statuses,
    required this.properties,
  });

  @override
  List<Object?> get props => [statuses, properties];
}
