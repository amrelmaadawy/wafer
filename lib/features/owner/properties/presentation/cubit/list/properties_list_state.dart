import 'package:equatable/equatable.dart';
import '../../../domain/entities/properties_pagination_meta_entity.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../../domain/entities/properties_stats_entity.dart';
import '../../../domain/entities/property_list_item_entity.dart';

abstract class PropertiesListState extends Equatable {
  const PropertiesListState();

  @override
  List<Object?> get props => [];
}

class PropertiesListInitial extends PropertiesListState {
  const PropertiesListInitial();
}

class PropertiesListLoading extends PropertiesListState {
  const PropertiesListLoading();
}

class PropertiesListLoaded extends PropertiesListState {
  final List<PropertyListItemEntity> properties;
  final PropertiesPaginationMetaEntity meta;
  final PropertiesStatsEntity? stats;
  final PropertiesQueryFilterEntity filter;
  final bool isFetchingMore;

  const PropertiesListLoaded({
    required this.properties,
    required this.meta,
    this.stats,
    this.filter = const PropertiesQueryFilterEntity(),
    this.isFetchingMore = false,
  });

  PropertiesListLoaded copyWith({
    List<PropertyListItemEntity>? properties,
    PropertiesPaginationMetaEntity? meta,
    PropertiesStatsEntity? stats,
    PropertiesQueryFilterEntity? filter,
    bool? isFetchingMore,
  }) {
    return PropertiesListLoaded(
      properties: properties ?? this.properties,
      meta: meta ?? this.meta,
      stats: stats ?? this.stats,
      filter: filter ?? this.filter,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [properties, meta, stats, filter, isFetchingMore];
}

class PropertiesListEmpty extends PropertiesListState {
  final PropertiesQueryFilterEntity filter;
  const PropertiesListEmpty({this.filter = const PropertiesQueryFilterEntity()});

  @override
  List<Object?> get props => [filter];
}

class PropertiesListError extends PropertiesListState {
  final String message;

  const PropertiesListError(this.message);

  @override
  List<Object?> get props => [message];
}
