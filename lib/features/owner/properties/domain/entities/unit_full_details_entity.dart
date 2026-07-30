import 'package:equatable/equatable.dart';

class UnitMetersEntity extends Equatable {
  final String? electricity;
  final String? water;
  final String? gas;

  const UnitMetersEntity({this.electricity, this.water, this.gas});

  @override
  List<Object?> get props => [electricity, water, gas];
}

class UnitFullDetailsEntity extends Equatable {
  final int id;
  final int? propertyId;
  final String? name;
  final String unitNumber;
  final String? code;
  final String? type;
  final String? typeLabel;
  final String status;
  final String? statusLabel;
  final String? usageType;
  final String? floor;
  final num? area;
  final num? length;
  final num? width;
  final num? height;
  final num? facadeLength;
  final String? direction;
  final bool isFurnished;
  final String? finishingType;
  final String? description;
  final UnitMetersEntity meters;
  final List<String> amenities;
  final List<String> images;

  // Details counts
  final int roomsCount;
  final int bathroomsCount;
  final int hallsCount;
  final int kitchensCount;
  final int entrancesCount;

  // Prices
  final num rentPrice;
  final num monthlyPrice;
  final num perTwoPaymentsPrice;
  final num quarterlyPrice;

  // Contracts (we keep them as dynamic/Map for now unless we have a specific entity)
  final dynamic currentContract;
  final List<dynamic> contractsHistory;

  const UnitFullDetailsEntity({
    required this.id,
    this.propertyId,
    this.name,
    required this.unitNumber,
    this.code,
    this.type,
    this.typeLabel,
    required this.status,
    this.statusLabel,
    this.usageType,
    this.floor,
    this.area,
    this.length,
    this.width,
    this.height,
    this.facadeLength,
    this.direction,
    this.isFurnished = false,
    this.finishingType,
    this.description,
    this.meters = const UnitMetersEntity(),
    this.amenities = const [],
    this.images = const [],
    this.roomsCount = 0,
    this.bathroomsCount = 0,
    this.hallsCount = 0,
    this.kitchensCount = 0,
    this.entrancesCount = 0,
    required this.rentPrice,
    this.monthlyPrice = 0,
    this.perTwoPaymentsPrice = 0,
    this.quarterlyPrice = 0,
    this.currentContract,
    this.contractsHistory = const [],
  });

  bool get isVacant => status.toLowerCase() == 'vacant';
  bool get isOccupied =>
      status.toLowerCase() == 'occupied' || status.toLowerCase() == 'rented';
  bool get isReserved => status.toLowerCase() == 'reserved';
  bool get isMaintenance =>
      status.toLowerCase() == 'under_maintenance' ||
      status.toLowerCase() == 'maintenance';

  @override
  List<Object?> get props => [
    id,
    propertyId,
    name,
    unitNumber,
    code,
    type,
    typeLabel,
    status,
    statusLabel,
    usageType,
    floor,
    area,
    length,
    width,
    height,
    facadeLength,
    direction,
    isFurnished,
    finishingType,
    description,
    meters,
    amenities,
    images,
    roomsCount,
    bathroomsCount,
    hallsCount,
    kitchensCount,
    entrancesCount,
    rentPrice,
    monthlyPrice,
    perTwoPaymentsPrice,
    quarterlyPrice,
    currentContract,
    contractsHistory,
  ];
}
