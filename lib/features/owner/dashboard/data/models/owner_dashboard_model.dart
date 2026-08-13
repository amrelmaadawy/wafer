import '../../domain/entities/owner_dashboard_entity.dart';
import 'latest_overdue_installment_model.dart';
import 'owner_dashboard_supporting_models.dart';

part 'owner_dashboard_model_parser.dart';

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

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) =>
      parseOwnerDashboard(json);
}
