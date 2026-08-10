import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'unit_edit_state.dart';
import '../../../domain/entities/unit_update_entity.dart';
import '../../../domain/usecases/get_units_form_data_use_case.dart';
import '../../../domain/usecases/get_unit_details_use_case.dart';
import '../../../domain/usecases/update_unit_use_case.dart';

class UnitEditCubit extends Cubit<UnitEditState> {
  final GetUnitsFormDataUseCase _getUnitsFormDataUseCase;
  final GetUnitDetailsUseCase _getUnitDetailsUseCase;
  final UpdateUnitUseCase _updateUnitUseCase;

  UnitEditCubit(
    this._getUnitsFormDataUseCase,
    this._getUnitDetailsUseCase,
    this._updateUnitUseCase,
  ) : super(const UnitEditState());

  Future<void> loadData(int propertyId, int unitId) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final formDataResult = await _getUnitsFormDataUseCase();
    
    await formDataResult.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, error: failure));
      },
      (formData) async {
        final detailsResult = await _getUnitDetailsUseCase(propertyId, unitId);
        
        detailsResult.fold(
          (failure) {
            emit(state.copyWith(isLoading: false, error: failure));
          },
          (unitDetails) {
            emit(state.copyWith(
              isLoading: false,
              formData: formData,
              initialUnit: unitDetails,
            ));
          },
        );
      },
    );
  }

  Future<bool> submit({
    required int unitId,
    required String name,
    required String unitNumber,
    required String unitType,
    required String unitStatus,
    required String purpose,
    String? usageType,
    String? finishingType,
    required bool isFurnished,
    String? description,
    bool isCompleted = true,
    String? constructionDate,
    int? maxOccupancy,
    String? floorType,
    int? floorNumber,
    required double area,
    double? length,
    double? width,
    double? height,
    double? facadeLength,
    int? roomsCount,
    int? hallsCount,
    int? bathroomsCount,
    int? kitchensCount,
    int? entrancesCount,
    String? buildingNumber,
    String? streetName,
    String? district,
    String? city,
    String? region,
    String? postalCode,
    String? additionalNumber,
    String? shortAddress,
    double? latitude,
    double? longitude,
    String? direction,
    String? electricityMeterNumber,
    String? waterMeterNumber,
    String? gasMeterNumber,
    List<String> amenities = const [],
    List<File> images = const [],
    List<File> videos = const [],
    List<File> files = const [],
    List<int> deleteImages = const [],
    List<int> deleteVideos = const [],
    List<int> deleteFiles = const [],
    double? annualRent2Payments,
    double? annualRent4Payments,
    double? annualRentMonthly,
    bool usePriceForMortgage = false,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    final updateEntity = UnitUpdateEntity(
      name: name,
      unitNumber: unitNumber,
      unitType: unitType,
      unitStatus: unitStatus,
      purpose: purpose,
      usageType: usageType,
      finishingType: finishingType,
      isFurnished: isFurnished,
      description: description,
      isCompleted: isCompleted,
      constructionDate: constructionDate,
      maxOccupancy: maxOccupancy,
      floorType: floorType,
      floorNumber: floorNumber,
      area: area,
      length: length,
      width: width,
      height: height,
      facadeLength: facadeLength,
      roomsCount: roomsCount,
      hallsCount: hallsCount,
      bathroomsCount: bathroomsCount,
      kitchensCount: kitchensCount,
      entrancesCount: entrancesCount,
      buildingNumber: buildingNumber,
      streetName: streetName,
      district: district,
      city: city,
      region: region,
      postalCode: postalCode,
      additionalNumber: additionalNumber,
      shortAddress: shortAddress,
      latitude: latitude,
      longitude: longitude,
      direction: direction,
      electricityMeterNumber: electricityMeterNumber,
      waterMeterNumber: waterMeterNumber,
      gasMeterNumber: gasMeterNumber,
      amenities: amenities,
      images: images,
      videos: videos,
      files: files,
      deleteImages: deleteImages,
      deleteVideos: deleteVideos,
      deleteFiles: deleteFiles,
      annualRent2Payments: annualRent2Payments,
      annualRent4Payments: annualRent4Payments,
      annualRentMonthly: annualRentMonthly,
      usePriceForMortgage: usePriceForMortgage,
    );

    final result = await _updateUnitUseCase(unitId, updateEntity);

    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, submitError: failure));
        return false;
      },
      (success) {
        emit(state.copyWith(isSubmitting: false));
        return true;
      },
    );
  }
}
