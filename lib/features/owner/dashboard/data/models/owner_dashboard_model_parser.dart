part of 'owner_dashboard_model.dart';

OwnerDashboardModel parseOwnerDashboard(Map<String, dynamic> json) {
  return OwnerDashboardModel(
    totalProperties: _int(json['total_properties']),
    totalUnits: _int(json['total_units']),
    rentedUnits: _int(json['rented_units']),
    vacantUnits: _int(json['vacant_units']),
    activeContracts: _int(json['active_contracts']),
    totalRevenue: _num(json['total_revenue']),
    collectedAmount: _num(json['collected_amount']),
    pendingAmount: _num(json['pending_amount']),
    overdueInstallmentsCount: _int(json['overdue_installments_count']),
    expiringContracts: _int(json['expiring_contracts']),
    pendingMaintenance: _int(json['pending_maintenance']),
    occupancyRate: _num(json['occupancy_rate']),
    recentReceipts: _maps(
      json['recent_receipts'],
    ).map(ReceiptModel.fromJson).toList(growable: false),
    installmentStats: _optionalMap(
      json['installment_stats'],
      InstallmentStatsModel.fromJson,
    ),
    latestOverdueInstallments: _maps(
      json['latest_overdue_installments'],
    ).map(LatestOverdueInstallmentModel.fromJson).toList(growable: false),
    maintenanceBreakdown: _optionalMap(
      json['maintenance_breakdown'],
      MaintenanceBreakdownModel.fromJson,
    ),
    tasksBreakdown: _optionalMap(
      json['tasks_breakdown'],
      TasksBreakdownModel.fromJson,
    ),
    legalCasesBreakdown: _optionalMap(
      json['legal_cases_breakdown'],
      LegalCasesBreakdownModel.fromJson,
    ),
  );
}

T? _optionalMap<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is! Map) return null;
  return parser(Map<String, dynamic>.from(value));
}

Iterable<Map<String, dynamic>> _maps(Object? value) sync* {
  if (value is! List) return;
  for (final item in value) {
    if (item is Map) yield Map<String, dynamic>.from(item);
  }
}

int _int(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _num(Object? value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}
