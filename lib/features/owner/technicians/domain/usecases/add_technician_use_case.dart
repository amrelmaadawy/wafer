import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/technician_entity.dart';
import '../repositories/technicians_repository.dart';

class AddTechnicianParams extends Equatable {
  final String name;
  final String phone;
  final String specialty;
  final String companyName;
  final bool isActive;

  const AddTechnicianParams({
    required this.name,
    required this.phone,
    required this.specialty,
    required this.companyName,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'specialty': specialty,
      'company_name': companyName,
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [name, phone, specialty, companyName, isActive];
}

class AddTechnicianUseCase
    implements UseCase<TechnicianEntity, AddTechnicianParams> {
  final TechniciansRepository repository;

  AddTechnicianUseCase(this.repository);

  @override
  Future<Either<Failure, TechnicianEntity>> call(AddTechnicianParams params) {
    return repository.addTechnician(params);
  }
}
