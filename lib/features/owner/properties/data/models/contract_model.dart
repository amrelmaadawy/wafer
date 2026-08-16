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
    super.propertyId,
    super.propertyName,
    super.unitId,
    required super.unitName,
    super.tenantId,
    super.tenantName,
    required super.renterName,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    final propertyMap = json['property'] is Map<String, dynamic>
        ? json['property'] as Map<String, dynamic>
        : null;
    final unitMap = json['unit'] is Map<String, dynamic>
        ? json['unit'] as Map<String, dynamic>
        : null;
    final renterMap = json['renter'] is Map<String, dynamic>
        ? json['renter'] as Map<String, dynamic>
        : json['tenant'] is Map<String, dynamic>
        ? json['tenant'] as Map<String, dynamic>
        : null;

    final tenantName = renterMap?['name']?.toString() ?? json['tenant_name']?.toString() ?? json['renter_name']?.toString() ?? '';

    return ContractModel(
      id: json['id'] as int? ?? 0,
      contractNumber:
          json['contract_number']?.toString() ??
          json['number']?.toString() ??
          '',
      status: json['status']?.toString() ?? 'draft',
      statusLabel:
          json['status_label']?.toString() ?? json['status']?.toString() ?? '',
      contractType: json['contract_type']?.toString() ?? '',
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      isExpired: json['is_expired'] == true,
      totalRentValue: json['total_rent_value'] as num? ?? 0,
      amount: json['amount'] as num? ?? 0,
      propertyId: json['property_id'] as int? ?? propertyMap?['id'] as int?,
      propertyName: json['property_name']?.toString() ?? propertyMap?['name']?.toString(),
      unitId: json['unit_id'] as int? ?? unitMap?['id'] as int?,
      unitName: unitMap?['name']?.toString() ?? json['unit_name']?.toString() ?? '',
      tenantId: json['tenant_id'] as int? ?? renterMap?['id'] as int?,
      tenantName: tenantName,
      renterName: tenantName,
    );
  }
}
