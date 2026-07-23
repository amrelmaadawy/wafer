import 'package:equatable/equatable.dart';
import '../../../domain/entities/deed_entity.dart';
import '../../../domain/entities/deeds_pagination_meta_entity.dart';
import '../../../domain/entities/deeds_query_filter_entity.dart';

abstract class DeedsListState extends Equatable {
  const DeedsListState();

  @override
  List<Object?> get props => [];
}

class DeedsListInitial extends DeedsListState {
  const DeedsListInitial();
}

class DeedsListLoading extends DeedsListState {
  const DeedsListLoading();
}

class DeedsListLoaded extends DeedsListState {
  final List<DeedEntity> deeds;
  final DeedsPaginationMetaEntity meta;
  final DeedsQueryFilterEntity filter;
  final bool isFetchingMore;

  const DeedsListLoaded({
    required this.deeds,
    required this.meta,
    this.filter = const DeedsQueryFilterEntity(),
    this.isFetchingMore = false,
  });

  DeedsListLoaded copyWith({
    List<DeedEntity>? deeds,
    DeedsPaginationMetaEntity? meta,
    DeedsQueryFilterEntity? filter,
    bool? isFetchingMore,
  }) {
    return DeedsListLoaded(
      deeds: deeds ?? this.deeds,
      meta: meta ?? this.meta,
      filter: filter ?? this.filter,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [deeds, meta, filter, isFetchingMore];
}

class DeedsListEmpty extends DeedsListState {
  final DeedsQueryFilterEntity filter;
  const DeedsListEmpty({this.filter = const DeedsQueryFilterEntity()});

  @override
  List<Object?> get props => [filter];
}

class DeedsListError extends DeedsListState {
  final String message;

  const DeedsListError(this.message);

  @override
  List<Object?> get props => [message];
}
