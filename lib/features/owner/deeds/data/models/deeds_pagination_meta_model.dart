import '../../domain/entities/deeds_pagination_meta_entity.dart';

class DeedsPaginationMetaModel extends DeedsPaginationMetaEntity {
  const DeedsPaginationMetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.from,
    required super.to,
  });

  factory DeedsPaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return DeedsPaginationMetaModel(
      currentPage: json['current_page'] is int ? json['current_page'] as int : int.tryParse(json['current_page'].toString()) ?? 1,
      lastPage: json['last_page'] is int ? json['last_page'] as int : int.tryParse(json['last_page'].toString()) ?? 1,
      perPage: json['per_page'] is int ? json['per_page'] as int : int.tryParse(json['per_page'].toString()) ?? 20,
      total: json['total'] is int ? json['total'] as int : int.tryParse(json['total'].toString()) ?? 0,
      from: json['from'] is int ? json['from'] as int : int.tryParse(json['from'].toString()) ?? 0,
      to: json['to'] is int ? json['to'] as int : int.tryParse(json['to'].toString()) ?? 0,
    );
  }
}
