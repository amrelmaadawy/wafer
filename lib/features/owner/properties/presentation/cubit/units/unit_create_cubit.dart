import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/unit_create_entity.dart';
import '../../../domain/usecases/create_unit_usecase.dart';
import '../../../domain/repositories/properties_repository.dart';
import 'unit_create_state.dart';
import 'dart:io';

class UnitCreateCubit extends Cubit<UnitCreateState> {
  final CreateUnitUseCase _createUnitUseCase;
  final PropertiesRepository _propertiesRepository;

  UnitCreateCubit(this._createUnitUseCase, this._propertiesRepository) : super(const UnitCreateState());

  Future<void> init(int propertyId) async {
    emit(state.copyWith(propertyId: propertyId, currentStep: 0, isLoading: true, error: null));
    
    // Fetch property details to pre-fill address
    final result = await _propertiesRepository.getPropertyDetails(propertyId);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)), // Ignore error for pre-fill
      (property) {
        emit(state.copyWith(
          isLoading: false,
          city: property.city,
          district: property.district,
          streetName: property.streetName,
          buildingNumber: property.buildingNumber,
        ));
      }
    );
  }

  void nextStep() {
    if (state.currentStep < 5) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  // --- Step 1 ---
  void updateBasicInfo({
    String? name,
    String? unitNumber,
    String? unitType,
    String? usageType,
    String? purpose,
    String? finishingType,
    bool? isFurnished,
  }) {
    emit(state.copyWith(
      name: name ?? state.name,
      unitNumber: unitNumber ?? state.unitNumber,
      unitType: unitType ?? state.unitType,
      usageType: usageType ?? state.usageType,
      purpose: purpose ?? state.purpose,
      finishingType: finishingType ?? state.finishingType,
      isFurnished: isFurnished ?? state.isFurnished,
    ));
  }

  // --- Step 2 ---
  void updateSpecs({
    String? floorType,
    int? floorNumber,
    double? area,
    double? length,
    double? width,
    double? height,
    double? facadeLength,
    int? roomsCount,
    int? hallsCount,
    int? bathroomsCount,
    int? kitchensCount,
    int? entrancesCount,
  }) {
    emit(state.copyWith(
      floorType: floorType ?? state.floorType,
      floorNumber: floorNumber ?? state.floorNumber,
      area: area ?? state.area,
      length: length ?? state.length,
      width: width ?? state.width,
      height: height ?? state.height,
      facadeLength: facadeLength ?? state.facadeLength,
      roomsCount: roomsCount ?? state.roomsCount,
      hallsCount: hallsCount ?? state.hallsCount,
      bathroomsCount: bathroomsCount ?? state.bathroomsCount,
      kitchensCount: kitchensCount ?? state.kitchensCount,
      entrancesCount: entrancesCount ?? state.entrancesCount,
    ));
  }

  // --- Step 3 ---
  void updateLocationUtilities({
    String? city,
    String? district,
    String? streetName,
    String? buildingNumber,
    String? postalCode,
    String? additionalNumber,
    String? shortAddress,
    double? latitude,
    double? longitude,
    String? electricityMeter,
    String? waterMeter,
    String? gasMeter,
  }) {
    emit(state.copyWith(
      city: city ?? state.city,
      district: district ?? state.district,
      streetName: streetName ?? state.streetName,
      buildingNumber: buildingNumber ?? state.buildingNumber,
      postalCode: postalCode ?? state.postalCode,
      additionalNumber: additionalNumber ?? state.additionalNumber,
      shortAddress: shortAddress ?? state.shortAddress,
      latitude: latitude ?? state.latitude,
      longitude: longitude ?? state.longitude,
      electricityMeterNumber: electricityMeter ?? state.electricityMeterNumber,
      waterMeterNumber: waterMeter ?? state.waterMeterNumber,
      gasMeterNumber: gasMeter ?? state.gasMeterNumber,
    ));
  }

  void toggleAmenity(String amenity) {
    final current = List<String>.from(state.amenities);
    if (current.contains(amenity)) {
      current.remove(amenity);
    } else {
      current.add(amenity);
    }
    emit(state.copyWith(amenities: current));
  }

  // --- Step 4 ---
  void updateImages(List<File> images) {
    emit(state.copyWith(images: images));
  }

  void addImage(File image) {
    final current = List<File>.from(state.images);
    current.add(image);
    emit(state.copyWith(images: current));
  }

  void removeImage(int index) {
    final current = List<File>.from(state.images);
    current.removeAt(index);
    emit(state.copyWith(images: current));
  }

  // --- Step 5 ---
  void updateFinancials({
    double? monthly,
    double? twoPayments,
    double? fourPayments,
    bool? useMortgage,
  }) {
    emit(state.copyWith(
      annualRentMonthly: monthly ?? state.annualRentMonthly,
      annualRent2Payments: twoPayments ?? state.annualRent2Payments,
      annualRent4Payments: fourPayments ?? state.annualRent4Payments,
      usePriceForMortgage: useMortgage ?? state.usePriceForMortgage,
    ));
  }

  // --- Submit ---
  Future<bool> submit() async {
    if (state.propertyId == null) return false;

    // Build entity
    final entity = UnitCreateEntity(
      name: state.name ?? '',
      unitNumber: state.unitNumber ?? '',
      unitType: state.unitType,
      unitStatus: state.unitStatus,
      purpose: state.purpose,
      usageType: state.usageType,
      finishingType: state.finishingType,
      isFurnished: state.isFurnished,
      description: state.description,
      isCompleted: state.isCompleted,
      constructionDate: state.constructionDate?.toIso8601String(),
      maxOccupancy: state.maxOccupancy,
      floorType: state.floorType,
      floorNumber: state.floorNumber ?? 0,
      area: state.area ?? 0.0,
      length: state.length,
      width: state.width,
      height: state.height,
      facadeLength: state.facadeLength,
      roomsCount: state.roomsCount,
      hallsCount: state.hallsCount,
      bathroomsCount: state.bathroomsCount,
      kitchensCount: state.kitchensCount,
      entrancesCount: state.entrancesCount,
      buildingNumber: state.buildingNumber,
      streetName: state.streetName,
      district: state.district,
      city: state.city,
      region: state.region,
      postalCode: state.postalCode,
      additionalNumber: state.additionalNumber,
      shortAddress: state.shortAddress,
      latitude: state.latitude,
      longitude: state.longitude,
      direction: state.direction,
      electricityMeterNumber: state.electricityMeterNumber,
      waterMeterNumber: state.waterMeterNumber,
      gasMeterNumber: state.gasMeterNumber,
      amenities: state.amenities,
      images: state.images,
      annualRent2Payments: state.annualRent2Payments,
      annualRent4Payments: state.annualRent4Payments,
      annualRentMonthly: state.annualRentMonthly,
      usePriceForMortgage: state.usePriceForMortgage,
    );

    emit(state.copyWith(isLoading: true, error: null));

    final result = await _createUnitUseCase(state.propertyId!, entity);

    return result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
        return false;
      },
      (id) {
        emit(state.copyWith(isLoading: false, error: null));
        return true;
      },
    );
  }
}
