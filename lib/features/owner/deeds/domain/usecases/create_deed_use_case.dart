import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/deed_repository.dart';

class AddNewDeedParams extends Equatable {
  final String name;
  final int branchId;
  final String documentType;
  final String documentNumber;
  final String documentDate;
  final num area;
  final File? documentAttachment;
  final String? city;
  final String? district;
  final String? region;
  final String? streetName;
  final String? buildingNumber;
  final String? postalCode;
  final String? notes;

  const AddNewDeedParams({
    required this.name,
    required this.branchId,
    required this.documentType,
    required this.documentNumber,
    required this.documentDate,
    required this.area,
    this.documentAttachment,
    this.city,
    this.district,
    this.region,
    this.streetName,
    this.buildingNumber,
    this.postalCode,
    this.notes,
  });

  @override
  List<Object?> get props => [
        name,
        branchId,
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
        postalCode,
        notes,
      ];
}

class AddNewDeedUseCase implements UseCase<void, AddNewDeedParams> {
  final DeedRepository repository;

  AddNewDeedUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddNewDeedParams params) {
    return repository.createDeed(params);
  }
}
