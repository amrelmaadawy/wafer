import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../models/finance_account_model.dart';
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

  Future<FinanceAccountModel> createAccount(Map<String, dynamic> body);

  Future<FinanceAccountModel> updateAccount(int id, Map<String, dynamic> body);
}

class FinanceRemoteDataSourceImpl implements FinanceRemoteDataSource {
  final Dio dio;

  FinanceRemoteDataSourceImpl(this.dio);

  @override
  Future<FinanceOverviewModel> getFinanceOverview() async {
    try {
      final response = await dio.get('owner/accounting');
      final data = response.data['data'] as Map<String, dynamic>;
      return FinanceOverviewModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get finance overview',
      );
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
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
      if (isActive != null) 'is_active': isActive,
      if (isPostable != null) 'is_postable': isPostable,
    };

    try {
      final response = await dio.get(
        'owner/accounting/accounts',
        queryParameters: queryParameters,
      );
      return FinanceAccountsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get finance accounts',
      );
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<FinanceAccountModel> createAccount(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        'owner/accounting/accounts',
        data: body,
      );
      return FinanceAccountModel.fromJson(response.data['data']['account']);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to create finance account',
      );
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<FinanceAccountModel> updateAccount(int id, Map<String, dynamic> body) async {
    try {
      final response = await dio.patch(
        'owner/accounting/accounts/$id',
        data: body,
      );
      return FinanceAccountModel.fromJson(response.data['data']['account']);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to update finance account',
      );
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }
}
