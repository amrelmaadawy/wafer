import 'package:dartz/dartz.dart';
import 'package:wafer/core/error/failures.dart';
import '../entities/search_results_grouped_entity.dart';
import '../repositories/search_repository.dart';

class GlobalSearchUseCase {
  final SearchRepository _repository;

  GlobalSearchUseCase(this._repository);

  Future<Either<Failure, SearchResultsGroupedEntity>> call(String query) {
    return _repository.search(query);
  }
}
