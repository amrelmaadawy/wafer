import 'package:equatable/equatable.dart';

class ContractsMovementItemEntity extends Equatable {
  final String contractNumber;
  final MovementRenterEntity renter;
  final MovementPropertyEntity property;
  final MovementUnitEntity unit;
  final String date;
  final String type;
  final double rentValue;
  final String status;
  final String statusLabel;

  const ContractsMovementItemEntity({
    required this.contractNumber,
    required this.renter,
    required this.property,
    required this.unit,
    required this.date,
    required this.type,
    required this.rentValue,
    required this.status,
    required this.statusLabel,
  });

  @override
  List<Object?> get props => [
    contractNumber,
    renter,
    property,
    unit,
    date,
    type,
    rentValue,
    status,
    statusLabel,
  ];
}

class MovementRenterEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String userType;

  const MovementRenterEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
  });

  @override
  List<Object?> get props => [id, name, email, phone, userType];
}

class MovementPropertyEntity extends Equatable {
  final int id;
  final String name;
  final String code;

  const MovementPropertyEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}

class MovementUnitEntity extends Equatable {
  final int id;
  final String name;
  final String unitNumber;
  final String status;
  final String statusLabel;

  const MovementUnitEntity({
    required this.id,
    required this.name,
    required this.unitNumber,
    required this.status,
    required this.statusLabel,
  });

  @override
  List<Object?> get props => [id, name, unitNumber, status, statusLabel];
}
