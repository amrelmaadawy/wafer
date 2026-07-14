import 'package:equatable/equatable.dart';

class ContractDetailsEntity extends Equatable {
  final String id;
  final String contractNumber;
  final String contractType;
  final String propertyId;
  final String propertyName;
  final String unitId;
  final String unitName;
  final String renterId;
  final String renterName;
  final String renterPhone;
  final String startDate;
  final String endDate;
  final double totalRentValue;
  final String paymentCycle;
  final int paymentCount;
  final double securityDeposit;
  final String status;
  final String statusLabel;
  final String statusBadge;
  final bool isEjarLinked;

  const ContractDetailsEntity({
    required this.id,
    required this.contractNumber,
    required this.contractType,
    required this.propertyId,
    required this.propertyName,
    required this.unitId,
    required this.unitName,
    required this.renterId,
    required this.renterName,
    required this.renterPhone,
    required this.startDate,
    required this.endDate,
    required this.totalRentValue,
    required this.paymentCycle,
    required this.paymentCount,
    required this.securityDeposit,
    required this.status,
    required this.statusLabel,
    required this.statusBadge,
    required this.isEjarLinked,
  });

  @override
  List<Object?> get props => [
        id,
        contractNumber,
        contractType,
        propertyId,
        propertyName,
        unitId,
        unitName,
        renterId,
        renterName,
        renterPhone,
        startDate,
        endDate,
        totalRentValue,
        paymentCycle,
        paymentCount,
        securityDeposit,
        status,
        statusLabel,
        statusBadge,
        isEjarLinked,
      ];
}
