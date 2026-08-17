import 'package:equatable/equatable.dart';
import '../../../domain/entities/maintenance_sub_entities.dart';

enum UpdateMaintenanceStatus { initial, loading, success, offlineQueued, failure }

class OwnerUpdateMaintenanceState extends Equatable {
  final UpdateMaintenanceStatus status;
  final String? errorMessage;
  final String? successMessage;

  final bool isFormDataLoading;
  final String? formDataError;
  final List<MaintenanceTypeEntity> availableMaintenanceTypes;

  const OwnerUpdateMaintenanceState({
    this.status = UpdateMaintenanceStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.isFormDataLoading = false,
    this.formDataError,
    this.availableMaintenanceTypes = const [],
  });

  OwnerUpdateMaintenanceState copyWith({
    UpdateMaintenanceStatus? status,
    String? errorMessage,
    String? successMessage,
    bool? isFormDataLoading,
    String? formDataError,
    List<MaintenanceTypeEntity>? availableMaintenanceTypes,
  }) {
    return OwnerUpdateMaintenanceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isFormDataLoading: isFormDataLoading ?? this.isFormDataLoading,
      formDataError: formDataError ?? this.formDataError,
      availableMaintenanceTypes:
          availableMaintenanceTypes ?? this.availableMaintenanceTypes,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    successMessage,
    isFormDataLoading,
    formDataError,
    availableMaintenanceTypes,
  ];
}
