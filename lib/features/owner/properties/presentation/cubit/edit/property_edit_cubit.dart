import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/patch_property_use_case.dart';
import '../../../domain/usecases/get_property_form_data_use_case.dart';
import '../../../domain/usecases/auto_save_deed_step_use_case.dart';
import '../../../../../../core/usecases/usecase.dart';
import 'property_edit_state.dart';

class PropertyEditCubit extends Cubit<PropertyEditState> {
  final PatchPropertyUseCase _patchProperty;
  final GetPropertyFormDataUseCase _getFormData;
  final AutoSaveDeedStepUseCase _autoSaveDeedStep;
  
  int? _propertyId;

  PropertyEditCubit({
    required PatchPropertyUseCase patchProperty,
    required GetPropertyFormDataUseCase getFormData,
    required AutoSaveDeedStepUseCase autoSaveDeedStep,
  })  : _patchProperty = patchProperty,
        _getFormData = getFormData,
        _autoSaveDeedStep = autoSaveDeedStep,
        super(const PropertyEditState());

  void init(int propertyId, int? branchId, int? deedId) {
    _propertyId = propertyId;
    emit(state.copyWith(
      selectedBranchId: branchId,
      selectedDeedId: deedId,
    ));
    loadFormData();
  }

  Future<void> loadFormData() async {
    emit(state.copyWith(isLoadingForm: true).clearError());
    final result = await _getFormData(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoadingForm: false, errorMessage: failure.message)),
      (formData) => emit(state.copyWith(isLoadingForm: false, formData: formData)),
    );
  }

  void selectBranch(int branchId) {
    emit(state.copyWith(selectedBranchId: branchId).clearError());
    _triggerAutoSave();
  }

  void selectDeed(int deedId) {
    emit(state.copyWith(selectedDeedId: deedId).clearError());
    _triggerAutoSave();
  }

  Future<void> _triggerAutoSave() async {
    if (_propertyId == null || state.selectedBranchId == null || state.selectedDeedId == null) {
      return;
    }

    emit(state.copyWith(isAutoSaving: true).clearError());
    
    final result = await _autoSaveDeedStep(
      propertyId: _propertyId!,
      deedId: state.selectedDeedId!,
      branchId: state.selectedBranchId!,
    );
    
    result.fold(
      (failure) => emit(state.copyWith(isAutoSaving: false, errorMessage: failure.message)),
      (property) => emit(state.copyWith(isAutoSaving: false, updatedProperty: property)),
    );
  }

  Future<void> saveChanges(int propertyId, Map<String, dynamic> data) async {
    emit(state.copyWith(isSaving: true).clearError());
    final result = await _patchProperty(propertyId, data);
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, isSuccess: true)),
    );
  }
}
