import '../../domain/entities/clients_pagination_entity.dart';

class ClientsPaginationModel extends ClientsPaginationEntity {
  const ClientsPaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.from,
    required super.to,
  });

  factory ClientsPaginationModel.fromJson(Map<String, dynamic> json) {
    return ClientsPaginationModel(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
      from: json['from'] as int? ?? 0,
      to: json['to'] as int? ?? 0,
    );
  }
}
