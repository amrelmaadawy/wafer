import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateAvatarUseCase {
  final ProfileRepository _repository;

  UpdateAvatarUseCase(this._repository);

  Future<Either<Failure, ProfileEntity>> call({required String imagePath}) {
    return _repository.updateAvatar(imagePath: imagePath);
  }
}
