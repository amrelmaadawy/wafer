import '../../domain/entities/contract_details_entity.dart';

part 'contract_details_model_parser.dart';

class ContractDetailsModel extends ContractDetailsEntity {
  const ContractDetailsModel({
    required super.id,
    required super.contractNumber,
    required super.contractType,
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
  });

  factory ContractDetailsModel.fromJson(Map<String, dynamic> json) =>
      parseContractDetails(json);
}
