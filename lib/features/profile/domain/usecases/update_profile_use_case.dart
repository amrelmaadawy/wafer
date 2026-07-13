import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, ProfileEntity>> call({
    required String name,
    required String phone,
    required String gender,
  }) async {
    return await _repository.updateProfile(
      name: name,
      phone: phone,
      gender: gender,
    );
  }
}
