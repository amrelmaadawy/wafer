import '../../domain/entities/maintenance_pagination_meta_entity.dart';

class MaintenancePaginationMetaModel extends MaintenancePaginationMetaEntity {
  const MaintenancePaginationMetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory MaintenancePaginationMetaModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MaintenancePaginationMetaModel(
        currentPage: 1,
        lastPage: 1,
        perPage: 15,
        total: 0,
      );
    }
    return MaintenancePaginationMetaModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 15,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}
