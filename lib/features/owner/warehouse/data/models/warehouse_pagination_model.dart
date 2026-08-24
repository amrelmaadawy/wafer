import '../../domain/entities/warehouse_pagination_entity.dart';

class WarehousePaginationModel extends WarehousePaginationEntity {
  const WarehousePaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.from,
    required super.to,
  });

  factory WarehousePaginationModel.fromJson(Map<String, dynamic> json) {
    return WarehousePaginationModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
    );
  }
}
