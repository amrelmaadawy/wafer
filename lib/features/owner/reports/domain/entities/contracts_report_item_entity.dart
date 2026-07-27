import 'package:equatable/equatable.dart';

class ContractsReportItemEntity extends Equatable {
  final int contractId;
  final String contractNumber;
  final String propertyName;
  final String unitName;
  final String renterName;
  final double rentValue;
  final String startDate;
  final String endDate;
  final int daysRemaining;
  final String status;

  const ContractsReportItemEntity({
    required this.contractId,
    required this.contractNumber,
    required this.propertyName,
    required this.unitName,
    required this.renterName,
    required this.rentValue,
    required this.startDate,
    required this.endDate,
    required this.daysRemaining,
    required this.status,
  });

  @override
  List<Object?> get props => [
        contractId,
        contractNumber,
        propertyName,
        unitName,
        renterName,
        rentValue,
        startDate,
        endDate,
        daysRemaining,
        status,
      ];
}
