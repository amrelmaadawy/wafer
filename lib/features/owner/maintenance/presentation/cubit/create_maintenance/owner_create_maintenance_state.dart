import 'package:equatable/equatable.dart';
import '../../../domain/entities/maintenance_form_data_entity.dart';
import '../../../domain/entities/maintenance_sub_entities.dart';
import '../../../domain/entities/maintenance_complex_sub_entities.dart';

enum CreateMaintenanceStatus { initial, loading, success, failure }

class OwnerCreateMaintenanceState extends Equatable {
  final CreateMaintenanceStatus status;
  final String? errorMessage;

  final bool isFormDataLoading;
  final MaintenanceFormDataEntity? formData;
  final String? formDataError;

  final List<MaintenanceFormDataUnitEntity> filteredUnits;

  final int? selectedPropertyId;
  final int? selectedUnitId;

  final String clientName;
  final String clientPhone;
  final String description;
  final String requestedDate;
  final List<String> maintenanceTypes;
  final bool isPrivate;

  const OwnerCreateMaintenanceState({
    this.status = CreateMaintenanceStatus.initial,
    this.errorMessage,

    this.isFormDataLoading = false,
    this.formData,
    this.formDataError,

    this.filteredUnits = const [],

    this.selectedPropertyId,
    this.selectedUnitId,

    this.clientName = '',
    this.clientPhone = '',
    this.description = '',
    this.requestedDate = '',
    this.maintenanceTypes = const [],
    this.isPrivate = false,
  });

  List<MaintenanceFormDataPropertyEntity> get properties => formData?.properties ?? [];
  List<MaintenanceTypeEntity> get availableMaintenanceTypes => formData?.maintenanceTypes ?? [];
  List<MaintenanceTechnicianEntity> get availableTechnicians => formData?.technicians ?? [];

  OwnerCreateMaintenanceState copyWith({
    CreateMaintenanceStatus? status,
    String? errorMessage,

    bool? isFormDataLoading,
    MaintenanceFormDataEntity? formData,
    String? formDataError,

    List<MaintenanceFormDataUnitEntity>? filteredUnits,

    int? selectedPropertyId,
    int? selectedUnitId,

    String? clientName,
    String? clientPhone,
    String? description,
    String? requestedDate,
    List<String>? maintenanceTypes,
    bool? isPrivate,
  }) {
    return OwnerCreateMaintenanceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,

      isFormDataLoading: isFormDataLoading ?? this.isFormDataLoading,
      formData: formData ?? this.formData,
      formDataError: formDataError ?? this.formDataError,

      filteredUnits: filteredUnits ?? this.filteredUnits,

      selectedPropertyId: selectedPropertyId ?? this.selectedPropertyId,
      selectedUnitId: selectedUnitId ?? this.selectedUnitId,

      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      description: description ?? this.description,
      requestedDate: requestedDate ?? this.requestedDate,
      maintenanceTypes: maintenanceTypes ?? this.maintenanceTypes,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  OwnerCreateMaintenanceState copyWithNullUnitId({
    CreateMaintenanceStatus? status,
    String? errorMessage,
    bool? isFormDataLoading,
    MaintenanceFormDataEntity? formData,
    String? formDataError,
    List<MaintenanceFormDataUnitEntity>? filteredUnits,
    int? selectedPropertyId,
    String? clientName,
    String? clientPhone,
    String? description,
    String? requestedDate,
    List<String>? maintenanceTypes,
    bool? isPrivate,
  }) {
    return OwnerCreateMaintenanceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormDataLoading: isFormDataLoading ?? this.isFormDataLoading,
      formData: formData ?? this.formData,
      formDataError: formDataError ?? this.formDataError,
      filteredUnits: filteredUnits ?? this.filteredUnits,
      selectedPropertyId: selectedPropertyId ?? this.selectedPropertyId,
      selectedUnitId: null,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      description: description ?? this.description,
      requestedDate: requestedDate ?? this.requestedDate,
      maintenanceTypes: maintenanceTypes ?? this.maintenanceTypes,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    isFormDataLoading,
    formData,
    formDataError,
    filteredUnits,
    selectedPropertyId,
    selectedUnitId,
    clientName,
    clientPhone,
    description,
    requestedDate,
    maintenanceTypes,
    isPrivate,
  ];
}
