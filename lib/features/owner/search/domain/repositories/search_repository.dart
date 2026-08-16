import 'package:dartz/dartz.dart';
import 'package:wafer/core/error/failures.dart';
import '../entities/search_results_grouped_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResultsGroupedEntity>> search(String query);
}
