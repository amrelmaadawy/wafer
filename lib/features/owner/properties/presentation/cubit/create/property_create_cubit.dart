import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/create_draft_property_use_case.dart';
import '../../../domain/usecases/get_property_form_data_use_case.dart';
import '../../../domain/usecases/auto_save_property_step_use_case.dart';
import '../../../domain/usecases/upload_temp_file_use_case.dart';
import '../../../domain/usecases/sync_owners_use_case.dart';
import '../../../domain/usecases/publish_property_use_case.dart';
import '../../../domain/entities/property_owner_entity.dart';
import '../../../domain/entities/temp_property_image_entity.dart';
import 'property_create_state.dart';

class PropertyCreateCubit extends Cubit<PropertyCreateState> {
  final CreateDraftPropertyUseCase _createDraft;
  final GetPropertyFormDataUseCase _getFormData;
  final AutoSavePropertyStepUseCase _autoSavePropertyStep;
  final UploadTempFileUseCase _uploadTempFile;
  final SyncOwnersUseCase _syncOwners;
  final PublishPropertyUseCase _publishProperty;

  PropertyCreateCubit({
    required CreateDraftPropertyUseCase createDraft,
    required GetPropertyFormDataUseCase getFormData,
    required AutoSavePropertyStepUseCase autoSavePropertyStep,
    required UploadTempFileUseCase uploadTempFile,
    required SyncOwnersUseCase syncOwners,
    required PublishPropertyUseCase publishProperty,
  })  : _createDraft = createDraft,
        _getFormData = getFormData,
        _autoSavePropertyStep = autoSavePropertyStep,
        _uploadTempFile = uploadTempFile,
        _syncOwners = syncOwners,
        _publishProperty = publishProperty,
        super(const PropertyCreateState());

  Future<void> loadFormOptions() async {
    emit(state.copyWith(isLoading: true));
    final formDataResult = await _getFormData(NoParams());

    formDataResult.fold(
      (f) => emit(state.copyWith(isLoading: false, errorMessage: f.message)),
      (formData) {
        List<PropertyOwnerEntity> initialOwners = [];
        if (formData.defaults.defaultOwnerId != null && formData.defaults.defaultOwnerName != null) {
          initialOwners.add(PropertyOwnerEntity(
            id: formData.defaults.defaultOwnerId!,
            name: formData.defaults.defaultOwnerName!,
            percentage: formData.defaults.defaultOwnerPercentage ?? 100,
            isRepresentative: formData.defaults.isRepresentative,
          ));
        }

        emit(state.copyWith(
          isLoading: false,
          formData: formData,
          deeds: formData.options.deeds,
          selectedType: formData.defaults.defaultPropertyType,
          owners: state.owners.isEmpty ? initialOwners : state.owners,
        ));
      },
    );
  }

  // --- Step Navigation ---
  void setStep(int step) => emit(state.copyWith(currentStep: step));
  void nextStep() {
    if (state.currentStep < 4) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }
  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void clearError() {
    emit(state.clearError());
  }

  // --- Step 1: Basic Info ---
  void selectBranch(int branchId) => emit(state.copyWith(selectedBranchId: branchId));
  void selectDeed(int deedId) => emit(state.copyWith(selectedDeedId: deedId));
  void selectType(String type) => emit(state.copyWith(selectedType: type));

  void addNewDeed(dynamic newDeed) {
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

    emit(state.copyWith(isSaving: true).clearError());
    
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

  // --- Step 2: Details ---
  void updateName(String val) => emit(state.copyWith(name: val));
  void updateAddress(String val) => emit(state.copyWith(address: val));
  void updateArea(double val) => emit(state.copyWith(area: val));
  void updateConstructionYear(int val) => emit(state.copyWith(constructionYear: val));
  void updateUsageType(String val) => emit(state.copyWith(usageType: val));
  void updateDescription(String val) => emit(state.copyWith(description: val));

  Future<bool> autoSaveDetails() async {
    if (state.draftPropertyId == null) return false;

    emit(state.copyWith(isAutoSavingDetails: true).clearError());

    final res = await _autoSavePropertyStep(
      propertyId: state.draftPropertyId!,
      step: 'details',
      data: {
        'name': state.name,
        'city': state.address, // mapping simplified for now
        'area': state.area,
        'construction_year': state.constructionYear,
        'usage_type': state.usageType,
        'description': state.description,
      },
    );

    return res.fold(
      (f) {
        emit(state.copyWith(isAutoSavingDetails: false, errorMessage: f.message));
        return false;
      },
      (_) {
        emit(state.copyWith(isAutoSavingDetails: false));
        return true;
      },
    );
  }

  // --- Step 3: Images ---
  Future<void> uploadImage(String filePath) async {
    final localImage = TempPropertyImageEntity(localPath: filePath, isUploading: true);
    final updatedImages = List<TempPropertyImageEntity>.from(state.images)..add(localImage);
    emit(state.copyWith(images: updatedImages).clearError());

    final res = await _uploadTempFile(filePath);

    res.fold(
      (f) {
        final failedImages = state.images.map((img) {
          if (img.localPath == filePath) {
            return img.copyWith(isUploading: false, uploadFailed: true);
          }
          return img;
        }).toList();
        emit(state.copyWith(images: failedImages, errorMessage: f.message));
      },
      (tempPath) {
        final successImages = state.images.map((img) {
          if (img.localPath == filePath) {
            return img.copyWith(isUploading: false, tempPath: tempPath);
          }
          return img;
        }).toList();
        emit(state.copyWith(images: successImages));
      },
    );
  }

  void updateImageDescription(String localPath, String description) {
    final updatedImages = state.images.map((img) {
      if (img.localPath == localPath) {
        return img.copyWith(description: description);
      }
      return img;
    }).toList();
    emit(state.copyWith(images: updatedImages));
  }

  void removeImage(String tempPathOrLocalPath) {
    final updatedImages = state.images.where((img) => 
      img.tempPath != tempPathOrLocalPath && img.localPath != tempPathOrLocalPath
    ).toList();
    emit(state.copyWith(images: updatedImages));
  }

  Future<bool> saveImages() async {
    if (state.draftPropertyId == null) return false;
    
    final propertyImagesPayload = state.images
      .where((img) => img.tempPath != null)
      .map((img) => {
        'path': img.tempPath!,
        'desc': img.description ?? '',
      })
      .toList();

    emit(state.copyWith(isSavingImages: true).clearError());

    // We can auto-save them as a step
    final res = await _autoSavePropertyStep(
      propertyId: state.draftPropertyId!,
      step: 'images',
      data: {
        'property_images': propertyImagesPayload,
      },
    );

    return res.fold(
      (f) {
        emit(state.copyWith(isSavingImages: false, errorMessage: f.message));
        return false;
      },
      (_) {
        emit(state.copyWith(isSavingImages: false));
        return true;
      },
    );
  }

  // --- Step 4: Owners ---
  void addOwner(PropertyOwnerEntity owner) {
    if (state.owners.any((o) => o.id == owner.id)) {
      emit(state.copyWith(errorMessage: 'هذا المالك مضاف بالفعل'));
      return;
    }
    
    // Auto distribute remaining percentage if possible
    double remaining = 100 - state.owners.fold(0.0, (sum, o) => sum + o.percentage);
    final newOwner = owner.copyWith(
      percentage: remaining > 0 ? remaining : 0.0,
      isRepresentative: state.owners.isEmpty, // Make first owner representative
    );
    
    final updatedOwners = List<PropertyOwnerEntity>.from(state.owners)..add(newOwner);
    emit(state.copyWith(owners: updatedOwners).clearError());
  }

  void updateOwnerPercentage(int ownerId, double percentage) {
    final updatedOwners = state.owners.map((o) {
      if (o.id == ownerId) {
        return o.copyWith(percentage: percentage);
      }
      return o;
    }).toList();
    emit(state.copyWith(owners: updatedOwners));
  }

  void removeOwner(int ownerId) {
    final updatedOwners = state.owners.where((o) => o.id != ownerId).toList();
    if (updatedOwners.isNotEmpty && !updatedOwners.any((o) => o.isRepresentative)) {
      updatedOwners[0] = updatedOwners[0].copyWith(isRepresentative: true);
    }
    emit(state.copyWith(owners: updatedOwners));
  }

  void setRepresentative(int ownerId) {
    final updatedOwners = state.owners.map((o) {
      return o.copyWith(isRepresentative: o.id == ownerId);
    }).toList();
    emit(state.copyWith(owners: updatedOwners));
  }

  void autoDistributePercentages() {
    if (state.owners.isEmpty) return;
    
    final count = state.owners.length;
    final share = 100.0 / count;
    
    final updatedOwners = state.owners.map((o) {
      return o.copyWith(percentage: share);
    }).toList();
    
    emit(state.copyWith(owners: updatedOwners));
  }

  Future<bool> syncOwners() async {
    if (state.draftPropertyId == null) return false;

    double total = state.owners.fold(0.0, (sum, o) => sum + o.percentage);
    if ((total - 100.0).abs() > 0.01) { // Floating point comparison
      emit(state.copyWith(errorMessage: 'يجب أن يكون مجموع النسب 100% بالضبط'));
      return false;
    }

    emit(state.copyWith(isSyncingOwners: true).clearError());

    final ownersData = state.owners.map((o) => {
      'id': o.id,
      'percentage': o.percentage % 1 == 0 ? o.percentage.toInt() : o.percentage,
      'is_representative': o.isRepresentative,
    }).toList();

    final res = await _syncOwners(
      state.draftPropertyId!,
      ownersData,
    );

    return res.fold(
      (f) {
        emit(state.copyWith(isSyncingOwners: false, errorMessage: f.message));
        return false;
      },
      (_) {
        emit(state.copyWith(isSyncingOwners: false));
        return true;
      },
    );
  }

  // --- Step 5: Publish ---
  Future<bool> publishProperty() async {
    if (state.draftPropertyId == null) return false;

    emit(state.copyWith(isPublishing: true).clearError());

    final res = await _publishProperty(state.draftPropertyId!);

    return res.fold(
      (f) {
        emit(state.copyWith(isPublishing: false, errorMessage: f.message));
        return false;
      },
      (_) {
        emit(state.copyWith(isPublishing: false, isPublished: true));
        return true;
      },
    );
  }
}
