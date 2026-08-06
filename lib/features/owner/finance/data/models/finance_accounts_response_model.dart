import '../../domain/entities/finance_accounts_response_entity.dart';
import 'finance_account_model.dart';

class FinanceAccountsResponseModel extends FinanceAccountsResponseEntity {
  const FinanceAccountsResponseModel({
    required super.accounts,
    required super.pagination,
  });

  factory FinanceAccountsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    
    return FinanceAccountsResponseModel(
      accounts: () {
        final accountsData = data['accounts'];
        if (accountsData is List) {
          return accountsData.map((e) => FinanceAccountModel.fromJson(e)).toList();
        } else if (accountsData is Map && accountsData.containsKey('data') && accountsData['data'] is List) {
          return (accountsData['data'] as List).map((e) => FinanceAccountModel.fromJson(e)).toList();
        }
        return <FinanceAccountModel>[];
      }(),
      pagination: FinancePaginationModel.fromJson(
        data['pagination'] ?? (data['accounts'] is Map ? data['accounts'] : {}),
      ),
    );
  }
}

class FinancePaginationModel extends FinancePaginationEntity {
  const FinancePaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.from,
    required super.to,
  });

  factory FinancePaginationModel.fromJson(Map<String, dynamic> json) {
    return FinancePaginationModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
    );
  }
}
