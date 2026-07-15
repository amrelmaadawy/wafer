import 'package:equatable/equatable.dart';
import 'maintenance_item_entity.dart';
import 'maintenance_pagination_meta_entity.dart';

class MaintenanceResponseEntity extends Equatable {
  final List<MaintenanceItemEntity> items;
  final MaintenancePaginationMetaEntity meta;

  const MaintenanceResponseEntity({
    required this.items,
    required this.meta,
  });

  @override
  List<Object?> get props => [items, meta];
}
