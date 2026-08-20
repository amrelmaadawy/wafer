part of 'contract_details_model.dart';

ContractDetailsModel parseContractDetails(Map<String, dynamic> json) {
  final target = _contractPayload(json);
  final branch = _map(target['branch']);
  final property = _map(target['property']);
  final unit = _map(target['unit']);
  final renter = _map(target['renter']) ?? _map(target['tenant']);
  final dates = _map(target['dates']);
  final financial = _map(target['financial']);
  final ejar = _map(target['ejar']);
  final settings = _map(target['settings']);
  final handover = _map(target['handover']);

  final summaryObj = _map(json['data']?['installments_summary']) ?? _map(json['installments_summary']);
  ContractInstallmentsSummaryEntity? parsedSummary;
  if (summaryObj != null) {
    parsedSummary = ContractInstallmentsSummaryEntity(
      installmentsCount: _intValue(summaryObj['total_count']),
      paidCount: _intValue(summaryObj['paid_count']),
      unpaidCount: _intValue(summaryObj['unpaid_count']),
      partialCount: _intValue(summaryObj['partial_count']),
      totalAmount: _doubleValue(summaryObj['total_amount']),
      paidAmount: _doubleValue(summaryObj['paid_amount']),
      remainingAmount: _doubleValue(summaryObj['remaining_amount']),
      nextDueDate: (_map(summaryObj['next_due'])?['due_date'] ?? '').toString(),
    );
  }

  final installmentsList = (target['installments'] as List?)
          ?.map((e) => _map(e))
          .whereType<Map<String, dynamic>>()
          .map((e) => ContractInstallmentEntity(
                id: _intValue(e['id']),
                installmentNumber: _intValue(e['installment_number']),
                dueDate: (e['due_date'] ?? '').toString(),
                amount: _doubleValue(e['amount']),
                paidAmount: _doubleValue(e['paid_amount']),
                remaining: _doubleValue(e['remaining']),
                status: (e['status'] ?? '').toString(),
                statusLabel: (e['status_label'] ?? '').toString(),
              ))
          .toList() ??
      [];

  return ContractDetailsModel(
    id: target['id']?.toString() ?? '',
    contractNumber: (target['contract_number'] ?? target['code'] ?? '').toString(),
    contractType: (target['contract_type_label'] ?? target['contract_type'] ?? '').toString(),
    branchId: (branch?['id'] ?? target['branch_id'] ?? '').toString(),
    branchName: (branch?['name'] ?? target['branch_name'] ?? '').toString(),
    propertyId: (property?['id'] ?? target['property_id'] ?? '').toString(),
    propertyName: (property?['name'] ?? property?['title'] ?? target['property_name'] ?? '').toString(),
    unitId: (unit?['id'] ?? target['unit_id'] ?? '').toString(),
    unitName: (unit?['name'] ?? unit?['unit_number'] ?? target['unit_name'] ?? '').toString(),
    renterId: (renter?['id'] ?? target['renter_id'] ?? '').toString(),
    renterName: (renter?['name'] ?? renter?['full_name'] ?? target['renter_name'] ?? target['tenant_name'] ?? '').toString(),
    renterPhone: (renter?['phone'] ?? renter?['mobile'] ?? target['renter_phone'] ?? '').toString(),
    startDate: (dates?['start_date'] ?? target['start_date'] ?? target['from_date'] ?? '').toString(),
    endDate: (dates?['end_date'] ?? target['end_date'] ?? target['to_date'] ?? '').toString(),
    totalRentValue: _doubleValue(financial?['total_rent_value'] ?? financial?['rent_amount'] ?? target['total_rent_value'] ?? target['rent_amount']),
    paymentCycle: (financial?['payment_cycle_label'] ?? financial?['payment_cycle'] ?? target['payment_cycle'] ?? '').toString(),
    paymentCount: _intValue(financial?['payment_count'] ?? target['payment_count']),
    securityDeposit: _doubleValue(financial?['security_deposit'] ?? target['security_deposit']),
    status: target['status']?.toString() ?? '',
    statusLabel: (target['status_label'] ?? target['status'] ?? '').toString(),
    statusBadge: target['status_icon']?.toString() ?? target['status_badge']?.toString() ?? '',
    
    // Ejar
    isEjarLinked: _boolValue(ejar?['is_ejar_linked'] ?? target['is_ejar_linked']),
    ejarExternalContractNumber: (ejar?['external_contract_number'] ?? '').toString(),
    ejarReferenceNumber: (ejar?['reference_number'] ?? '').toString(),
    ejarStatusLabel: (ejar?['ejar_status_label'] ?? ejar?['ejar_status'] ?? '').toString(),

    // Settings
    autoRenewal: _boolValue(settings?['auto_renewal'] ?? target['auto_renewal']),
    autoRenewalLabel: (settings?['auto_renewal_label'] ?? '').toString(),
    renewalNoticeDays: _intValue(settings?['renewal_notice_days'] ?? target['renewal_notice_days']),
    terminationPenalty: _doubleValue(settings?['termination_penalty'] ?? target['termination_penalty']),
    sublettingAllowed: _boolValue(settings?['subletting_allowed'] ?? target['subletting_allowed']),
    sublettingAllowedLabel: (settings?['subletting_allowed_label'] ?? '').toString(),
    notes: (target['notes'] ?? '').toString(),

    // Handover
    isHandedOver: _boolValue(handover?['is_handed_over']),
    isHandedOverLabel: (handover?['is_handed_over_label'] ?? '').toString(),
    handoverDate: (handover?['handover_date'] ?? '').toString(),

    installmentsSummary: parsedSummary,
    installments: installmentsList,
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
