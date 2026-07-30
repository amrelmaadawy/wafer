import 'package:equatable/equatable.dart';

enum DeleteMaintenanceStatus { initial, loading, success, failure }

class OwnerDeleteMaintenanceState extends Equatable {
  final DeleteMaintenanceStatus status;
  final String? errorMessage;

  const OwnerDeleteMaintenanceState({
    this.status = DeleteMaintenanceStatus.initial,
    this.errorMessage,
  });

  OwnerDeleteMaintenanceState copyWith({
    DeleteMaintenanceStatus? status,
    String? errorMessage,
  }) {
    return OwnerDeleteMaintenanceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
