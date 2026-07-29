import 'package:equatable/equatable.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_pagination_meta_entity.dart';
import '../../domain/entities/maintenance_sub_entities.dart';

abstract class OwnerMaintenanceState extends Equatable {
  const OwnerMaintenanceState();

  @override
  List<Object?> get props => [];
}

class OwnerMaintenanceInitial extends OwnerMaintenanceState {
  const OwnerMaintenanceInitial();
}

class OwnerMaintenanceLoading extends OwnerMaintenanceState {
  final String activeStatus;

  const OwnerMaintenanceLoading({this.activeStatus = 'all'});

  @override
  List<Object?> get props => [activeStatus];
}

class OwnerMaintenanceLoaded extends OwnerMaintenanceState {
  final List<MaintenanceItemEntity> items;
  final MaintenancePaginationMetaEntity meta;
  final MaintenanceStatsEntity? stats;
  final String activeStatus;
  final bool isFetchingMore;

  const OwnerMaintenanceLoaded({
    required this.items,
    required this.meta,
    this.stats,
    this.activeStatus = 'all',
    this.isFetchingMore = false,
  });

  OwnerMaintenanceLoaded copyWith({
    List<MaintenanceItemEntity>? items,
    MaintenancePaginationMetaEntity? meta,
    MaintenanceStatsEntity? stats,
    String? activeStatus,
    bool? isFetchingMore,
  }) {
    return OwnerMaintenanceLoaded(
      items: items ?? this.items,
      meta: meta ?? this.meta,
      stats: stats ?? this.stats,
      activeStatus: activeStatus ?? this.activeStatus,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [items, meta, stats, activeStatus, isFetchingMore];
}

class OwnerMaintenanceEmpty extends OwnerMaintenanceState {
  final String activeStatus;
  final MaintenanceStatsEntity? stats;

  const OwnerMaintenanceEmpty({
    this.activeStatus = 'all',
    this.stats,
  });

  @override
  List<Object?> get props => [activeStatus, stats];
}

class OwnerMaintenanceError extends OwnerMaintenanceState {
  final String message;
  final String activeStatus;

  const OwnerMaintenanceError(this.message, {this.activeStatus = 'all'});

  @override
  List<Object?> get props => [message, activeStatus];
}
