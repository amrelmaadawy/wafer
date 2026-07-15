import '../../domain/entities/maintenance_response_entity.dart';
import 'maintenance_item_model.dart';
import 'maintenance_pagination_meta_model.dart';

class MaintenanceResponseModel extends MaintenanceResponseEntity {
  const MaintenanceResponseModel({
    required super.items,
    required super.meta,
  });

  factory MaintenanceResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> requestsMap = {};

    if (json['data'] is Map<String, dynamic>) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap['maintenance_requests'] is Map<String, dynamic>) {
        requestsMap = dataMap['maintenance_requests'] as Map<String, dynamic>;
      } else {
        requestsMap = dataMap;
      }
    } else if (json['maintenance_requests'] is Map<String, dynamic>) {
      requestsMap = json['maintenance_requests'] as Map<String, dynamic>;
    } else {
      requestsMap = json;
    }

    final rawList = requestsMap['data'] as List<dynamic>? ?? [];
    final itemsList = rawList
        .whereType<Map<String, dynamic>>()
        .map((item) => MaintenanceItemModel.fromJson(item))
        .toList();

    final metaMap = requestsMap['meta'] as Map<String, dynamic>? ?? {};
    final meta = MaintenancePaginationMetaModel.fromJson(metaMap);

    return MaintenanceResponseModel(
      items: itemsList,
      meta: meta,
    );
  }
}
