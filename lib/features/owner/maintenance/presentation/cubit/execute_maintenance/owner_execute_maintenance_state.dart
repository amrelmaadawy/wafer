import 'package:equatable/equatable.dart';
import '../../../domain/entities/execute_owner_maintenance_response_entity.dart';

enum OwnerExecuteMaintenanceStatus { initial, loading, success, failure }

class OwnerExecuteMaintenanceState extends Equatable {
  final OwnerExecuteMaintenanceStatus status;
  final ExecuteOwnerMaintenanceResponseEntity? responseEntity;
  final String? errorMessage;

  const OwnerExecuteMaintenanceState({
    this.status = OwnerExecuteMaintenanceStatus.initial,
    this.responseEntity,
    this.errorMessage,
  });

  OwnerExecuteMaintenanceState copyWith({
    OwnerExecuteMaintenanceStatus? status,
    ExecuteOwnerMaintenanceResponseEntity? responseEntity,
    String? errorMessage,
  }) {
    return OwnerExecuteMaintenanceState(
      status: status ?? this.status,
      responseEntity: responseEntity ?? this.responseEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, responseEntity, errorMessage];
}
