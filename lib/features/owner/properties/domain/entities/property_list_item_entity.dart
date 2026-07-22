import 'package:equatable/equatable.dart';

class PropertyListItemEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final String status;
  final String statusLabel;
  final String propertyType;
  final String? usageType;
  final num? area;
  final String? city;
  final String? district;
  final String? deedNumber;
  final String? primaryOwnerName;
  final int unitsCount;
  final int availableUnits;
  final int rentedUnits;
  final num occupancyRate;
  final String? imageUrl;

  const PropertyListItemEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.status,
    required this.statusLabel,
    required this.propertyType,
    this.usageType,
    this.area,
    this.city,
    this.district,
    this.deedNumber,
    this.primaryOwnerName,
    required this.unitsCount,
    required this.availableUnits,
    required this.rentedUnits,
    required this.occupancyRate,
    this.imageUrl,
  });

  bool get isDraft => status.toLowerCase() == 'draft';
  bool get isPublished => status.toLowerCase() == 'published';

  String get displayAddress {
    final parts = [if (city != null && city!.isNotEmpty) city, if (district != null && district!.isNotEmpty) district];
    return parts.isEmpty ? 'غير محدد' : parts.join(' - ');
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
        area,
        city,
        district,
        deedNumber,
        primaryOwnerName,
        unitsCount,
        availableUnits,
        rentedUnits,
        occupancyRate,
        imageUrl,
      ];
}
