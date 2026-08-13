import '../../domain/entities/finance_form_data_entity.dart';
import 'finance_account_model.dart';

class FinanceFormDataModel extends FinanceFormDataEntity {
  const FinanceFormDataModel({
    required super.accounts,
    required super.paymentMethods,
    required super.properties,
    required super.contracts,
    required super.users,
  });

  factory FinanceFormDataModel.fromJson(Map<String, dynamic> json) {
    final options = json['options'] as Map<String, dynamic>? ?? json;
    
    return FinanceFormDataModel(
      accounts: (options['accounts'] as List<dynamic>?)
              ?.map((e) => FinanceAccountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      paymentMethods: (options['payment_methods'] as List<dynamic>?)
              ?.map((e) => DropdownOptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      properties: (options['properties'] as List<dynamic>?)
              ?.map((e) => DropdownOptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      contracts: (options['contracts'] as List<dynamic>?)
              ?.map((e) => DropdownOptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      users: (options['users'] as List<dynamic>?)
              ?.map((e) => DropdownOptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DropdownOptionModel extends DropdownOptionEntity {
  const DropdownOptionModel({
    required super.value,
    required super.label,
  });

  factory DropdownOptionModel.fromJson(Map<String, dynamic> json) {
    // Some dropdowns might return 'id' instead of 'value', and 'name' instead of 'label'
    return DropdownOptionModel(
      value: json['value']?.toString() ?? json['id']?.toString() ?? json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? json['name']?.toString() ?? json['contract_number']?.toString() ?? '',
    );
  }
}
