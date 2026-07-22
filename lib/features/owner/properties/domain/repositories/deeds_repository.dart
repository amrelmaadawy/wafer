import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/deed_entity.dart';

abstract class DeedsRepository {
  Future<Either<Failure, List<DeedEntity>>> getOwnerDeeds();
  Future<Either<Failure, DeedEntity>> createDeed(Map<String, dynamic> body);
}
