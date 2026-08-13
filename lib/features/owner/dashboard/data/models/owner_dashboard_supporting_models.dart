import '../../domain/entities/owner_dashboard_entity.dart';

class ReceiptModel extends ReceiptEntity {
  const ReceiptModel({
    required super.id,
    required super.tenantName,
    required super.propertyName,
    required super.unitNumber,
    required super.amount,
    required super.date,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) => ReceiptModel(
    id: json['id']?.toString() ?? '',
    tenantName: json['tenant_name']?.toString() ?? '',
    propertyName: json['property_name']?.toString() ?? '',
    unitNumber: json['unit_number']?.toString() ?? '',
    amount: _num(json['amount']),
    date: json['date']?.toString() ?? '',
  );
}

class InstallmentStatsModel extends InstallmentStatsEntity {
  const InstallmentStatsModel({
    required super.paid,
    required super.partiallyPaid,
    required super.unpaid,
    required super.overdue,
  });

  factory InstallmentStatsModel.fromJson(Map<String, dynamic> json) =>
      InstallmentStatsModel(
        paid: _int(json['paid']),
        partiallyPaid: _int(json['partially_paid']),
        unpaid: _int(json['unpaid']),
        overdue: _int(json['overdue']),
      );
}

class MaintenanceBreakdownModel extends MaintenanceBreakdownEntity {
  const MaintenanceBreakdownModel({
    required super.newRequests,
    required super.inProgress,
    required super.urgent,
  });

  factory MaintenanceBreakdownModel.fromJson(Map<String, dynamic> json) =>
      MaintenanceBreakdownModel(
        newRequests: _int(json['new']),
        inProgress: _int(json['in_progress']),
        urgent: _int(json['urgent']),
      );
}

class TasksBreakdownModel extends TasksBreakdownEntity {
  const TasksBreakdownModel({required super.active, required super.overdue});

  factory TasksBreakdownModel.fromJson(Map<String, dynamic> json) =>
      TasksBreakdownModel(
        active: _int(json['active']),
        overdue: _int(json['overdue']),
      );
}

class LegalCasesBreakdownModel extends LegalCasesBreakdownEntity {
  const LegalCasesBreakdownModel({
    required super.openCases,
    required super.totalAmount,
  });

  factory LegalCasesBreakdownModel.fromJson(Map<String, dynamic> json) =>
      LegalCasesBreakdownModel(
        openCases: _int(json['open_cases']),
        totalAmount: _num(json['total_amount']),
      );
}

int _int(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _num(Object? value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}
