import '../../domain/entities/owner_dashboard_entity.dart';

class LatestOverdueInstallmentModel extends LatestOverdueInstallmentEntity {
  const LatestOverdueInstallmentModel({
    required super.id,
    required super.amount,
    required super.paidAmount,
    required super.status,
    required super.dueDate,
    required super.propertyName,
    required super.unitName,
    required super.tenantName,
    required super.contractNumber,
  });

  factory LatestOverdueInstallmentModel.fromJson(Map<String, dynamic> json) {
    final contract = _map(json['contract']);
    final property = _map(contract?['property']);
    final unit = _map(contract?['unit']);
    final renter = _map(contract?['renter']) ?? _map(contract?['tenant']);
    return LatestOverdueInstallmentModel(
      id: _int(json['id']),
      amount: _num(json['amount']),
      paidAmount: _num(json['paid_amount']),
      status: json['status']?.toString() ?? '',
      dueDate: json['due_date']?.toString() ?? '',
      propertyName: property?['name']?.toString() ?? '',
      unitName: (unit?['name'] ?? unit?['unit_number'] ?? '').toString(),
      tenantName: (renter?['name'] ?? renter?['full_name'] ?? '').toString(),
      contractNumber: contract?['contract_number']?.toString() ?? '',
    );
  }
}

Map<String, dynamic>? _map(Object? value) {
  if (value is! Map) return null;
  return Map<String, dynamic>.from(value);
}

int _int(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _num(Object? value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}
