import 'package:dio/dio.dart';
import '../models/finance_accounts_response_model.dart';
import '../models/finance_overview_model.dart';

abstract class FinanceRemoteDataSource {
  Future<FinanceOverviewModel> getFinanceOverview();
  
  Future<FinanceAccountsResponseModel> getAccounts({
    int page = 1,
    int perPage = 15,
    String? search,
    String? accountType,
    bool? isActive,
    bool? isPostable,
  });
}

class FinanceRemoteDataSourceImpl implements FinanceRemoteDataSource {
  final Dio dio;

  FinanceRemoteDataSourceImpl(this.dio);

  @override
  Future<FinanceOverviewModel> getFinanceOverview() async {
    final response = await dio.get('owner/accounting');
    final data = response.data['data'] as Map<String, dynamic>;
    return FinanceOverviewModel.fromJson(data);
  }

  @override
  Future<FinanceAccountsResponseModel> getAccounts({
    int page = 1,
    int perPage = 15,
    String? search,
    String? accountType,
    bool? isActive,
    bool? isPostable,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
      if (accountType != null && accountType.isNotEmpty) 'account_type': accountType,
      'is_active': ?isActive,
      'is_postable': ?isPostable,
    };

    final response = await dio.get(
      'owner/accounting/accounts',
      queryParameters: queryParameters,
    );
    return FinanceAccountsResponseModel.fromJson(response.data);
  }
}
