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
  final int? propertyId;
  final String? propertyName;
  final int? unitId;
  final String unitName;
  final int? tenantId;
  final String? tenantName;
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
    this.propertyId,
    this.propertyName,
    this.unitId,
    required this.unitName,
    this.tenantId,
    this.tenantName,
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
    propertyId,
    propertyName,
    unitId,
    unitName,
    tenantId,
    tenantName,
    renterName,
  ];
}
