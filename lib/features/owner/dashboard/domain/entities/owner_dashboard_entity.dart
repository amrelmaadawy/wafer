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
  List<Object?> get props => [
    id,
    tenantName,
    propertyName,
    unitNumber,
    amount,
    date,
  ];
}

class InstallmentStatsEntity extends Equatable {
  final int paid;
  final int partiallyPaid;
  final int unpaid;
  final int overdue;

  const InstallmentStatsEntity({
    required this.paid,
    required this.partiallyPaid,
    required this.unpaid,
    required this.overdue,
  });

  @override
  List<Object?> get props => [paid, partiallyPaid, unpaid, overdue];
}

class LatestOverdueInstallmentEntity extends Equatable {
  final int id;
  final num amount;
  final num paidAmount;
  final String status;
  final String dueDate;
  final String propertyName;
  final String unitName;
  final String tenantName;
  final String contractNumber;

  const LatestOverdueInstallmentEntity({
    required this.id,
    required this.amount,
    required this.paidAmount,
    required this.status,
    required this.dueDate,
    required this.propertyName,
    required this.unitName,
    required this.tenantName,
    required this.contractNumber,
  });

  @override
  List<Object?> get props => [
    id,
    amount,
    paidAmount,
    status,
    dueDate,
    propertyName,
    unitName,
    tenantName,
    contractNumber,
  ];
}

class MaintenanceBreakdownEntity extends Equatable {
  final int newRequests;
  final int inProgress;
  final int urgent;

  const MaintenanceBreakdownEntity({
    required this.newRequests,
    required this.inProgress,
    required this.urgent,
  });

  @override
  List<Object?> get props => [newRequests, inProgress, urgent];
}

class TasksBreakdownEntity extends Equatable {
  final int active;
  final int overdue;

  const TasksBreakdownEntity({
    required this.active,
    required this.overdue,
  });

  @override
  List<Object?> get props => [active, overdue];
}

class LegalCasesBreakdownEntity extends Equatable {
  final int openCases;
  final num totalAmount;

  const LegalCasesBreakdownEntity({
    required this.openCases,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [openCases, totalAmount];
}

