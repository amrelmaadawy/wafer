import '../../domain/entities/contracts_response_entity.dart';
import 'contract_item_model.dart';
import 'contracts_pagination_meta_model.dart';

class ContractsResponseModel extends ContractsResponseEntity {
  const ContractsResponseModel({
    required super.contracts,
    required super.meta,
  });

  factory ContractsResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> contractsMap = {};

    if (json['data'] is Map<String, dynamic>) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap['contracts'] is Map<String, dynamic>) {
        contractsMap = dataMap['contracts'] as Map<String, dynamic>;
      } else {
        contractsMap = dataMap;
      }
    } else if (json['contracts'] is Map<String, dynamic>) {
      contractsMap = json['contracts'] as Map<String, dynamic>;
    } else {
      contractsMap = json;
    }

    final rawList = contractsMap['data'] as List<dynamic>? ?? [];
    final contractsList = rawList
        .whereType<Map<String, dynamic>>()
        .map((item) => ContractItemModel.fromJson(item))
        .toList();

    final metaMap = contractsMap['meta'] as Map<String, dynamic>? ?? {};
    final meta = ContractsPaginationMetaModel.fromJson(metaMap);

    return ContractsResponseModel(
      contracts: contractsList,
      meta: meta,
    );
  }
}
