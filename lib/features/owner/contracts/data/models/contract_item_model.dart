import '../../domain/entities/contract_item_entity.dart';

class ContractItemModel extends ContractItemEntity {
  const ContractItemModel({
    required super.id,
    required super.contractNumber,
    required super.contractTypeLabel,
    required super.propertyName,
    required super.unitName,
    required super.renterName,
    required super.startDate,
    required super.endDate,
    required super.totalRentValue,
    required super.status,
    required super.statusLabel,
  });

  factory ContractItemModel.fromJson(Map<String, dynamic> json) {
    final property = _asMap(json['property']);
    final unit = _asMap(json['unit']);
    final renter = _asMap(json['renter']);
    final dates = _asMap(json['dates']);
    final financial = _asMap(json['financial']);

    return ContractItemModel(
      id: json['id']?.toString() ?? '',
      contractNumber: json['contract_number']?.toString() ?? '',
      contractTypeLabel: json['contract_type_label']?.toString() ?? '',
      propertyName: property?['name']?.toString() ?? '',
      unitName: unit?['name']?.toString() ?? '',
      renterName: renter?['name']?.toString() ?? '',
      startDate: dates?['start_date']?.toString() ?? '',
      endDate: dates?['end_date']?.toString() ?? '',
      totalRentValue: _asDouble(financial?['total_rent_value']),
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'contract_number': contractNumber,
    'contract_type_label': contractTypeLabel,
    'property': {'name': propertyName},
    'unit': {'name': unitName},
    'renter': {'name': renterName},
    'dates': {
      'start_date': startDate,
      'end_date': endDate,
    },
    'financial': {
      'total_rent_value': totalRentValue,
    },
    'status': status,
    'status_label': statusLabel,
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
