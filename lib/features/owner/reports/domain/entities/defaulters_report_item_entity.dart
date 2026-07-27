import 'package:equatable/equatable.dart';

class DefaulterContractEntity extends Equatable {
  final int id;
  final String contractNumber;
  final String status;
  final String statusLabel;
  final String startDate;
  final String endDate;
  final double totalRentValue;

  const DefaulterContractEntity({
    required this.id,
    required this.contractNumber,
    required this.status,
    required this.statusLabel,
    required this.startDate,
    required this.endDate,
    required this.totalRentValue,
  });

  @override
  List<Object?> get props => [
        id,
        contractNumber,
        status,
        statusLabel,
        startDate,
        endDate,
        totalRentValue,
      ];
}

class DefaulterRenterEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String userType;

  const DefaulterRenterEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
  });

  @override
  List<Object?> get props => [id, name, email, phone, userType];
}

class DefaulterPropertyEntity extends Equatable {
  final int id;
  final String name;
  final String code;

  const DefaulterPropertyEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}

class DefaulterUnitEntity extends Equatable {
  final int id;
  final String name;
  final String unitNumber;
  final String status;
  final String statusLabel;

  const DefaulterUnitEntity({
    required this.id,
    required this.name,
    required this.unitNumber,
    required this.status,
    required this.statusLabel,
  });

  @override
  List<Object?> get props => [id, name, unitNumber, status, statusLabel];
}

class DefaultersReportItemEntity extends Equatable {
  final int id;
  final int installmentNumber;
  final String dueDate;
  final double amount;
  final double paidAmount;
  final double remainingAmount;
  final double daysOverdue;
  final DefaulterContractEntity contract;
  final DefaulterRenterEntity renter;
  final DefaulterPropertyEntity property;
  final DefaulterUnitEntity unit;

  const DefaultersReportItemEntity({
    required this.id,
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.daysOverdue,
    required this.contract,
    required this.renter,
    required this.property,
    required this.unit,
  });

  @override
  List<Object?> get props => [
        id,
        installmentNumber,
        dueDate,
        amount,
        paidAmount,
        remainingAmount,
        daysOverdue,
        contract,
        renter,
        property,
        unit,
      ];
}
