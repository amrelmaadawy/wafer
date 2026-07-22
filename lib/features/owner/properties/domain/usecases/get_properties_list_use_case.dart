import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/properties_pagination_meta_entity.dart';
import '../entities/properties_query_filter_entity.dart';
import '../entities/properties_stats_entity.dart';
import '../entities/property_list_item_entity.dart';
import '../repositories/properties_repository.dart';

class GetPropertiesListUseCase {
  final PropertiesRepository _repository;

  GetPropertiesListUseCase(this._repository);

  Future<
      Either<
          Failure,
          ({
            List<PropertyListItemEntity> items,
            PropertiesPaginationMetaEntity meta,
            PropertiesStatsEntity stats,
          })>> call({
    PropertiesQueryFilterEntity? filter,
  }) {
    return _repository.getProperties(filter: filter);
  }
}
