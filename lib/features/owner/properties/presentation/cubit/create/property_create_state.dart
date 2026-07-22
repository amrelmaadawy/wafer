import 'package:equatable/equatable.dart';
import '../../../domain/entities/deed_entity.dart';
import '../../../domain/entities/property_form_data_entity.dart';

class OwnerInputItem extends Equatable {
  final int? id;
  final String name;
  final num percentage;
  final bool isRepresentative;

  const OwnerInputItem({
    this.id,
    required this.name,
    required this.percentage,
    this.isRepresentative = false,
  });

  @override
  List<Object?> get props => [id, name, percentage, isRepresentative];
}

class PropertyCreateState extends Equatable {
  final int currentStep;
  final int? draftPropertyId;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final PropertyFormDataEntity? formData;
  final List<DeedEntity> deeds;

  // Form selections
  final int? selectedBranchId;
  final int? selectedDeedId;
  final String? selectedType;
  final String? selectedUsageType;

  // Form inputs
  final String propertyName;
  final String address;
  final num? area;
  final num? length;
  final num? width;
  final String? documentType;
  final String? deedNumber;
  final String? deedDate;
  final num? valuationAmount;
  final String? valuationDate;
  final String? valuationEntity;
  final String? city;
  final String? district;
  final String? region;
  final String? streetName;
  final String? buildingNumber;
  final String? shortAddress;
  final String? postalCode;
  final String? additionalNumber;
  final num? latitude;
  final num? longitude;
  final String? notes;

  // Owners & Attachments
  final List<OwnerInputItem> owners;
  final List<String> imagePaths;
  final String? deedAttachment;
  final String? valuationAttachment;

  // Track completed steps
  final Set<int> savedSteps;

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
    this.selectedUsageType,
    this.propertyName = '',
    this.address = '',
    this.area,
    this.length,
    this.width,
    this.documentType,
    this.deedNumber,
    this.deedDate,
    this.valuationAmount,
    this.valuationDate,
    this.valuationEntity,
    this.city,
    this.district,
    this.region,
    this.streetName,
    this.buildingNumber,
    this.shortAddress,
    this.postalCode,
    this.additionalNumber,
    this.latitude,
    this.longitude,
    this.notes,
    this.owners = const [],
    this.imagePaths = const [],
    this.deedAttachment,
    this.valuationAttachment,
    this.savedSteps = const {},
  });

  String get description => notes ?? '';

  num get totalOwnersPercentage =>
      owners.fold(0, (sum, item) => sum + item.percentage);

  bool get isOwnersPercentageValid => totalOwnersPercentage == 100;

  PropertyCreateState copyWith({
    int? currentStep,
    int? draftPropertyId,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    PropertyFormDataEntity? formData,
    List<DeedEntity>? deeds,
    int? selectedBranchId,
    int? selectedDeedId,
    String? selectedType,
    String? selectedUsageType,
    String? propertyName,
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
    List<OwnerInputItem>? owners,
    List<String>? imagePaths,
    String? deedAttachment,
    String? valuationAttachment,
    Set<int>? savedSteps,
  }) {
    return PropertyCreateState(
      currentStep: currentStep ?? this.currentStep,
      draftPropertyId: draftPropertyId ?? this.draftPropertyId,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      formData: formData ?? this.formData,
      deeds: deeds ?? this.deeds,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      selectedDeedId: selectedDeedId ?? this.selectedDeedId,
      selectedType: selectedType ?? this.selectedType,
      selectedUsageType: selectedUsageType ?? this.selectedUsageType,
      propertyName: propertyName ?? this.propertyName,
      address: address ?? this.address,
      area: area ?? this.area,
      length: length ?? this.length,
      width: width ?? this.width,
      documentType: documentType ?? this.documentType,
      deedNumber: deedNumber ?? this.deedNumber,
      deedDate: deedDate ?? this.deedDate,
      valuationAmount: valuationAmount ?? this.valuationAmount,
      valuationDate: valuationDate ?? this.valuationDate,
      valuationEntity: valuationEntity ?? this.valuationEntity,
      city: city ?? this.city,
      district: district ?? this.district,
      region: region ?? this.region,
      streetName: streetName ?? this.streetName,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      shortAddress: shortAddress ?? this.shortAddress,
      postalCode: postalCode ?? this.postalCode,
      additionalNumber: additionalNumber ?? this.additionalNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      owners: owners ?? this.owners,
      imagePaths: imagePaths ?? this.imagePaths,
      deedAttachment: deedAttachment ?? this.deedAttachment,
      valuationAttachment: valuationAttachment ?? this.valuationAttachment,
      savedSteps: savedSteps ?? this.savedSteps,
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
        selectedUsageType,
        propertyName,
        address,
        area,
        length,
        width,
        documentType,
        deedNumber,
        deedDate,
        valuationAmount,
        valuationDate,
        valuationEntity,
        city,
        district,
        region,
        streetName,
        buildingNumber,
        shortAddress,
        postalCode,
        additionalNumber,
        latitude,
        longitude,
        notes,
        owners,
        imagePaths,
        deedAttachment,
        valuationAttachment,
        savedSteps,
      ];
}
