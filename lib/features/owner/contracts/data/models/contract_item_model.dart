import '../../domain/entities/contract_item_entity.dart';

class ContractItemModel extends ContractItemEntity {
  const ContractItemModel({
    required super.id,
    required super.contractNumber,
    required super.propertyName,
    required super.unitName,
    required super.tenantName,
    required super.startDate,
    required super.endDate,
    required super.rentAmount,
    required super.paymentCycle,
    required super.status,
  });

  factory ContractItemModel.fromJson(Map<String, dynamic> json) {
    final property = _asMap(json['property']);
    final unit = _asMap(json['unit']);
    final tenant = _asMap(json['tenant']) ?? _asMap(json['renter']);
    return ContractItemModel(
      id: json['id']?.toString() ?? '',
      contractNumber:
          (json['contract_number'] ?? json['code'] ?? json['number'] ?? '')
              .toString(),
      propertyName:
          (json['property_name'] ??
                  property?['name'] ??
                  property?['title'] ??
                  json['title'] ??
                  '')
              .toString(),
      unitName:
          (json['unit_name'] ??
                  unit?['name'] ??
                  unit?['unit_number'] ??
                  unit?['number'] ??
                  '')
              .toString(),
      tenantName:
          (json['tenant_name'] ??
                  tenant?['name'] ??
                  tenant?['full_name'] ??
                  json['party_name'] ??
                  '')
              .toString(),
      startDate: (json['start_date'] ?? json['from_date'] ?? '').toString(),
      endDate: (json['end_date'] ?? json['to_date'] ?? '').toString(),
      rentAmount: _asDouble(
        json['rent_amount'] ?? json['total_amount'] ?? json['price'],
      ),
      paymentCycle:
          (json['payment_cycle'] ?? json['cycle'] ?? json['frequency'] ?? '')
              .toString(),
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'contract_number': contractNumber,
    'property_name': propertyName,
    'unit_name': unitName,
    'tenant_name': tenantName,
    'start_date': startDate,
    'end_date': endDate,
    'rent_amount': rentAmount,
    'payment_cycle': paymentCycle,
    'status': status,
  };
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is! Map) return null;
  return Map<String, dynamic>.from(value);
}

double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
