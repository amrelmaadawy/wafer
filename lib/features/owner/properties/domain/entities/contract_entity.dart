import 'package:equatable/equatable.dart';

class ContractEntity extends Equatable {
  final int id;
  final String contractNumber;
  final String status;
  final String statusLabel;
  final String contractType;
  final String? startDate;
  final String? endDate;
  final bool isExpired;
  final num totalRentValue;
  final num amount;
  final String unitName;
  final String renterName;

  const ContractEntity({
    required this.id,
    required this.contractNumber,
    required this.status,
    required this.statusLabel,
    required this.contractType,
    this.startDate,
    this.endDate,
    this.isExpired = false,
    this.totalRentValue = 0,
    this.amount = 0,
    required this.unitName,
    required this.renterName,
  });

  @override
  List<Object?> get props => [
    id,
    contractNumber,
    status,
    statusLabel,
    contractType,
    startDate,
    endDate,
    isExpired,
    totalRentValue,
    amount,
    unitName,
    renterName,
  ];
}
