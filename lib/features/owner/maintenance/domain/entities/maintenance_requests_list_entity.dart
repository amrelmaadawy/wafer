import 'package:equatable/equatable.dart';

class MaintenanceRequestsListResponseEntity extends Equatable {
  final List<MaintenanceRequestListItemEntity> maintenanceRequests;
  // If there are pagination details, they can be added here later

  const MaintenanceRequestsListResponseEntity({
    required this.maintenanceRequests,
  });

  @override
  List<Object?> get props => [maintenanceRequests];
}

class MaintenanceRequestListItemEntity extends Equatable {
  final int id;
  final String? requestNumber;
  final String? title;
  final String? description;
  final String? customType;
  final MaintenanceClientEntity? client;
  final String? status;
  final String? statusLabel;
  final String? costBearer;
  final String? costBearerLabel;
  final bool isPrivate;
  final MaintenanceFinancialsEntity? financials;

  const MaintenanceRequestListItemEntity({
    required this.id,
    this.requestNumber,
    this.title,
    this.description,
    this.customType,
    this.client,
    this.status,
    this.statusLabel,
    this.costBearer,
    this.costBearerLabel,
    required this.isPrivate,
    this.financials,
  });

  @override
  List<Object?> get props => [
    id,
    requestNumber,
    title,
    description,
    customType,
    client,
    status,
    statusLabel,
    costBearer,
    costBearerLabel,
    isPrivate,
    financials,
  ];
}

class MaintenanceClientEntity extends Equatable {
  final String? name;
  final String? phone;

  const MaintenanceClientEntity({this.name, this.phone});

  @override
  List<Object?> get props => [name, phone];
}

class MaintenanceFinancialsEntity extends Equatable {
  final num? estimatedCost;
  final num? advancePayment;
  final num? actualCost;

  const MaintenanceFinancialsEntity({
    this.estimatedCost,
    this.advancePayment,
    this.actualCost,
  });

  @override
  List<Object?> get props => [estimatedCost, advancePayment, actualCost];
}
