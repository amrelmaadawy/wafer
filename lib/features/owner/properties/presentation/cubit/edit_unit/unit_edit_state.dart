import 'package:equatable/equatable.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/entities/units_form_data_entity.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

class UnitEditState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final Failure? error;
  final Failure? submitError;
  final UnitsFormDataEntity? formData;
  final UnitFullDetailsEntity? initialUnit;

  const UnitEditState({
    this.isLoading = true,
    this.isSubmitting = false,
    this.error,
    this.submitError,
    this.formData,
    this.initialUnit,
  });

  UnitEditState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    Failure? error,
    Failure? submitError,
    UnitsFormDataEntity? formData,
    UnitFullDetailsEntity? initialUnit,
    bool clearError = false,
    bool clearSubmitError = false,
  }) {
    return UnitEditState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : error ?? this.error,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
      formData: formData ?? this.formData,
      initialUnit: initialUnit ?? this.initialUnit,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSubmitting,
        error,
        submitError,
        formData,
        initialUnit,
      ];
}
