import 'package:equatable/equatable.dart';

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
      ];
}

class ReceiptEntity extends Equatable {
  final String id;
  final String tenantName;
  final String propertyName;
  final String unitNumber;
  final num amount;
  final String date;

  const ReceiptEntity({
    required this.id,
    required this.tenantName,
    required this.propertyName,
    required this.unitNumber,
    required this.amount,
    required this.date,
  });

  @override
  List<Object?> get props => [id, tenantName, propertyName, unitNumber, amount, date];
}
