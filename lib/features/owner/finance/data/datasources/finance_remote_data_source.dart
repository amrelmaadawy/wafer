import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:wafer/features/owner/finance/data/models/payment_model.dart';
import '../../../../../core/error/exceptions.dart';
import '../models/finance_account_model.dart';
import '../models/finance_accounts_response_model.dart';
import '../models/finance_overview_model.dart';
import '../models/payments_response_model.dart';
import '../models/receipts_response_model.dart';
import '../models/receipt_model.dart';
import '../models/finance_form_data_model.dart';

abstract class FinanceRemoteDataSource {
  Future<FinanceOverviewModel> getFinanceOverview();
  Future<FinanceFormDataModel> getFinanceFormData();
  
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

  Future<FinanceAccountModel> getAccountDetails(int id);

  Future<ReceiptsResponseModel> getReceipts({
    int page = 1,
    int perPage = 15,
    String? search,
  });

  Future<PaymentsResponseModel> getPayments({
    int page = 1,
    int perPage = 15,
    String? search,
  });

  Future<PaymentModel> createPayment(Map<String, dynamic> body);
  
  Future<ReceiptModel> createReceipt(Map<String, dynamic> body);
  
  Future<ReceiptModel> updateReceipt(int receiptId, Map<String, dynamic> body);

  Future<ReceiptModel> getReceiptDetails(int receiptId);
  Future<ReceiptModel> cancelReceipt(int receiptId, String reason);
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
  Future<FinanceFormDataModel> getFinanceFormData() async {
    try {
      final response = await dio.get('owner/accounting/form-data');
      final data = response.data['data'] as Map<String, dynamic>;
      return FinanceFormDataModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get finance form data',
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
      'is_active': ?isActive,
      'is_postable': ?isPostable,
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

  @override
  Future<FinanceAccountModel> getAccountDetails(int id) async {
    try {
      final response = await dio.get('owner/accounting/accounts/$id');
      return FinanceAccountModel.fromJson(response.data['data']['account']);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get account details',
      );
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<ReceiptsResponseModel> getReceipts({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await dio.get(
        'owner/accounting/receipts',
        queryParameters: queryParameters,
      );

      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return ReceiptsResponseModel.fromJson(responseData);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get receipts',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  @override
  Future<ReceiptModel> createReceipt(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        'owner/accounting/receipts',
        data: body,
      );
      return ReceiptModel.fromJson(response.data['data']['receipt']);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to create receipt',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaymentsResponseModel> getPayments({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await dio.get(
        'owner/accounting/payments',
        queryParameters: queryParameters,
      );
      return PaymentsResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get payments',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaymentModel> createPayment(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        'owner/accounting/payments',
        data: body,
      );
      return PaymentModel.fromJson(response.data['data']['payment']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
         throw ServerException(
           e.response?.data['message'] ?? 'Validation failed',
         );
      }
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to create payment',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReceiptModel> updateReceipt(int receiptId, Map<String, dynamic> body) async {
    try {
      final response = await dio.patch(
        'owner/accounting/receipts/$receiptId',
        data: body,
      );
      return ReceiptModel.fromJson(response.data['data']['receipt']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data != null && data['errors'] is Map) {
          final errors = data['errors'] as Map;
          if (errors.isNotEmpty) {
            final firstErrorKey = errors.keys.first;
            final firstErrorList = errors[firstErrorKey];
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              throw ServerException(firstErrorList.first.toString());
            }
          }
        }
        throw ServerException(
          e.response?.data['message'] ?? 'Validation failed',
        );
      }
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to update receipt',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReceiptModel> getReceiptDetails(int receiptId) async {
    try {
      final response = await dio.get('owner/accounting/receipts/$receiptId');
      return ReceiptModel.fromJson(response.data['data']['receipt']);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to get receipt details',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReceiptModel> cancelReceipt(int receiptId, String reason) async {
    try {
      final response = await dio.post(
        'owner/accounting/receipts/$receiptId/action',
        data: {
          "action": "cancel",
          "reason": reason,
        },
      );
      return ReceiptModel.fromJson(response.data['data']['receipt']);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'Failed to cancel receipt',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
