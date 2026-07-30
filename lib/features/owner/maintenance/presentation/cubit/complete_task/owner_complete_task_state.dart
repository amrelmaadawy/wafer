import 'package:equatable/equatable.dart';
import '../../../domain/entities/maintenance_item_entity.dart';

enum CompleteTaskStatus { initial, loading, success, failure }

class OwnerCompleteTaskState extends Equatable {
  final CompleteTaskStatus status;
  final String? errorMessage;
  final MaintenanceItemEntity? item;

  const OwnerCompleteTaskState({
    this.status = CompleteTaskStatus.initial,
    this.errorMessage,
    this.item,
  });

  OwnerCompleteTaskState copyWith({
    CompleteTaskStatus? status,
    String? errorMessage,
    MaintenanceItemEntity? item,
  }) {
    return OwnerCompleteTaskState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      item: item ?? this.item,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, item];
}
