import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/create_draft_property_use_case.dart';
import '../../../domain/usecases/get_property_form_data_use_case.dart';
import 'property_create_state.dart';

class PropertyCreateCubit extends Cubit<PropertyCreateState> {
  final CreateDraftPropertyUseCase _createDraft;
  final GetPropertyFormDataUseCase _getFormData;

  PropertyCreateCubit({
    required CreateDraftPropertyUseCase createDraft,
    required GetPropertyFormDataUseCase getFormData,
  })  : _createDraft = createDraft,
        _getFormData = getFormData,
        super(const PropertyCreateState());

  Future<void> loadFormOptions() async {
    emit(state.copyWith(isLoading: true));
    final formDataResult = await _getFormData(NoParams());

    formDataResult.fold(
      (f) => emit(state.copyWith(isLoading: false, errorMessage: f.message)),
      (formData) {
        emit(state.copyWith(
          isLoading: false,
          formData: formData,
          deeds: formData.options.deeds,
          selectedType: formData.defaults.defaultPropertyType,
        ));
      },
    );
  }

  void selectBranch(int branchId) => emit(state.copyWith(selectedBranchId: branchId));
  void selectDeed(int deedId) => emit(state.copyWith(selectedDeedId: deedId));
  void selectType(String type) => emit(state.copyWith(selectedType: type));

  void addNewDeed(dynamic newDeed) {
    // Re-fetch form data to get the updated list of deeds
    // For now, we can just call loadFormOptions() again to refresh
    // Or if we know the new deed's details, we could manually insert it, but refreshing is safer
    loadFormOptions().then((_) {
      if (newDeed != null && newDeed.id != null) {
        selectDeed(newDeed.id!);
      }
    });
  }

  Future<bool> createDraft() async {
    if (state.selectedDeedId == null || state.selectedType == null || state.selectedBranchId == null) {
      return false;
    }

    emit(state.copyWith(isSaving: true));
    
    final res = await _createDraft({
      'deed_id': state.selectedDeedId,
      'branch_id': state.selectedBranchId,
      'property_type': state.selectedType,
    });
    
    return res.fold(
      (f) {
        emit(state.copyWith(isSaving: false, errorMessage: f.message));
        return false;
      },
      (draftId) {
        emit(state.copyWith(isSaving: false, draftPropertyId: draftId));
        return true;
      },
    );
  }
}
