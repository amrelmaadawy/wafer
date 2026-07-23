import 'package:equatable/equatable.dart';

class DeedBranchEntity extends Equatable {
  final int id;
  final String name;

  const DeedBranchEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class DeedPropertyEntity extends Equatable {
  final int id;
  final String? name;
  final String code;
  final String? propertyType;
  final String? usageType;
  final String? status;

  const DeedPropertyEntity({
    required this.id,
    this.name,
    required this.code,
    this.propertyType,
    this.usageType,
    this.status,
  });

  @override
  List<Object?> get props => [id, name, code, propertyType, usageType, status];
}

class DeedEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final String? documentType;
  final String? documentNumber;
  final String? documentDate;
  final num area;
  final String? documentAttachment;
  final String? city;
  final String? district;
  final String? region;
  final String? streetName;
  final String? buildingNumber;
  final String? shortAddress;
  final String? postalCode;
  final String? additionalNumber;
  final String? latitude;
  final String? longitude;
  final String? notes;
  final DeedBranchEntity? branch;
  final int propertiesCount;
  final String? createdAt;
  final List<DeedPropertyEntity> properties;

  const DeedEntity({
    required this.id,
    required this.name,
    required this.code,
    this.documentType,
    this.documentNumber,
    this.documentDate,
    required this.area,
    this.documentAttachment,
    this.city,
    this.district,
    this.region,
    this.streetName,
    this.buildingNumber,
    this.shortAddress,
    this.postalCode,
    this.additionalNumber,
    this.latitude,
    this.longitude,
    this.notes,
    this.branch,
    required this.propertiesCount,
    this.createdAt,
    this.properties = const [],
  });

  bool get isElectronic => documentType?.toLowerCase() == 'electronic';
  bool get hasAttachment => documentAttachment != null && documentAttachment!.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        documentType,
        documentNumber,
        documentDate,
        area,
        documentAttachment,
        city,
        district,
        region,
        streetName,
        buildingNumber,
        shortAddress,
        postalCode,
        additionalNumber,
        latitude,
        longitude,
        notes,
        branch,
        propertiesCount,
        createdAt,
        properties,
      ];
}
