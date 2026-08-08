import 'dart:io';
import 'unit_create_entity.dart';

class UnitUpdateEntity extends UnitCreateEntity {
  final List<int> deleteImages;
  final List<File> attachments;

  const UnitUpdateEntity({
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
    super.amenities = const [],
    super.images = const [],
    this.deleteImages = const [],
    this.attachments = const [],
    super.annualRent2Payments,
    super.annualRent4Payments,
    super.annualRentMonthly,
    super.usePriceForMortgage,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        deleteImages,
        attachments,
      ];
}
