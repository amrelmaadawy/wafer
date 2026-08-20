import '../../domain/entities/contracts_response_entity.dart';
import 'contract_item_model.dart';
import 'contracts_pagination_meta_model.dart';

class ContractsResponseModel extends ContractsResponseEntity {
  const ContractsResponseModel({required super.contracts, required super.meta});

  factory ContractsResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> rawList = [];
    Map<String, dynamic> metaMap = {};

    if (json['data'] is Map<String, dynamic>) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap['contracts'] is List) {
        rawList = dataMap['contracts'] as List<dynamic>;
      } else if (dataMap['contracts'] is Map && dataMap['contracts']['data'] is List) {
        rawList = dataMap['contracts']['data'] as List<dynamic>;
      }
      
      if (dataMap['pagination'] is Map<String, dynamic>) {
        metaMap = dataMap['pagination'] as Map<String, dynamic>;
      } else if (dataMap['meta'] is Map<String, dynamic>) {
        metaMap = dataMap['meta'] as Map<String, dynamic>;
      }
    } else if (json['contracts'] is List) {
      rawList = json['contracts'] as List<dynamic>;
      metaMap = json['pagination'] as Map<String, dynamic>? ?? json['meta'] as Map<String, dynamic>? ?? {};
    }

    final contractsList = rawList
        .whereType<Map<String, dynamic>>()
        .map((item) => ContractItemModel.fromJson(item))
        .toList();

    final meta = ContractsPaginationMetaModel.fromJson(metaMap);

    return ContractsResponseModel(contracts: contractsList, meta: meta);
  }
}
