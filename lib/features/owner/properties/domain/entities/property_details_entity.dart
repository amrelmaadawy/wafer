import 'package:equatable/equatable.dart';
import 'property_owner_entity.dart';

class PropertyDetailsEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final String status;
  final String statusLabel;
  final String propertyType;
  final String? usageType;
  final int? constructionYear;
  final num? area;
  final num? length;
  final num? width;
  final String? city;
  final String? district;
  final String? region;
  final String? streetName;
  final String? buildingNumber;
  final String? branchName;
  final int? branchId;
  final String? description;
  final List<String> imageUrls;
  final int? deedId;
  final String? deedNumber;
  final String? deedDate;
  final String? documentType;
  final String? deedAttachment;
  final num? valuationAmount;
  final String? valuationEntity;
  final String? valuationDate;
  final List<PropertyOwnerEntity> owners;
  final int unitsCount;
  final int rentedUnits;
  final int availableUnits;
  final num occupancyRate;
  final List<String> amenities;
  final String? createdAt;
  final int completionPercentage;

  const PropertyDetailsEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.status,
    required this.statusLabel,
    required this.propertyType,
    this.usageType,
    this.constructionYear,
    this.area,
    this.length,
    this.width,
    this.city,
    this.district,
    this.region,
    this.streetName,
    this.buildingNumber,
    this.branchName,
    this.branchId,
    this.description,
    required this.imageUrls,
    this.deedId,
    this.deedNumber,
    this.deedDate,
    this.documentType,
    this.deedAttachment,
    this.valuationAmount,
    this.valuationEntity,
    this.valuationDate,
    required this.owners,
    required this.unitsCount,
    required this.rentedUnits,
    required this.availableUnits,
    required this.occupancyRate,
    required this.amenities,
    this.createdAt,
    this.completionPercentage = 0,
  });

  bool get isDraft => status.toLowerCase() == 'draft';
  bool get isPublished => status.toLowerCase() == 'published';
  bool get isLand => propertyType.toLowerCase() == 'land';

  String get type => propertyType;
  String? get address => formattedAddress;

  String get formattedAddress {
    final parts = [
      if (city != null && city!.isNotEmpty) city,
      if (district != null && district!.isNotEmpty) district,
      if (streetName != null && streetName!.isNotEmpty) streetName,
      if (buildingNumber != null && buildingNumber!.isNotEmpty) 'مبنى $buildingNumber',
    ];
    return parts.isEmpty ? 'غير محدد' : parts.join('، ');
  }

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        status,
        statusLabel,
        propertyType,
        usageType,
        constructionYear,
        area,
        length,
        width,
        city,
        district,
        region,
        streetName,
        buildingNumber,
        branchName,
        branchId,
        description,
        imageUrls,
        deedId,
        deedNumber,
        deedDate,
        documentType,
        deedAttachment,
        valuationAmount,
        valuationEntity,
        valuationDate,
        owners,
        unitsCount,
        rentedUnits,
        availableUnits,
        occupancyRate,
        amenities,
        createdAt,
        completionPercentage,
      ];
}
