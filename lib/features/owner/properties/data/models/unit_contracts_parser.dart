import 'contract_model.dart';

ContractModel? parseUnitContract(Object? value) {
  if (value is! Map) return null;
  return ContractModel.fromJson(Map<String, dynamic>.from(value));
}

List<ContractModel> parseUnitContracts(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => ContractModel.fromJson(Map<String, dynamic>.from(item)))
      .toList(growable: false);
}
