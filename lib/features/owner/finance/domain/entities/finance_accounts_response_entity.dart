import 'package:equatable/equatable.dart';
import 'finance_account_entity.dart';

class FinanceAccountsResponseEntity extends Equatable {
  final List<FinanceAccountEntity> accounts;
  final FinancePaginationEntity pagination;

  const FinanceAccountsResponseEntity({
    required this.accounts,
    required this.pagination,
  });

  @override
  List<Object?> get props => [accounts, pagination];
}

class FinancePaginationEntity extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  const FinancePaginationEntity({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [
        currentPage,
        lastPage,
        perPage,
        total,
        from,
        to,
      ];
}
