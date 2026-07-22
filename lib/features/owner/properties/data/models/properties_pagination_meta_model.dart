import '../../domain/entities/properties_pagination_meta_entity.dart';

class PropertiesPaginationMetaModel extends PropertiesPaginationMetaEntity {
  const PropertiesPaginationMetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory PropertiesPaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PropertiesPaginationMetaModel(
      currentPage: json['current_page'] as int? ?? json['currentPage'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? json['lastPage'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? json['perPage'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
    );
  }
}
