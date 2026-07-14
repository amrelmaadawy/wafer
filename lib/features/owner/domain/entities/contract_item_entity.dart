import 'package:equatable/equatable.dart';

class ContractItemEntity extends Equatable {
  final String id;
  final String contractNumber;
  final String propertyName;
  final String unitName;
  final String tenantName;
  final String startDate;
  final String endDate;
  final double rentAmount;
  final String paymentCycle;
  final String status;

  const ContractItemEntity({
    required this.id,
    required this.contractNumber,
    required this.propertyName,
    required this.unitName,
    required this.tenantName,
    required this.startDate,
    required this.endDate,
    required this.rentAmount,
    required this.paymentCycle,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        contractNumber,
        propertyName,
        unitName,
        tenantName,
        startDate,
        endDate,
        rentAmount,
        paymentCycle,
        status,
      ];
}
