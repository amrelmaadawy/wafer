import 'package:equatable/equatable.dart';
import '../../../domain/entities/property_form_data_entity.dart';
import '../../../domain/entities/property_details_entity.dart';
import '../../../domain/entities/form_deed_entity.dart';
import '../../../domain/entities/form_branch_entity.dart';

class PropertyEditState extends Equatable {
  final bool isLoadingForm;
  final bool isSaving;
  final bool isAutoSaving;
  final bool isSuccess;
  final String? errorMessage;
  
  final PropertyFormDataEntity? formData;
  final int? selectedBranchId;
  final int? selectedDeedId;
  final PropertyDetailsEntity? updatedProperty;

  const PropertyEditState({
    this.isLoadingForm = false,
    this.isSaving = false,
    this.isAutoSaving = false,
    this.isSuccess = false,
    this.errorMessage,
    this.formData,
    this.selectedBranchId,
    this.selectedDeedId,
    this.updatedProperty,
  });

  List<FormBranchEntity> get branches => formData?.options.branches ?? [];
  List<FormDeedEntity> get deeds => formData?.options.deeds ?? [];

  PropertyEditState copyWith({
    bool? isLoadingForm,
    bool? isSaving,
    bool? isAutoSaving,
    bool? isSuccess,
    String? errorMessage,
    PropertyFormDataEntity? formData,
    int? selectedBranchId,
    int? selectedDeedId,
    PropertyDetailsEntity? updatedProperty,
  }) {
    return PropertyEditState(
      isLoadingForm: isLoadingForm ?? this.isLoadingForm,
      isSaving: isSaving ?? this.isSaving,
      isAutoSaving: isAutoSaving ?? this.isAutoSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage, // null unless explicitly passed? Wait, passing null means clearing it.
      formData: formData ?? this.formData,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      selectedDeedId: selectedDeedId ?? this.selectedDeedId,
      updatedProperty: updatedProperty ?? this.updatedProperty,
    );
  }

  // To properly clear error message
  PropertyEditState clearError() {
    return PropertyEditState(
      isLoadingForm: isLoadingForm,
      isSaving: isSaving,
      isAutoSaving: isAutoSaving,
      isSuccess: isSuccess,
      errorMessage: null,
      formData: formData,
      selectedBranchId: selectedBranchId,
      selectedDeedId: selectedDeedId,
      updatedProperty: updatedProperty,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingForm,
        isSaving,
        isAutoSaving,
        isSuccess,
        errorMessage,
        formData,
        selectedBranchId,
        selectedDeedId,
        updatedProperty,
      ];
}
