import 'package:dio/dio.dart';
import '../../domain/entities/unit_create_entity.dart';

class UnitCreateModel extends UnitCreateEntity {
  const UnitCreateModel({
    required super.name,
    required super.unitNumber,
    required super.unitType,
    required super.unitStatus,
    required super.purpose,
    required super.usageType,
    required super.finishingType,
    required super.isFurnished,
    super.description,
    super.isCompleted,
    super.constructionDate,
    super.maxOccupancy,
    required super.floorType,
    required super.floorNumber,
    required super.area,
    super.length,
    super.width,
    super.height,
    super.facadeLength,
    super.roomsCount,
    super.hallsCount,
    super.bathroomsCount,
    super.kitchensCount,
    super.entrancesCount,
    super.buildingNumber,
    super.streetName,
    super.district,
    super.city,
    super.region,
    super.postalCode,
    super.additionalNumber,
    super.shortAddress,
    super.latitude,
    super.longitude,
    super.direction,
    super.electricityMeterNumber,
    super.waterMeterNumber,
    super.gasMeterNumber,
    super.amenities,
    super.images,
    super.annualRent2Payments,
    super.annualRent4Payments,
    super.annualRentMonthly,
    super.usePriceForMortgage,
  });

  factory UnitCreateModel.fromEntity(UnitCreateEntity entity) {
    return UnitCreateModel(
      name: entity.name,
      unitNumber: entity.unitNumber,
      unitType: entity.unitType,
      unitStatus: entity.unitStatus,
      purpose: entity.purpose,
      usageType: entity.usageType,
      finishingType: entity.finishingType,
      isFurnished: entity.isFurnished,
      description: entity.description,
      isCompleted: entity.isCompleted,
      constructionDate: entity.constructionDate,
      maxOccupancy: entity.maxOccupancy,
      floorType: entity.floorType,
      floorNumber: entity.floorNumber,
      area: entity.area,
      length: entity.length,
      width: entity.width,
      height: entity.height,
      facadeLength: entity.facadeLength,
      roomsCount: entity.roomsCount,
      hallsCount: entity.hallsCount,
      bathroomsCount: entity.bathroomsCount,
      kitchensCount: entity.kitchensCount,
      entrancesCount: entity.entrancesCount,
      buildingNumber: entity.buildingNumber,
      streetName: entity.streetName,
      district: entity.district,
      city: entity.city,
      region: entity.region,
      postalCode: entity.postalCode,
      additionalNumber: entity.additionalNumber,
      shortAddress: entity.shortAddress,
      latitude: entity.latitude,
      longitude: entity.longitude,
      direction: entity.direction,
      electricityMeterNumber: entity.electricityMeterNumber,
      waterMeterNumber: entity.waterMeterNumber,
      gasMeterNumber: entity.gasMeterNumber,
      amenities: entity.amenities,
      images: entity.images,
      annualRent2Payments: entity.annualRent2Payments,
      annualRent4Payments: entity.annualRent4Payments,
      annualRentMonthly: entity.annualRentMonthly,
      usePriceForMortgage: entity.usePriceForMortgage,
    );
  }

  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      'name': name,
      'unit_number': unitNumber,
      'unit_type': unitType,
      'unit_status': unitStatus,
      'purpose': purpose,
      'usage_type': usageType,
      'floor_type': floorType,
      'floor_number': floorNumber,
      'area': area,
      'is_completed': isCompleted ? 1 : 0,
      'is_furnished': isFurnished ? 1 : 0,
      'use_price_for_mortgage': usePriceForMortgage ? 1 : 0,
      'finishing_type': finishingType,
    };

    if (description != null && description!.isNotEmpty) data['description'] = description;
    if (constructionDate != null) data['construction_date'] = constructionDate;
    if (maxOccupancy != null) data['max_occupancy'] = maxOccupancy;
    if (length != null) data['length'] = length;
    if (width != null) data['width'] = width;
    if (height != null) data['height'] = height;
    if (facadeLength != null) data['facade_length'] = facadeLength;
    if (roomsCount != null) data['rooms_count'] = roomsCount;
    if (hallsCount != null) data['halls_count'] = hallsCount;
    if (bathroomsCount != null) data['bathrooms_count'] = bathroomsCount;
    if (kitchensCount != null) data['kitchens_count'] = kitchensCount;
    if (entrancesCount != null) data['entrances_count'] = entrancesCount;
    if (buildingNumber != null) data['building_number'] = buildingNumber;
    if (streetName != null) data['street_name'] = streetName;
    if (district != null) data['district'] = district;
    if (city != null) data['city'] = city;
    if (region != null) data['region'] = region;
    if (postalCode != null) data['postal_code'] = postalCode;
    if (additionalNumber != null) data['additional_number'] = additionalNumber;
    if (shortAddress != null) data['short_address'] = shortAddress;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (direction != null) data['direction'] = direction;
    if (electricityMeterNumber != null) data['electricity_meter_number'] = electricityMeterNumber;
    if (waterMeterNumber != null) data['water_meter_number'] = waterMeterNumber;
    if (gasMeterNumber != null) data['gas_meter_number'] = gasMeterNumber;
    if (annualRent2Payments != null) data['annual_rent_2_payments'] = annualRent2Payments;
    if (annualRent4Payments != null) data['annual_rent_4_payments'] = annualRent4Payments;
    if (annualRentMonthly != null) data['annual_rent_monthly'] = annualRentMonthly;

    for (var i = 0; i < amenities.length; i++) {
      data['amenities[$i]'] = amenities[i];
    }

    final formData = FormData.fromMap(data);

    for (var i = 0; i < images.length; i++) {
      formData.files.add(MapEntry(
        'images[$i]',
        await MultipartFile.fromFile(images[i].path),
      ));
    }

    return formData;
  }
}
