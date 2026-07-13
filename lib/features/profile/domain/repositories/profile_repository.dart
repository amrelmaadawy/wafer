import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile({bool forceRefresh = false});
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String name,
    required String phone,
    required String gender,
  });
}
