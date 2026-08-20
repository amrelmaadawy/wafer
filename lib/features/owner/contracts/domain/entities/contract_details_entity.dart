import 'package:equatable/equatable.dart';
import 'contract_installment_entity.dart';
import 'contract_installments_summary_entity.dart';

class ContractDetailsEntity extends Equatable {
  final String id;
  final String contractNumber;
  final String contractType;
  final String branchId;
  final String branchName;
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
  
  // Ejar
  final bool isEjarLinked;
  final String ejarExternalContractNumber;
  final String ejarReferenceNumber;
  final String ejarStatusLabel;

  // Settings
  final bool autoRenewal;
  final String autoRenewalLabel;
  final int renewalNoticeDays;
  final double terminationPenalty;
  final bool sublettingAllowed;
  final String sublettingAllowedLabel;

  // Handover
  final bool isHandedOver;
  final String isHandedOverLabel;
  final String handoverDate;

  // Installments
  final ContractInstallmentsSummaryEntity? installmentsSummary;
  final List<ContractInstallmentEntity> installments;
  final String? notes;

  const ContractDetailsEntity({
    required this.id,
    required this.contractNumber,
    required this.contractType,
    required this.branchId,
    required this.branchName,
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
    required this.ejarExternalContractNumber,
    required this.ejarReferenceNumber,
    required this.ejarStatusLabel,
    required this.autoRenewal,
    required this.autoRenewalLabel,
    required this.renewalNoticeDays,
    required this.terminationPenalty,
    required this.sublettingAllowed,
    required this.sublettingAllowedLabel,
    required this.isHandedOver,
    required this.isHandedOverLabel,
    required this.handoverDate,
    this.installmentsSummary,
    this.installments = const [],
    this.notes,
  });

  @override
  List<Object?> get props => [
    id, contractNumber, contractType, branchId, branchName,
    propertyId, propertyName, unitId, unitName, renterId, renterName, renterPhone,
    startDate, endDate, totalRentValue, paymentCycle, paymentCount, securityDeposit,
    status, statusLabel, statusBadge, isEjarLinked, ejarExternalContractNumber, ejarReferenceNumber, ejarStatusLabel,
    autoRenewal, autoRenewalLabel, renewalNoticeDays, terminationPenalty, sublettingAllowed, sublettingAllowedLabel,
    isHandedOver, isHandedOverLabel, handoverDate, installmentsSummary, installments, notes,
  ];
}
