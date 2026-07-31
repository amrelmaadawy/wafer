import '../../domain/entities/negotiation_pagination_entity.dart';

class NegotiationPaginationModel extends NegotiationPaginationEntity {
  const NegotiationPaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.from,
    required super.to,
  });

  factory NegotiationPaginationModel.fromJson(Map<String, dynamic> json) {
    return NegotiationPaginationModel(
      currentPage: json['current_page'] is int ? json['current_page'] : int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      lastPage: json['last_page'] is int ? json['last_page'] : int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
      perPage: json['per_page'] is int ? json['per_page'] : int.tryParse(json['per_page']?.toString() ?? '15') ?? 15,
      total: json['total'] is int ? json['total'] : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      from: json['from'] is int ? json['from'] : int.tryParse(json['from']?.toString() ?? '0') ?? 0,
      to: json['to'] is int ? json['to'] : int.tryParse(json['to']?.toString() ?? '0') ?? 0,
    );
  }
}
