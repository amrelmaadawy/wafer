import 'package:equatable/equatable.dart';
import '../../../domain/entities/maintenance_item_entity.dart';

enum OwnerVerifyCloseMaintenanceStatus { initial, loading, success, failure }

class OwnerVerifyCloseMaintenanceState extends Equatable {
  final OwnerVerifyCloseMaintenanceStatus status;
  final MaintenanceItemEntity? item;
  final String? errorMessage;

  const OwnerVerifyCloseMaintenanceState({
    this.status = OwnerVerifyCloseMaintenanceStatus.initial,
    this.item,
    this.errorMessage,
  });

  OwnerVerifyCloseMaintenanceState copyWith({
    OwnerVerifyCloseMaintenanceStatus? status,
    MaintenanceItemEntity? item,
    String? errorMessage,
  }) {
    return OwnerVerifyCloseMaintenanceState(
      status: status ?? this.status,
      item: item ?? this.item,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, item, errorMessage];
}
