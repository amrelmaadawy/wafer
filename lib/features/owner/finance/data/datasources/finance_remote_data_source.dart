import 'dart:convert';
import '../../../../../core/network/api_constants.dart';
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

import '../models/unified_transaction_model.dart';
import '../models/receivable_model.dart';
import '../models/payable_model.dart';
import '../../domain/entities/unified_transaction_entity.dart';

abstract class FinanceRemoteDataSource {
  Future<FinanceOverviewModel> getFinanceOverview();
  Future<FinanceFormDataModel> getFinanceFormData();
  
  Future<FinanceAccountsResponseModel> getAccounts(Map<String, dynamic> queryParams);

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
    int? propertyId,
    int? unitId,
    int? contractId,
  });

  Future<PaymentModel> createPayment(Map<String, dynamic> body);
  
  Future<PaymentModel> updatePayment(int paymentId, Map<String, dynamic> body);
  Future<PaymentModel> getFinancePaymentDetails(int paymentId);
  Future<void> cancelFinancePayment(int paymentId, String reason);
  
  Future<ReceiptModel> createReceipt(Map<String, dynamic> body);
  
  Future<ReceiptModel> updateReceipt(int receiptId, Map<String, dynamic> body);

  Future<ReceiptModel> getReceiptDetails(int receiptId);
  Future<ReceiptModel> cancelReceipt(int receiptId, String reason);

  Future<List<UnifiedTransactionModel>> getUnifiedTransactions(Map<String, dynamic> queryParams);
  Future<List<ReceivableModel>> getReceivables(Map<String, dynamic> queryParams);
  Future<List<PayableModel>> getPayables(Map<String, dynamic> queryParams);
}

class FinanceRemoteDataSourceImpl implements FinanceRemoteDataSource {
  final Dio dio;

  FinanceRemoteDataSourceImpl(this.dio);

  ServerException _handleDioException(DioException e, String defaultMessage) {
    if (e.response?.statusCode == 422) {
      final data = e.response?.data;
      if (data != null && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        if (errors.isNotEmpty) {
          final firstErrorKey = errors.keys.first;
          final firstErrorList = errors[firstErrorKey];
          if (firstErrorList is List && firstErrorList.isNotEmpty) {
            return ServerException(firstErrorList.first.toString());
          }
        }
      }
    }
    return ServerException(
      e.response?.data['message'] ?? defaultMessage,
    );
  }

  @override
  Future<FinanceOverviewModel> getFinanceOverview() async {
    try {
      final response = await dio.get(ApiConstants.ownerAccounting);
      final data = response.data['data'] as Map<String, dynamic>;
      return FinanceOverviewModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get finance overview');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<FinanceFormDataModel> getFinanceFormData() async {
    try {
      final response = await dio.get(ApiConstants.ownerAccountingFormData);
      final data = response.data['data'] as Map<String, dynamic>;
      return FinanceFormDataModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get finance form data');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<FinanceAccountsResponseModel> getAccounts(Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        ApiConstants.ownerAccountingAccounts,
        queryParameters: queryParams,
      );
      return FinanceAccountsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get finance accounts');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<FinanceAccountModel> createAccount(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        ApiConstants.ownerAccountingAccounts,
        data: body,
      );
      return FinanceAccountModel.fromJson(response.data['data']['account']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to create finance account');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<FinanceAccountModel> updateAccount(int id, Map<String, dynamic> body) async {
    try {
      final response = await dio.patch(
        ApiConstants.ownerAccountingAccountDetails(id),
        data: body,
      );
      return FinanceAccountModel.fromJson(response.data['data']['account']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to update finance account');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<FinanceAccountModel> getAccountDetails(int id) async {
    try {
      final response = await dio.get(ApiConstants.ownerAccountingAccountDetails(id));
      return FinanceAccountModel.fromJson(response.data['data']['account']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get account details');
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
        ApiConstants.ownerAccountingReceipts,
        queryParameters: queryParameters,
      );

      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      return ReceiptsResponseModel.fromJson(responseData);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get receipts');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  @override
  Future<ReceiptModel> createReceipt(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        ApiConstants.ownerAccountingReceipts,
        data: body,
      );
      return ReceiptModel.fromJson(response.data['data']['receipt']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to create receipt');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaymentsResponseModel> getPayments({
    int page = 1,
    int perPage = 15,
    String? search,
    int? propertyId,
    int? unitId,
    int? contractId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        ...?propertyId == null ? null : {'property_id': propertyId},
        ...?unitId == null ? null : {'unit_id': unitId},
        ...?contractId == null ? null : {'contract_id': contractId},
      };

      final response = await dio.get(
        ApiConstants.ownerAccountingPayments,
        queryParameters: queryParameters,
      );
      return PaymentsResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get payments');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaymentModel> createPayment(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        ApiConstants.ownerAccountingPayments,
        data: body,
      );
      return PaymentModel.fromJson(response.data['data']['payment']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Validation failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaymentModel> updatePayment(int paymentId, Map<String, dynamic> body) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.ownerAccountingPayments}/$paymentId',
        data: body,
      );
      return PaymentModel.fromJson(response.data['data']['payment']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Validation failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<PaymentModel> getFinancePaymentDetails(int paymentId) async {
    try {
      final response = await dio.get('${ApiConstants.ownerAccountingPayments}/$paymentId');
      return PaymentModel.fromJson(response.data['data']['payment']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get payment details');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> cancelFinancePayment(int paymentId, String reason) async {
    try {
      await dio.post(
        '${ApiConstants.ownerAccountingPayments}/$paymentId/action',
        data: {
          'action': 'cancel',
          'reason': reason,
        },
      );
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to cancel payment');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReceiptModel> updateReceipt(int receiptId, Map<String, dynamic> body) async {
    try {
      final response = await dio.patch(
        '${ApiConstants.ownerAccountingReceipts}/$receiptId',
        data: body,
      );
      return ReceiptModel.fromJson(response.data['data']['receipt']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Validation failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReceiptModel> getReceiptDetails(int receiptId) async {
    try {
      final response = await dio.get('${ApiConstants.ownerAccountingReceipts}/$receiptId');
      return ReceiptModel.fromJson(response.data['data']['receipt']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get receipt details');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReceiptModel> cancelReceipt(int receiptId, String reason) async {
    try {
      final response = await dio.post(
        '${ApiConstants.ownerAccountingReceipts}/$receiptId/action',
        data: {
          "action": "cancel",
          "reason": reason,
        },
      );
      return ReceiptModel.fromJson(response.data['data']['receipt']);
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to cancel receipt');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UnifiedTransactionModel>> getUnifiedTransactions(
    Map<String, dynamic> queryParams,
  ) async {
    try {
      final response = await dio.get(
        ApiConstants.ownerAccountingTransactions,
        queryParameters: queryParams,
      );
      final dynamic rawData = response.data['data'];
      List list = [];
      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map && rawData['transactions'] is List) {
        list = rawData['transactions'];
      } else if (rawData is Map && rawData['data'] is List) {
        list = rawData['data'];
      }
      return list.map((item) => UnifiedTransactionModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
        // Graceful aggregation fallback from receipts and payments
        return _fallbackUnifiedTransactions(queryParams);
      }
      throw _handleDioException(e, 'Failed to fetch transactions');
    } catch (e) {
      return _fallbackUnifiedTransactions(queryParams);
    }
  }

  Future<List<UnifiedTransactionModel>> _fallbackUnifiedTransactions(
    Map<String, dynamic> queryParams,
  ) async {
    try {
      final results = <UnifiedTransactionModel>[];
      final page = queryParams['page'] ?? 1;
      final perPage = queryParams['per_page'] ?? 15;
      final type = queryParams['type']?.toString().toLowerCase();

      if (type == null || type == 'all' || type == 'receipt') {
        try {
          final receiptsRes = await getReceipts(page: page is int ? page : int.tryParse(page.toString()) ?? 1, perPage: perPage is int ? perPage : 15);
          for (final r in receiptsRes.receipts) {
            results.add(UnifiedTransactionModel(
              id: r.id,
              referenceNumber: r.receiptNumber,
              type: UnifiedTransactionType.receipt,
              date: r.receiptDate,
              amount: r.amount,
              isPositive: true,
              status: r.status,
              partyName: r.owner.name,
              notes: r.notes,
            ));
          }
        } catch (_) {}
      }

      if (type == null || type == 'all' || type == 'payment') {
        try {
          final paymentsRes = await getPayments(page: page is int ? page : int.tryParse(page.toString()) ?? 1, perPage: perPage is int ? perPage : 15);
          for (final p in paymentsRes.payments) {
            results.add(UnifiedTransactionModel(
              id: p.id,
              referenceNumber: p.paymentNumber,
              type: UnifiedTransactionType.payment,
              date: p.paymentDate,
              amount: p.amount,
              isPositive: false,
              propertyName: p.propertyName,
              unitName: p.unitName,
              contractNumber: p.contractNumber,
              status: p.status,
              partyName: p.payee.name,
              notes: p.notes,
            ));
          }
        } catch (_) {}
      }

      results.sort((a, b) => b.date.compareTo(a.date));
      return results;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ReceivableModel>> getReceivables(Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        ApiConstants.ownerAccountingReceivables,
        queryParameters: queryParams,
      );
      final dynamic rawData = response.data['data'];
      List list = [];
      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map && rawData['receivables'] is List) {
        list = rawData['receivables'];
      } else if (rawData is Map && rawData['data'] is List) {
        list = rawData['data'];
      }
      return list.map((item) => ReceivableModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
        return [];
      }
      throw _handleDioException(e, 'Failed to fetch receivables');
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<PayableModel>> getPayables(Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        ApiConstants.ownerAccountingPayables,
        queryParameters: queryParams,
      );
      final dynamic rawData = response.data['data'];
      List list = [];
      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map && rawData['payables'] is List) {
        list = rawData['payables'];
      } else if (rawData is Map && rawData['data'] is List) {
        list = rawData['data'];
      }
      return list.map((item) => PayableModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
        return [];
      }
      throw _handleDioException(e, 'Failed to fetch payables');
    } catch (_) {
      return [];
    }
  }
}
