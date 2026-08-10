import 'package:dio/dio.dart';
import '../../domain/entities/unit_update_entity.dart';

class UnitUpdateModel extends UnitUpdateEntity {
  const UnitUpdateModel({
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
    super.videos,
    super.files,
    super.deleteImages,
    super.deleteVideos,
    super.deleteFiles,
    super.annualRent2Payments,
    super.annualRent4Payments,
    super.annualRentMonthly,
    super.usePriceForMortgage,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      '_method': 'PUT',
      'name': name,
      'unit_number': unitNumber,
      'unit_type': unitType,
      'unit_status': unitStatus,
      'purpose': purpose,
      'usage_type': usageType,
      'area': area,
      'is_completed': isCompleted ? 1 : 0,
      'is_furnished': isFurnished ? 1 : 0,
      'use_price_for_mortgage': usePriceForMortgage ? 1 : 0,
    };

    if (floorType != null) {
      data['floor_type'] = floorType;
    }
    if (usageType != null) data['usage_type'] = usageType;
    if (finishingType != null) data['finishing_type'] = finishingType;
    if (floorNumber != null) data['floor_number'] = floorNumber;

    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
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
    if (electricityMeterNumber != null) {
      data['electricity_meter_number'] = electricityMeterNumber;
    }
    if (waterMeterNumber != null) data['water_meter_number'] = waterMeterNumber;
    if (gasMeterNumber != null) data['gas_meter_number'] = gasMeterNumber;
    if (annualRent2Payments != null) {
      data['annual_rent_2_payments'] = annualRent2Payments;
    }
    if (annualRent4Payments != null) {
      data['annual_rent_4_payments'] = annualRent4Payments;
    }
    if (annualRentMonthly != null) {
      data['annual_rent_monthly'] = annualRentMonthly;
    }

    for (var i = 0; i < amenities.length; i++) {
      data['amenities[$i]'] = amenities[i];
    }
    
    for (var i = 0; i < deleteImages.length; i++) {
      data['delete_images[$i]'] = deleteImages[i];
    }
    
    for (var i = 0; i < deleteVideos.length; i++) {
      data['delete_videos[$i]'] = deleteVideos[i];
    }
    
    for (var i = 0; i < deleteFiles.length; i++) {
      data['delete_attachments[$i]'] = deleteFiles[i];
    }

    final formData = FormData.fromMap(data);

    for (var i = 0; i < images.length; i++) {
      formData.files.add(
        MapEntry('images[$i]', await MultipartFile.fromFile(images[i].path)),
      );
    }
    

    
    for (var i = 0; i < videos.length; i++) {
      formData.files.add(
        MapEntry('videos[$i]', await MultipartFile.fromFile(videos[i].path)),
      );
    }

    for (var i = 0; i < files.length; i++) {
      formData.files.add(
        MapEntry('attachments[$i]', await MultipartFile.fromFile(files[i].path)),
      );
    }

    return formData;
  }
}
