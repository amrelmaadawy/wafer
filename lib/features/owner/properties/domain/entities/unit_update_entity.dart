import 'unit_create_entity.dart';

class UnitUpdateEntity extends UnitCreateEntity {
  final List<int> deleteImages;
  final List<int> deleteVideos;
  final List<int> deleteFiles;

  const UnitUpdateEntity({
    required super.name,
    required super.unitNumber,
    required super.unitType,
    required super.unitStatus,
    required super.purpose,
    super.usageType,
    super.finishingType,
    required super.isFurnished,
    super.description,
    super.isCompleted,
    super.constructionDate,
    super.maxOccupancy,
    super.floorType,
    super.floorNumber,
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
    super.videos = const [],
    super.files = const [],
    this.deleteImages = const [],
    this.deleteVideos = const [],
    this.deleteFiles = const [],
    super.annualRent2Payments,
    super.annualRent4Payments,
    super.annualRentMonthly,
    super.usePriceForMortgage,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        deleteImages,
        deleteVideos,
        deleteFiles,
      ];
}
