import 'package:equatable/equatable.dart';
import 'dart:io';

class UnitCreateEntity extends Equatable {
  // Step 1: Basic
  final String name;
  final String unitNumber;
  final String unitType;
  final String unitStatus;
  final String purpose;
  final String usageType;
  final String finishingType;
  final bool isFurnished;
  final String? description;
  final bool isCompleted;
  final String? constructionDate;
  final int? maxOccupancy;

  // Step 2: Dimensions & Specs
  final String floorType;
  final int floorNumber;
  final double area;
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

  const UnitCreateEntity({
    required this.name,
    required this.unitNumber,
    required this.unitType,
    required this.unitStatus,
    required this.purpose,
    required this.usageType,
    required this.finishingType,
    required this.isFurnished,
    this.description,
    this.isCompleted = true,
    this.constructionDate,
    this.maxOccupancy,
    required this.floorType,
    required this.floorNumber,
    required this.area,
    this.length,
    this.width,
    this.height,
    this.facadeLength,
    this.roomsCount,
    this.hallsCount,
    this.bathroomsCount,
    this.kitchensCount,
    this.entrancesCount,
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
    this.images = const [],
    this.annualRent2Payments,
    this.annualRent4Payments,
    this.annualRentMonthly,
    this.usePriceForMortgage = false,
  });

  @override
  List<Object?> get props => [
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
