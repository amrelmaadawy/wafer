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
