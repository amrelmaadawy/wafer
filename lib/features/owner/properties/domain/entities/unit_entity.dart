import 'package:equatable/equatable.dart';

class UnitDetailsEntity extends Equatable {
  final int roomsCount;
  final int bathroomsCount;
  final int hallsCount;
  final int kitchensCount;

  const UnitDetailsEntity({
    this.roomsCount = 0,
    this.bathroomsCount = 0,
    this.hallsCount = 0,
    this.kitchensCount = 0,
  });

  @override
  List<Object?> get props => [roomsCount, bathroomsCount, hallsCount, kitchensCount];
}

class UnitPricesEntity extends Equatable {
  final num monthly;
  final num perTwoMonths;
  final num quarterly;

  const UnitPricesEntity({
    this.monthly = 0,
    this.perTwoMonths = 0,
    this.quarterly = 0,
  });

  @override
  List<Object?> get props => [monthly, perTwoMonths, quarterly];
}

class UnitEntity extends Equatable {
  final int id;
  final int propertyId;
  final String? name;
  final String? code;
  final String unitNumber;
  final String? floor;
  final num? area;
  final String? type;
  final String? typeLabel;
  final String status;
  final String? statusLabel;
  final num rentPrice;
  final num? deposit;
  final String? specs;
  final String? createdAt;
  
  final bool isFurnished;
  final String? image;
  final UnitDetailsEntity details;
  final UnitPricesEntity prices;

  const UnitEntity({
    required this.id,
    required this.propertyId,
    this.name,
    this.code,
    required this.unitNumber,
    this.floor,
    this.area,
    this.type,
    this.typeLabel,
    required this.status,
    this.statusLabel,
    required this.rentPrice,
    this.deposit,
    this.specs,
    this.createdAt,
    this.isFurnished = false,
    this.image,
    this.details = const UnitDetailsEntity(),
    this.prices = const UnitPricesEntity(),
  });

  bool get isVacant => status.toLowerCase() == 'vacant';
  bool get isOccupied => status.toLowerCase() == 'occupied' || status.toLowerCase() == 'rented';
  bool get isReserved => status.toLowerCase() == 'reserved';
  bool get isMaintenance => status.toLowerCase() == 'under_maintenance' || status.toLowerCase() == 'maintenance';

  @override
  List<Object?> get props => [
        id,
        propertyId,
        name,
        code,
        unitNumber,
        floor,
        area,
        type,
        typeLabel,
        status,
        statusLabel,
        rentPrice,
        deposit,
        specs,
        createdAt,
        isFurnished,
        image,
        details,
        prices,
      ];
}
