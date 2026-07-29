import '../../domain/entities/maintenance_response_entity.dart';
import 'maintenance_item_model.dart';
import 'maintenance_pagination_meta_model.dart';
import 'maintenance_sub_models.dart';

class MaintenanceResponseModel extends MaintenanceResponseEntity {
  const MaintenanceResponseModel({
    required super.items,
    required super.meta,
    super.stats,
  });

  factory MaintenanceResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dataMap = {};

    if (json['data'] is Map<String, dynamic>) {
      dataMap = json['data'] as Map<String, dynamic>;
    } else {
      dataMap = json;
    }

    final rawList = dataMap['maintenance_requests'] as List<dynamic>? ?? [];
    final itemsList = rawList
        .whereType<Map<String, dynamic>>()
        .map((item) => MaintenanceItemModel.fromJson(item))
        .toList();

    final metaMap = dataMap['pagination'] as Map<String, dynamic>? ?? {};
    final meta = MaintenancePaginationMetaModel.fromJson(metaMap);

    final statsMap = dataMap['stats'] as Map<String, dynamic>? ?? {};
    final stats = MaintenanceStatsModel.fromJson(statsMap);

    return MaintenanceResponseModel(
      items: itemsList,
      meta: meta,
      stats: stats,
    );
  }
}
