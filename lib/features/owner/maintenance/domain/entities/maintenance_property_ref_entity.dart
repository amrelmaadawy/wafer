import 'package:equatable/equatable.dart';

class MaintenancePropertyRefEntity extends Equatable {
  final int id;
  final String name;

  const MaintenancePropertyRefEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
