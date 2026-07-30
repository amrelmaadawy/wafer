import 'package:equatable/equatable.dart';
import '../../../domain/entities/unit_entity.dart';
import '../../../domain/entities/properties_pagination_meta_entity.dart';

abstract class UnitsListState extends Equatable {
  const UnitsListState();

  @override
  List<Object?> get props => [];
}

class UnitsListInitial extends UnitsListState {
  const UnitsListInitial();
}

class UnitsListLoading extends UnitsListState {
  const UnitsListLoading();
}

class UnitsListLoaded extends UnitsListState {
  final List<UnitEntity> units;
  final PropertiesPaginationMetaEntity meta;
  final String? searchQuery;
  final String? unitStatus;
  final String? unitType;
  final bool isFetchingMore;

  const UnitsListLoaded({
    required this.units,
    required this.meta,
    this.searchQuery,
    this.unitStatus,
    this.unitType,
    this.isFetchingMore = false,
  });

  UnitsListLoaded copyWith({
    List<UnitEntity>? units,
    PropertiesPaginationMetaEntity? meta,
    String? searchQuery,
    String? unitStatus,
    String? unitType,
    bool? isFetchingMore,
  }) {
    return UnitsListLoaded(
      units: units ?? this.units,
      meta: meta ?? this.meta,
      searchQuery: searchQuery ?? this.searchQuery,
      unitStatus: unitStatus ?? this.unitStatus,
      unitType: unitType ?? this.unitType,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [
    units,
    meta,
    searchQuery,
    unitStatus,
    unitType,
    isFetchingMore,
  ];
}

class UnitsListEmpty extends UnitsListState {
  const UnitsListEmpty();
}

class UnitsListError extends UnitsListState {
  final String message;

  const UnitsListError(this.message);

  @override
  List<Object> get props => [message];
}
