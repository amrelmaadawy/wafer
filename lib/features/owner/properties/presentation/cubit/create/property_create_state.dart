import 'package:equatable/equatable.dart';
import '../../../domain/entities/form_deed_entity.dart';
import '../../../domain/entities/property_form_data_entity.dart';
import '../../../domain/entities/property_owner_entity.dart';
import '../../../domain/entities/temp_property_image_entity.dart';

class PropertyCreateState extends Equatable {
  final int currentStep; // 0: Basic, 1: Details, 2: Images, 3: Owners, 4: Review
  final int? draftPropertyId;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final PropertyFormDataEntity? formData;
  final List<FormDeedEntity> deeds;

  // Form selections - Step 1
  final int? selectedBranchId;
  final int? selectedDeedId;
  final String? selectedType;

  // Details - Step 2
  final String? name;
  final String? address;
  final double? area;
  final int? constructionYear;
  final String? usageType;
  final String? description;
  final bool isAutoSavingDetails;

  // Images - Step 3
  final List<TempPropertyImageEntity> images;
  final bool isSavingImages;

  // Owners - Step 4
  final List<PropertyOwnerEntity> owners;
  final bool isSyncingOwners;

  // Publishing - Step 5
  final bool isPublishing;
  final bool isPublished;

  const PropertyCreateState({
    this.currentStep = 0,
    this.draftPropertyId,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.formData,
    this.deeds = const [],
    this.selectedBranchId,
    this.selectedDeedId,
    this.selectedType,
    this.name,
    this.address,
    this.area,
    this.constructionYear,
    this.usageType,
    this.description,
    this.isAutoSavingDetails = false,
    this.images = const [],
    this.isSavingImages = false,
    this.owners = const [],
    this.isSyncingOwners = false,
    this.isPublishing = false,
    this.isPublished = false,
  });

  PropertyCreateState copyWith({
    int? currentStep,
    int? draftPropertyId,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    PropertyFormDataEntity? formData,
    List<FormDeedEntity>? deeds,
    int? selectedBranchId,
    int? selectedDeedId,
    String? selectedType,
    String? name,
    String? address,
    double? area,
    int? constructionYear,
    String? usageType,
    String? description,
    bool? isAutoSavingDetails,
    List<TempPropertyImageEntity>? images,
    bool? isSavingImages,
    List<PropertyOwnerEntity>? owners,
    bool? isSyncingOwners,
    bool? isPublishing,
    bool? isPublished,
  }) {
    return PropertyCreateState(
      currentStep: currentStep ?? this.currentStep,
      draftPropertyId: draftPropertyId ?? this.draftPropertyId,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage, // We keep it null unless explicitly throwing an error
      formData: formData ?? this.formData,
      deeds: deeds ?? this.deeds,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      selectedDeedId: selectedDeedId ?? this.selectedDeedId,
      selectedType: selectedType ?? this.selectedType,
      name: name ?? this.name,
      address: address ?? this.address,
      area: area ?? this.area,
      constructionYear: constructionYear ?? this.constructionYear,
      usageType: usageType ?? this.usageType,
      description: description ?? this.description,
      isAutoSavingDetails: isAutoSavingDetails ?? this.isAutoSavingDetails,
      images: images ?? this.images,
      isSavingImages: isSavingImages ?? this.isSavingImages,
      owners: owners ?? this.owners,
      isSyncingOwners: isSyncingOwners ?? this.isSyncingOwners,
      isPublishing: isPublishing ?? this.isPublishing,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  // Clear error specifically
  PropertyCreateState clearError() {
    return PropertyCreateState(
      currentStep: currentStep,
      draftPropertyId: draftPropertyId,
      isLoading: isLoading,
      isSaving: isSaving,
      errorMessage: null,
      formData: formData,
      deeds: deeds,
      selectedBranchId: selectedBranchId,
      selectedDeedId: selectedDeedId,
      selectedType: selectedType,
      name: name,
      address: address,
      area: area,
      constructionYear: constructionYear,
      usageType: usageType,
      description: description,
      isAutoSavingDetails: isAutoSavingDetails,
      images: images,
      isSavingImages: isSavingImages,
      owners: owners,
      isSyncingOwners: isSyncingOwners,
      isPublishing: isPublishing,
      isPublished: isPublished,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        draftPropertyId,
        isLoading,
        isSaving,
        errorMessage,
        formData,
        deeds,
        selectedBranchId,
        selectedDeedId,
        selectedType,
        name,
        address,
        area,
        constructionYear,
        usageType,
        description,
        isAutoSavingDetails,
        images,
        isSavingImages,
        owners,
        isSyncingOwners,
        isPublishing,
        isPublished,
      ];
}
