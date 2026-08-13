part of 'contract_details_model.dart';

ContractDetailsModel parseContractDetails(Map<String, dynamic> json) {
  final target = _contractPayload(json);
  final property = _map(target['property']);
  final unit = _map(target['unit']);
  final renter = _map(target['renter']) ?? _map(target['tenant']);
  final financial = _map(target['financial']);

  return ContractDetailsModel(
    id: target['id']?.toString() ?? '',
    contractNumber: (target['contract_number'] ?? target['code'] ?? '')
        .toString(),
    contractType: target['contract_type']?.toString() ?? '',
    propertyId: (property?['id'] ?? target['property_id'] ?? '').toString(),
    propertyName:
        (property?['name'] ??
                property?['title'] ??
                target['property_name'] ??
                '')
            .toString(),
    unitId: (unit?['id'] ?? target['unit_id'] ?? '').toString(),
    unitName:
        (unit?['name'] ?? unit?['unit_number'] ?? target['unit_name'] ?? '')
            .toString(),
    renterId: (renter?['id'] ?? target['renter_id'] ?? '').toString(),
    renterName:
        (renter?['name'] ??
                renter?['full_name'] ??
                target['renter_name'] ??
                target['tenant_name'] ??
                '')
            .toString(),
    renterPhone:
        (renter?['phone'] ?? renter?['mobile'] ?? target['renter_phone'] ?? '')
            .toString(),
    startDate: (target['start_date'] ?? target['from_date'] ?? '').toString(),
    endDate: (target['end_date'] ?? target['to_date'] ?? '').toString(),
    totalRentValue: _doubleValue(
      financial?['total_rent_value'] ??
          financial?['rent_amount'] ??
          target['total_rent_value'] ??
          target['rent_amount'],
    ),
    paymentCycle: (financial?['payment_cycle'] ?? target['payment_cycle'] ?? '')
        .toString(),
    paymentCount: _intValue(
      financial?['payment_count'] ?? target['payment_count'],
    ),
    securityDeposit: _doubleValue(
      financial?['security_deposit'] ?? target['security_deposit'],
    ),
    status: target['status']?.toString() ?? '',
    statusLabel: (target['status_label'] ?? target['status'] ?? '').toString(),
    statusBadge: target['status_badge']?.toString() ?? '',
    isEjarLinked: _boolValue(target['is_ejar_linked']),
  );
}

Map<String, dynamic> _contractPayload(Map<String, dynamic> json) {
  final data = _map(json['data']);
  final source = data ?? json;
  final directContract = _map(source['contract']);
  if (directContract != null) return directContract;

  final contracts = _map(source['contracts']);
  if (contracts == null) return source;
  final items = contracts['data'];
  if (items is List && items.isNotEmpty) {
    return _map(items.first) ?? contracts;
  }
  return contracts;
}

Map<String, dynamic>? _map(Object? value) {
  if (value is! Map) return null;
  return Map<String, dynamic>.from(value);
}

double _doubleValue(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _intValue(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _boolValue(Object? value) {
  return value == true || value == 1 || value?.toString() == 'true';
}
