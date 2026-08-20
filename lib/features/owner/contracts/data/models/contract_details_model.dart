import '../../domain/entities/contract_details_entity.dart';
import '../../domain/entities/contract_installment_entity.dart';
import '../../domain/entities/contract_installments_summary_entity.dart';

part 'contract_details_model_parser.dart';

class ContractDetailsModel extends ContractDetailsEntity {
  const ContractDetailsModel({
    required super.id,
    required super.contractNumber,
    required super.contractType,
    required super.branchId,
    required super.branchName,
    required super.propertyId,
    required super.propertyName,
    required super.unitId,
    required super.unitName,
    required super.renterId,
    required super.renterName,
    required super.renterPhone,
    required super.startDate,
    required super.endDate,
    required super.totalRentValue,
    required super.paymentCycle,
    required super.paymentCount,
    required super.securityDeposit,
    required super.status,
    required super.statusLabel,
    required super.statusBadge,
    required super.isEjarLinked,
    required super.ejarExternalContractNumber,
    required super.ejarReferenceNumber,
    required super.ejarStatusLabel,
    required super.autoRenewal,
    required super.autoRenewalLabel,
    required super.renewalNoticeDays,
    required super.terminationPenalty,
    required super.sublettingAllowed,
    required super.sublettingAllowedLabel,
    super.notes,
    required super.isHandedOver,
    required super.isHandedOverLabel,
    required super.handoverDate,
    super.installmentsSummary,
    super.installments,
  });

  factory ContractDetailsModel.fromJson(Map<String, dynamic> json) =>
      parseContractDetails(json);
}
