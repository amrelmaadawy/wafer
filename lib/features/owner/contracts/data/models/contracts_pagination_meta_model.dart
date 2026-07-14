import '../../domain/entities/contracts_pagination_meta_entity.dart';

class ContractsPaginationMetaModel extends ContractsPaginationMetaEntity {
  const ContractsPaginationMetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory ContractsPaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return ContractsPaginationMetaModel(
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
