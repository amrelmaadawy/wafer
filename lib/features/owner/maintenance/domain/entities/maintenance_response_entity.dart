import 'package:equatable/equatable.dart';
import 'maintenance_item_entity.dart';
import 'maintenance_pagination_meta_entity.dart';
import 'maintenance_sub_entities.dart';

class MaintenanceResponseEntity extends Equatable {
  final List<MaintenanceItemEntity> items;
  final MaintenancePaginationMetaEntity meta;
  final MaintenanceStatsEntity? stats;

  const MaintenanceResponseEntity({
    required this.items,
    required this.meta,
    this.stats,
  });

  @override
  List<Object?> get props => [items, meta, stats];
}
