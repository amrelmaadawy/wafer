import '../../domain/entities/owner_dashboard_entity.dart';

class OwnerDashboardModel extends OwnerDashboardEntity {
  const OwnerDashboardModel({
    required super.totalProperties,
    required super.totalUnits,
    required super.rentedUnits,
    required super.vacantUnits,
    required super.activeContracts,
    required super.totalRevenue,
    required super.collectedAmount,
    required super.pendingAmount,
    required super.overdueInstallmentsCount,
    required super.expiringContracts,
    required super.pendingMaintenance,
    required super.occupancyRate,
    required super.recentReceipts,
    super.installmentStats,
    super.latestOverdueInstallments,
    super.maintenanceBreakdown,
    super.tasksBreakdown,
    super.legalCasesBreakdown,
  });

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) {
    return OwnerDashboardModel(
      totalProperties: json['total_properties'] as int? ?? 0,
      totalUnits: json['total_units'] as int? ?? 0,
      rentedUnits: json['rented_units'] as int? ?? 0,
      vacantUnits: json['vacant_units'] as int? ?? 0,
      activeContracts: json['active_contracts'] as int? ?? 0,
      totalRevenue: json['total_revenue'] as num? ?? 0,
      collectedAmount: json['collected_amount'] as num? ?? 0,
      pendingAmount: json['pending_amount'] as num? ?? 0,
      overdueInstallmentsCount: json['overdue_installments_count'] as int? ?? 0,
      expiringContracts: json['expiring_contracts'] as int? ?? 0,
      pendingMaintenance: json['pending_maintenance'] as int? ?? 0,
      occupancyRate: json['occupancy_rate'] as num? ?? 0,
      recentReceipts: (json['recent_receipts'] as List<dynamic>? ?? [])
          .map((e) => ReceiptModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      installmentStats: json['installment_stats'] != null
          ? InstallmentStatsModel.fromJson(
              json['installment_stats'] as Map<String, dynamic>)
          : null,
      latestOverdueInstallments:
          (json['latest_overdue_installments'] as List<dynamic>? ?? [])
              .map((e) => LatestOverdueInstallmentModel.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
      maintenanceBreakdown: json['maintenance_breakdown'] != null
          ? MaintenanceBreakdownModel.fromJson(
              json['maintenance_breakdown'] as Map<String, dynamic>)
          : null,
      tasksBreakdown: json['tasks_breakdown'] != null
          ? TasksBreakdownModel.fromJson(
              json['tasks_breakdown'] as Map<String, dynamic>)
          : null,
      legalCasesBreakdown: json['legal_cases_breakdown'] != null
          ? LegalCasesBreakdownModel.fromJson(
              json['legal_cases_breakdown'] as Map<String, dynamic>)
          : null,
    );
  }
}

class InstallmentStatsModel extends InstallmentStatsEntity {
  const InstallmentStatsModel({
    required super.paid,
    required super.partiallyPaid,
    required super.unpaid,
    required super.overdue,
  });

  factory InstallmentStatsModel.fromJson(Map<String, dynamic> json) {
    return InstallmentStatsModel(
      paid: json['paid'] as int? ?? 0,
      partiallyPaid: json['partially_paid'] as int? ?? 0,
      unpaid: json['unpaid'] as int? ?? 0,
      overdue: json['overdue'] as int? ?? 0,
    );
  }
}

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
    final contract = json['contract'] as Map<String, dynamic>?;
    final property = contract?['property'] as Map<String, dynamic>?;
    final unit = contract?['unit'] as Map<String, dynamic>?;
    final renter = contract?['renter'] as Map<String, dynamic>?;

    return LatestOverdueInstallmentModel(
      id: json['id'] as int? ?? 0,
      amount: num.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      paidAmount: num.tryParse(json['paid_amount']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? '',
      dueDate: json['due_date']?.toString() ?? '',
      propertyName: property?['name']?.toString() ?? '',
      unitName: unit?['name']?.toString() ?? '',
      tenantName: renter?['name']?.toString() ?? '',
      contractNumber: contract?['contract_number']?.toString() ?? '',
    );
  }
}

class MaintenanceBreakdownModel extends MaintenanceBreakdownEntity {
  const MaintenanceBreakdownModel({
    required super.newRequests,
    required super.inProgress,
    required super.urgent,
  });

  factory MaintenanceBreakdownModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceBreakdownModel(
      newRequests: json['new'] as int? ?? 0,
      inProgress: json['in_progress'] as int? ?? 0,
      urgent: json['urgent'] as int? ?? 0,
    );
  }
}

class TasksBreakdownModel extends TasksBreakdownEntity {
  const TasksBreakdownModel({
    required super.active,
    required super.overdue,
  });

  factory TasksBreakdownModel.fromJson(Map<String, dynamic> json) {
    return TasksBreakdownModel(
      active: json['active'] as int? ?? 0,
      overdue: json['overdue'] as int? ?? 0,
    );
  }
}

class LegalCasesBreakdownModel extends LegalCasesBreakdownEntity {
  const LegalCasesBreakdownModel({
    required super.openCases,
    required super.totalAmount,
  });

  factory LegalCasesBreakdownModel.fromJson(Map<String, dynamic> json) {
    return LegalCasesBreakdownModel(
      openCases: json['open_cases'] as int? ?? 0,
      totalAmount: num.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
    );
  }
}

class ReceiptModel extends ReceiptEntity {
  const ReceiptModel({
    required super.id,
    required super.tenantName,
    required super.propertyName,
    required super.unitNumber,
    required super.amount,
    required super.date,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id']?.toString() ?? '',
      tenantName: json['tenant_name']?.toString() ?? '',
      propertyName: json['property_name']?.toString() ?? '',
      unitNumber: json['unit_number']?.toString() ?? '',
      amount: json['amount'] as num? ?? 0,
      date: json['date']?.toString() ?? '',
    );
  }
}
