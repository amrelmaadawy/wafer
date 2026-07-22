import 'package:equatable/equatable.dart';

class FormDeedEntity extends Equatable {
  final int id;
  final String code;
  final String name;
  final int? branchId;
  final num? area;
  final String? documentType;
  final String? documentNumber;
  final String? documentDate;
  final String? documentAttachment;
  final String? city;
  final String? district;
  final String? region;
  final String? streetName;
  final String? buildingNumber;
  final String? status;
  final String? notes;
  final int propertiesCount;

  const FormDeedEntity({
    required this.id,
    required this.code,
    required this.name,
    this.branchId,
    this.area,
    this.documentType,
    this.documentNumber,
    this.documentDate,
    this.documentAttachment,
    this.city,
    this.district,
    this.region,
    this.streetName,
    this.buildingNumber,
    this.status,
    this.notes,
    required this.propertiesCount,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        branchId,
        area,
        documentType,
        documentNumber,
        documentDate,
        documentAttachment,
        city,
        district,
        region,
        streetName,
        buildingNumber,
        status,
        notes,
        propertiesCount,
      ];
}
