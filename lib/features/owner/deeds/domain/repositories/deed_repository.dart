import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/deeds_query_filter_entity.dart';
import '../entities/deeds_response_entity.dart';

abstract class DeedRepository {
  Future<Either<Failure, DeedsResponseEntity>> getDeeds({
    required DeedsQueryFilterEntity filter,
  });
}
