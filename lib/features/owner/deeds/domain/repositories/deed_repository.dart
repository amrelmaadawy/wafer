import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/deeds_query_filter_entity.dart';
import '../entities/deeds_response_entity.dart';
import '../entities/deed_entity.dart';
import '../usecases/create_deed_use_case.dart';

abstract class DeedRepository {
  Future<Either<Failure, DeedsResponseEntity>> getDeeds({
    required DeedsQueryFilterEntity filter,
  });
  Future<Either<Failure, void>> createDeed(AddNewDeedParams params);
  Future<Either<Failure, DeedEntity>> getDeedDetails(int id);
}
