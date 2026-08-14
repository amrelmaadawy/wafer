import 'package:equatable/equatable.dart';

class FinanceAccountsQueryEntity extends Equatable {
  final int page;
  final int perPage;
  final String? search;
  final String? accountType;
  final bool? isActive;
  final bool? isPostable;

  const FinanceAccountsQueryEntity({
    this.page = 1,
    this.perPage = 15,
    this.search,
    this.accountType,
    this.isActive,
    this.isPostable,
  })  : assert(page > 0, 'Page must be greater than 0'),
        assert(perPage > 0, 'PerPage must be greater than 0');

  FinanceAccountsQueryEntity copyWith({
    int? page,
    int? perPage,
    String? search,
    String? accountType,
    bool? isActive,
    bool? isPostable,
  }) {
    return FinanceAccountsQueryEntity(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      accountType: accountType ?? this.accountType,
      isActive: isActive ?? this.isActive,
      isPostable: isPostable ?? this.isPostable,
    );
  }

  Map<String, dynamic> toQueryParams() {
    return {
      'page': page,
      'per_page': perPage,
      if (search != null && search!.trim().isNotEmpty) 'search': search!.trim(),
      if (accountType != null && accountType!.isNotEmpty)
        'account_type': accountType,
      if (isActive != null) 'is_active': isActive,
      if (isPostable != null) 'is_postable': isPostable,
    };
  }

  @override
  List<Object?> get props => [
        page,
        perPage,
        search,
        accountType,
        isActive,
        isPostable,
      ];
}
