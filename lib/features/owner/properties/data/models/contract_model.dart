import '../../domain/entities/contract_entity.dart';

class ContractModel extends ContractEntity {
  const ContractModel({
    required super.id,
    required super.contractNumber,
    required super.status,
    required super.statusLabel,
    required super.contractType,
    super.startDate,
    super.endDate,
    super.isExpired = false,
    super.totalRentValue = 0,
    super.amount = 0,
    required super.unitName,
    required super.renterName,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    final unitMap = json['unit'] is Map<String, dynamic>
        ? json['unit'] as Map<String, dynamic>
        : null;
    final renterMap = json['renter'] is Map<String, dynamic>
        ? json['renter'] as Map<String, dynamic>
        : null;

    return ContractModel(
      id: json['id'] as int? ?? 0,
      contractNumber:
          json['contract_number']?.toString() ??
          json['number']?.toString() ??
          '',
      status: json['status']?.toString() ?? 'draft',
      statusLabel: json['status_label']!.toString(),
      contractType: json['contract_type']?.toString() ?? '',
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      isExpired: json['is_expired'] == true,
      totalRentValue: json['total_rent_value'] as num? ?? 0,
      amount: json['amount'] as num? ?? 0,
      unitName: unitMap?['name']?.toString() ?? '',
      renterName: renterMap?['name']?.toString() ?? '',
    );
  }
}
