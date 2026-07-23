import 'package:equatable/equatable.dart';
import '../../../domain/entities/form_deed_entity.dart';
import '../../../domain/entities/property_form_data_entity.dart';

class PropertyCreateState extends Equatable {
  final int? draftPropertyId;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final PropertyFormDataEntity? formData;
  final List<FormDeedEntity> deeds;

  // Form selections
  final int? selectedBranchId;
  final int? selectedDeedId;
  final String? selectedType;

  const PropertyCreateState({
    this.draftPropertyId,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.formData,
    this.deeds = const [],
    this.selectedBranchId,
    this.selectedDeedId,
    this.selectedType,
  });

  PropertyCreateState copyWith({
    int? draftPropertyId,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    PropertyFormDataEntity? formData,
    List<FormDeedEntity>? deeds,
    int? selectedBranchId,
    int? selectedDeedId,
    String? selectedType,
  }) {
    return PropertyCreateState(
      draftPropertyId: draftPropertyId ?? this.draftPropertyId,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      formData: formData ?? this.formData,
      deeds: deeds ?? this.deeds,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      selectedDeedId: selectedDeedId ?? this.selectedDeedId,
      selectedType: selectedType ?? this.selectedType,
    );
  }

  @override
  List<Object?> get props => [
        draftPropertyId,
        isLoading,
        isSaving,
        errorMessage,
        formData,
        deeds,
        selectedBranchId,
        selectedDeedId,
        selectedType,
      ];
}
