import 'package:equatable/equatable.dart';

class ContractItemEntity extends Equatable {
  final String id;
  final String contractNumber;
  final String contractTypeLabel;
  final String propertyName;
  final String unitName;
  final String renterName;
  final String startDate;
  final String endDate;
  final double totalRentValue;
  final String status;
  final String statusLabel;

  const ContractItemEntity({
    required this.id,
    required this.contractNumber,
    required this.contractTypeLabel,
    required this.propertyName,
    required this.unitName,
    required this.renterName,
    required this.startDate,
    required this.endDate,
    required this.totalRentValue,
    required this.status,
    required this.statusLabel,
  });

  @override
  List<Object?> get props => [
    id,
    contractNumber,
    contractTypeLabel,
    propertyName,
    unitName,
    renterName,
    startDate,
    endDate,
    totalRentValue,
    status,
    statusLabel,
  ];
}
