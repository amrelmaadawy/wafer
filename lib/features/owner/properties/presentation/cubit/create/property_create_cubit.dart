import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/auto_save_property_step_use_case.dart';
import '../../../domain/usecases/create_deed_use_case.dart';
import '../../../domain/usecases/create_draft_property_use_case.dart';
import '../../../domain/usecases/get_deeds_list_use_case.dart';
import '../../../domain/usecases/get_property_form_data_use_case.dart';
import '../../../domain/usecases/publish_property_use_case.dart';
import '../../../domain/usecases/sync_owners_use_case.dart';
import '../../../domain/usecases/upload_temp_file_use_case.dart';
import 'property_create_state.dart';

class PropertyCreateCubit extends Cubit<PropertyCreateState> {
  final CreateDraftPropertyUseCase _createDraft;
  final AutoSavePropertyStepUseCase _autoSave;
  final GetDeedsListUseCase _getDeeds;
  final CreateDeedUseCase _createDeed;
  final SyncOwnersUseCase _syncOwners;
  final UploadTempFileUseCase _uploadFile;
  final PublishPropertyUseCase _publish;
  final GetPropertyFormDataUseCase _getFormData;

  PropertyCreateCubit({
    required CreateDraftPropertyUseCase createDraft,
    required AutoSavePropertyStepUseCase autoSave,
    required GetDeedsListUseCase getDeeds,
    required CreateDeedUseCase createDeed,
    required SyncOwnersUseCase syncOwners,
    required UploadTempFileUseCase uploadFile,
    required PublishPropertyUseCase publish,
    required GetPropertyFormDataUseCase getFormData,
  })  : _createDraft = createDraft,
        _autoSave = autoSave,
        _getDeeds = getDeeds,
        _createDeed = createDeed,
        _syncOwners = syncOwners,
        _uploadFile = uploadFile,
        _publish = publish,
        _getFormData = getFormData,
        super(const PropertyCreateState());

  Future<void> initWizard() async {
    emit(state.copyWith(isLoading: true));
    final deedsResult = await _getDeeds();
    final formDataResult = await _getFormData(NoParams());

    deedsResult.fold(
      (f) => emit(state.copyWith(isLoading: false, errorMessage: f.message)),
      (deedsList) {
        formDataResult.fold(
          (f) => emit(state.copyWith(isLoading: false, errorMessage: f.message)),
          (formData) {
            List<OwnerInputItem> defaultOwners = [];
            if (formData.defaults.defaultOwnerName != null) {
              defaultOwners = [
                OwnerInputItem(
                  id: formData.defaults.defaultOwnerId,
                  name: formData.defaults.defaultOwnerName!,
                  percentage: formData.defaults.defaultOwnerPercentage ?? 100,
                  isRepresentative: formData.defaults.isRepresentative,
                )
              ];
            }

            emit(state.copyWith(
              isLoading: false,
              deeds: deedsList,
              formData: formData,
              selectedType: formData.defaults.defaultPropertyType,
              owners: defaultOwners,
            ));
          },
        );
      },
    );
  }

  void selectBranch(int branchId) => emit(state.copyWith(selectedBranchId: branchId));
  void selectDeed(int deedId) => emit(state.copyWith(selectedDeedId: deedId));
  void selectType(String type) => emit(state.copyWith(selectedType: type));
  void selectUsageType(String usage) => emit(state.copyWith(selectedUsageType: usage));

  void updateBasicData({
    String? name,
    String? address,
    num? area,
    num? length,
    num? width,
    String? documentType,
    String? deedNumber,
    String? deedDate,
    num? valuationAmount,
    String? valuationDate,
    String? valuationEntity,
    String? city,
    String? district,
    String? region,
    String? streetName,
    String? buildingNumber,
    String? shortAddress,
    String? postalCode,
    String? additionalNumber,
    num? latitude,
    num? longitude,
    String? notes,
  }) {
    emit(state.copyWith(
      propertyName: name ?? state.propertyName,
      address: address ?? state.address,
      area: area ?? state.area,
      length: length ?? state.length,
      width: width ?? state.width,
      documentType: documentType ?? state.documentType,
      deedNumber: deedNumber ?? state.deedNumber,
      deedDate: deedDate ?? state.deedDate,
      valuationAmount: valuationAmount ?? state.valuationAmount,
      valuationDate: valuationDate ?? state.valuationDate,
      valuationEntity: valuationEntity ?? state.valuationEntity,
      city: city ?? state.city,
      district: district ?? state.district,
      region: region ?? state.region,
      streetName: streetName ?? state.streetName,
      buildingNumber: buildingNumber ?? state.buildingNumber,
      shortAddress: shortAddress ?? state.shortAddress,
      postalCode: postalCode ?? state.postalCode,
      additionalNumber: additionalNumber ?? state.additionalNumber,
      latitude: latitude ?? state.latitude,
      longitude: longitude ?? state.longitude,
      notes: notes ?? state.notes,
    ));
  }

  void addOwner(String name, num percentage, [int? id, bool isRep = false]) {
    final updated = [...state.owners, OwnerInputItem(id: id, name: name, percentage: percentage, isRepresentative: isRep)];
    emit(state.copyWith(owners: updated));
  }

  void removeOwner(int index) {
    final updated = [...state.owners]..removeAt(index);
    emit(state.copyWith(owners: updated));
  }

  Future<bool> nextStep() async {
    emit(state.copyWith(isSaving: true));
    if (state.currentStep == 0) {
      if (state.selectedDeedId != null && state.selectedType != null) {
        if (state.draftPropertyId == null) {
          final res = await _createDraft({
            'deed_id': state.selectedDeedId,
            'branch_id': state.selectedBranchId,
            'property_type': state.selectedType,
          });
          res.fold(
            (f) => emit(state.copyWith(isSaving: false, errorMessage: f.message)),
            (draftId) => emit(state.copyWith(draftPropertyId: draftId)),
          );
        }
      }
    } else if (state.currentStep == 1 && state.draftPropertyId != null) {
      await _autoSave(
        propertyId: state.draftPropertyId!,
        step: 'step-basic',
        data: {
          'name': state.propertyName,
          'address': state.address,
          if (state.area != null) 'area': state.area,
        },
      );
    } else if (state.currentStep == 2 && state.draftPropertyId != null) {
      final ownersList = state.owners.map((o) => {'name': o.name, 'percentage': o.percentage}).toList();
      await _syncOwners(state.draftPropertyId!, ownersList);
    }

    final totalSteps = state.formData?.steps.length ?? 4;
    if (state.currentStep < totalSteps - 1) {
      final newSaved = {...state.savedSteps, state.currentStep};
      emit(state.copyWith(isSaving: false, currentStep: state.currentStep + 1, savedSteps: newSaved));
      return true;
    }
    emit(state.copyWith(isSaving: false));
    return true;
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  Future<void> createNewDeed(Map<String, dynamic> body) async {
    emit(state.copyWith(isSaving: true));
    final res = await _createDeed(body);
    res.fold(
      (f) => emit(state.copyWith(isSaving: false, errorMessage: f.message)),
      (deed) {
        final updatedDeeds = [...state.deeds, deed];
        emit(state.copyWith(
          isSaving: false,
          deeds: updatedDeeds,
          selectedDeedId: deed.id,
        ));
      },
    );
  }

  Future<void> uploadImage(String filePath) async {
    emit(state.copyWith(isSaving: true));
    final res = await _uploadFile(filePath);
    res.fold(
      (f) => emit(state.copyWith(isSaving: false, errorMessage: f.message)),
      (path) {
        final updatedImages = [...state.imagePaths, path];
        emit(state.copyWith(isSaving: false, imagePaths: updatedImages));
      },
    );
  }

  Future<bool> publish() async {
    if (state.draftPropertyId == null) return false;
    emit(state.copyWith(isLoading: true));
    final res = await _publish(state.draftPropertyId!);
    return res.fold(
      (f) {
        emit(state.copyWith(isLoading: false, errorMessage: f.message));
        return false;
      },
      (_) {
        emit(state.copyWith(isLoading: false));
        return true;
      },
    );
  }
}
