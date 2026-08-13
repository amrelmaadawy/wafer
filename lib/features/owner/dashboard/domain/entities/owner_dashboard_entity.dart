import 'package:equatable/equatable.dart';
import 'dashboard_breakdown_entities.dart';
import 'dashboard_installment_entities.dart';
import 'dashboard_receipt_entity.dart';

export 'dashboard_breakdown_entities.dart';
export 'dashboard_installment_entities.dart';
export 'dashboard_receipt_entity.dart';

class OwnerDashboardEntity extends Equatable {
  final int totalProperties;
  final int totalUnits;
  final int rentedUnits;
  final int vacantUnits;
  final int activeContracts;
  final num totalRevenue;
  final num collectedAmount;
  final num pendingAmount;
  final int overdueInstallmentsCount;
  final int expiringContracts;
  final int pendingMaintenance;
  final num occupancyRate;
  final List<ReceiptEntity> recentReceipts;
  final InstallmentStatsEntity? installmentStats;
  final List<LatestOverdueInstallmentEntity> latestOverdueInstallments;
  final MaintenanceBreakdownEntity? maintenanceBreakdown;
  final TasksBreakdownEntity? tasksBreakdown;
  final LegalCasesBreakdownEntity? legalCasesBreakdown;

  const OwnerDashboardEntity({
    required this.totalProperties,
    required this.totalUnits,
    required this.rentedUnits,
    required this.vacantUnits,
    required this.activeContracts,
    required this.totalRevenue,
    required this.collectedAmount,
    required this.pendingAmount,
    required this.overdueInstallmentsCount,
    required this.expiringContracts,
    required this.pendingMaintenance,
    required this.occupancyRate,
    required this.recentReceipts,
    this.installmentStats,
    this.latestOverdueInstallments = const [],
    this.maintenanceBreakdown,
    this.tasksBreakdown,
    this.legalCasesBreakdown,
  });

  @override
  List<Object?> get props => [
    totalProperties,
    totalUnits,
    rentedUnits,
    vacantUnits,
    activeContracts,
    totalRevenue,
    collectedAmount,
    pendingAmount,
    overdueInstallmentsCount,
    expiringContracts,
    pendingMaintenance,
    occupancyRate,
    recentReceipts,
    installmentStats,
    latestOverdueInstallments,
    maintenanceBreakdown,
    tasksBreakdown,
    legalCasesBreakdown,
  ];
}
