import 'package:equatable/equatable.dart';

class UnitsStatusPropertyEntity extends Equatable {
  final int id;
  final String name;
  final String code;

  const UnitsStatusPropertyEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}
