import 'finance_account_entity.dart';

class FinanceFormDataEntity {
  final List<FinanceAccountEntity> accounts;
  final List<DropdownOptionEntity> paymentMethods;
  final List<DropdownOptionEntity> properties;
  final List<DropdownOptionEntity> contracts;
  final List<DropdownOptionEntity> users;

  const FinanceFormDataEntity({
    required this.accounts,
    required this.paymentMethods,
    required this.properties,
    required this.contracts,
    required this.users,
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
