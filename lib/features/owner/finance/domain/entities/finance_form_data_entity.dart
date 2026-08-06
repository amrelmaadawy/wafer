import 'finance_account_entity.dart';

class FinanceFormDataEntity {
  final List<FinanceAccountEntity> accounts;
  final List<DropdownOptionEntity> paymentMethods;
  final List<DropdownOptionEntity> properties;
  final List<DropdownOptionEntity> contracts;

  const FinanceFormDataEntity({
    required this.accounts,
    required this.paymentMethods,
    required this.properties,
    required this.contracts,
  });
}

class DropdownOptionEntity {
  final String value;
  final String label;

  const DropdownOptionEntity({
    required this.value,
    required this.label,
  });
}
