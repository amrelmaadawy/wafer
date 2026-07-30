import 'package:equatable/equatable.dart';
import 'dart:io';

class UnitCreateState extends Equatable {
  final int currentStep;
  final bool isLoading;
  final String? error;

  // Property Context
  final int? propertyId;

  // Step 1: Basic
  final String? name;
  final String? unitNumber;
  final String unitType;
  final String unitStatus;
  final String purpose;
  final String usageType;
  final String finishingType;
  final bool isFurnished;
  final String? description;
  final bool isCompleted;
  final DateTime? constructionDate;
  final int? maxOccupancy;

  // Step 2: Dimensions & Specs
  final String floorType;
  final int? floorNumber;
  final double? area;
  final double? length;
  final double? width;
  final double? height;
  final double? facadeLength;
  final int? roomsCount;
  final int? hallsCount;
  final int? bathroomsCount;
  final int? kitchensCount;
  final int? entrancesCount;

  // Step 3: Location & Utilities
  final String? buildingNumber;
  final String? streetName;
  final String? district;
  final String? city;
  final String? region;
  final String? postalCode;
  final String? additionalNumber;
  final String? shortAddress;
  final double? latitude;
  final double? longitude;
  final String? direction;

  final String? electricityMeterNumber;
  final String? waterMeterNumber;
  final String? gasMeterNumber;
  final List<String> amenities;

  // Step 4: Images
  final List<File> images;

  // Step 5: Financials
  final double? annualRent2Payments;
  final double? annualRent4Payments;
  final double? annualRentMonthly;
  final bool usePriceForMortgage;

  const UnitCreateState({
    this.currentStep = 0,
    this.isLoading = false,
    this.error,
    this.propertyId,
    // Step 1
    this.name,
    this.unitNumber,
    this.unitType = 'apartment',
    this.unitStatus = 'available',
    this.purpose = 'for_rent',
    this.usageType = 'residential',
    this.finishingType = 'finished',
    this.isFurnished = false,
    this.description,
    this.isCompleted = true,
    this.constructionDate,
    this.maxOccupancy,
    // Step 2
    this.floorType = 'typical',
    this.floorNumber,
    this.area,
    this.length,
    this.width,
    this.height,
    this.facadeLength,
    this.roomsCount,
    this.hallsCount,
    this.bathroomsCount,
    this.kitchensCount,
    this.entrancesCount,
    // Step 3
    this.buildingNumber,
    this.streetName,
    this.district,
    this.city,
    this.region,
    this.postalCode,
    this.additionalNumber,
    this.shortAddress,
    this.latitude,
    this.longitude,
    this.direction,
    this.electricityMeterNumber,
    this.waterMeterNumber,
    this.gasMeterNumber,
    this.amenities = const [],
    // Step 4
    this.images = const [],
    // Step 5
    this.annualRent2Payments,
    this.annualRent4Payments,
    this.annualRentMonthly,
    this.usePriceForMortgage = false,
  });

  UnitCreateState copyWith({
    int? currentStep,
    bool? isLoading,
    String? error,
    int? propertyId,
    String? name,
    String? unitNumber,
    String? unitType,
    String? unitStatus,
    String? purpose,
    String? usageType,
    String? finishingType,
    bool? isFurnished,
    String? description,
    bool? isCompleted,
    DateTime? constructionDate,
    int? maxOccupancy,
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
    List<String>? amenities,
    List<File>? images,
    double? annualRent2Payments,
    double? annualRent4Payments,
    double? annualRentMonthly,
    bool? usePriceForMortgage,
  }) {
    return UnitCreateState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      propertyId: propertyId ?? this.propertyId,
      name: name ?? this.name,
      unitNumber: unitNumber ?? this.unitNumber,
      unitType: unitType ?? this.unitType,
      unitStatus: unitStatus ?? this.unitStatus,
      purpose: purpose ?? this.purpose,
      usageType: usageType ?? this.usageType,
      finishingType: finishingType ?? this.finishingType,
      isFurnished: isFurnished ?? this.isFurnished,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      constructionDate: constructionDate ?? this.constructionDate,
      maxOccupancy: maxOccupancy ?? this.maxOccupancy,
      floorType: floorType ?? this.floorType,
      floorNumber: floorNumber ?? this.floorNumber,
      area: area ?? this.area,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      facadeLength: facadeLength ?? this.facadeLength,
      roomsCount: roomsCount ?? this.roomsCount,
      hallsCount: hallsCount ?? this.hallsCount,
      bathroomsCount: bathroomsCount ?? this.bathroomsCount,
      kitchensCount: kitchensCount ?? this.kitchensCount,
      entrancesCount: entrancesCount ?? this.entrancesCount,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      streetName: streetName ?? this.streetName,
      district: district ?? this.district,
      city: city ?? this.city,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      additionalNumber: additionalNumber ?? this.additionalNumber,
      shortAddress: shortAddress ?? this.shortAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      direction: direction ?? this.direction,
      electricityMeterNumber:
          electricityMeterNumber ?? this.electricityMeterNumber,
      waterMeterNumber: waterMeterNumber ?? this.waterMeterNumber,
      gasMeterNumber: gasMeterNumber ?? this.gasMeterNumber,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      annualRent2Payments: annualRent2Payments ?? this.annualRent2Payments,
      annualRent4Payments: annualRent4Payments ?? this.annualRent4Payments,
      annualRentMonthly: annualRentMonthly ?? this.annualRentMonthly,
      usePriceForMortgage: usePriceForMortgage ?? this.usePriceForMortgage,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    isLoading,
    error,
    propertyId,
    name,
    unitNumber,
    unitType,
    unitStatus,
    purpose,
    usageType,
    finishingType,
    isFurnished,
    description,
    isCompleted,
    constructionDate,
    maxOccupancy,
    floorType,
    floorNumber,
    area,
    length,
    width,
    height,
    facadeLength,
    roomsCount,
    hallsCount,
    bathroomsCount,
    kitchensCount,
    entrancesCount,
    buildingNumber,
    streetName,
    district,
    city,
    region,
    postalCode,
    additionalNumber,
    shortAddress,
    latitude,
    longitude,
    direction,
    electricityMeterNumber,
    waterMeterNumber,
    gasMeterNumber,
    amenities,
    images,
    annualRent2Payments,
    annualRent4Payments,
    annualRentMonthly,
    usePriceForMortgage,
  ];
}
