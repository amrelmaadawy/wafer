import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/deeds_query_filter_entity.dart';
import '../entities/deeds_response_entity.dart';
import '../repositories/deed_repository.dart';

class GetDeedsUseCase {
  final DeedRepository repository;

  GetDeedsUseCase(this.repository);

  Future<Either<Failure, DeedsResponseEntity>> call({
    required DeedsQueryFilterEntity filter,
  }) async {
    return await repository.getDeeds(filter: filter);
  }
}
