import 'package:dartz/dartz.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';
import '../../../../../core/data/base_repository.dart';
import '../../../../../core/error/failures.dart';

import '../../domain/entities/finance_account_entity.dart';
import '../../domain/entities/finance_accounts_query_entity.dart';
import '../../domain/entities/finance_accounts_response_entity.dart';
import '../../domain/entities/finance_overview_entity.dart';
import '../../domain/entities/finance_form_data_entity.dart';
import '../../domain/entities/payments_response_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../../domain/usecases/create_finance_account_use_case.dart';
import '../../domain/usecases/update_finance_account_use_case.dart';
import '../../domain/usecases/update_finance_receipt_use_case.dart';
import '../datasources/finance_remote_data_source.dart';
import '../../domain/entities/receipts_response_entity.dart';
import '../../domain/entities/receipt_entity.dart';
import '../../domain/usecases/create_finance_receipt_use_case.dart';

class FinanceRepositoryImpl extends BaseRepository
    implements FinanceRepository {
  final FinanceRemoteDataSource remoteDataSource;

  FinanceRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, FinanceOverviewEntity>> getFinanceOverview() async {
    return executeApiCall<FinanceOverviewEntity>(
      call: () => remoteDataSource.getFinanceOverview(),
    );
  }

  @override
  Future<Either<Failure, FinanceFormDataEntity>> getFinanceFormData() async {
    return executeApiCall<FinanceFormDataEntity>(
      call: () => remoteDataSource.getFinanceFormData(),
    );
  }

  @override
  Future<Either<Failure, ReceiptEntity>> createReceipt(
    CreateFinanceReceiptParams params,
  ) async {
    return executeApiCall<ReceiptEntity>(
      call: () => remoteDataSource.createReceipt(params.toJson()),
    );
  }

  @override
  Future<Either<Failure, FinanceAccountsResponseEntity>> getAccounts(
    FinanceAccountsQueryEntity query,
  ) async {
    return executeApiCall<FinanceAccountsResponseEntity>(
      call: () => remoteDataSource.getAccounts(query.toQueryParams()),
    );
  }

  @override
  Future<Either<Failure, FinanceAccountEntity>> createAccount(
    CreateFinanceAccountParams params,
  ) async {
    return executeApiCall<FinanceAccountEntity>(
      call: () => remoteDataSource.createAccount(params.toJson()),
    );
  }

  @override
  Future<Either<Failure, FinanceAccountEntity>> updateAccount(
    UpdateFinanceAccountParams params,
  ) async {
    return executeApiCall<FinanceAccountEntity>(
      call: () => remoteDataSource.updateAccount(params.id, params.toJson()),
    );
  }

  @override
  Future<Either<Failure, FinanceAccountEntity>> getAccountDetails(int id) async {
    return executeApiCall<FinanceAccountEntity>(
      call: () => remoteDataSource.getAccountDetails(id),
    );
  }

  @override
  Future<Either<Failure, ReceiptsResponseEntity>> getReceipts({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    return executeApiCall<ReceiptsResponseEntity>(
      call: () => remoteDataSource.getReceipts(
        page: page,
        perPage: perPage,
        search: search,
      ),
    );
  }

  @override
  Future<Either<Failure, ReceiptEntity>> updateReceipt(UpdateFinanceReceiptParams params) async {
    final body = {
      'amount': params.amount,
      'receipt_date': params.receiptDate,
      if (params.notes != null && params.notes!.isNotEmpty) 'notes': params.notes,
    };
    return executeApiCall<ReceiptEntity>(
      call: () => remoteDataSource.updateReceipt(params.receiptId, body),
    );
  }

  @override
  Future<Either<Failure, ReceiptEntity>> getReceiptDetails(int receiptId) async {
    return executeApiCall<ReceiptEntity>(
      call: () => remoteDataSource.getReceiptDetails(receiptId),
    );
  }

  @override
  Future<Either<Failure, PaymentEntity>> createPayment(Map<String, dynamic> params) async {
    return executeApiCall<PaymentEntity>(
      call: () => remoteDataSource.createPayment(params),
    );
  }

  @override
  Future<Either<Failure, PaymentEntity>> updatePayment(
      int paymentId, Map<String, dynamic> params) async {
    return executeApiCall<PaymentEntity>(
      call: () => remoteDataSource.updatePayment(paymentId, params),
    );
  }

  @override
  Future<Either<Failure, PaymentEntity>> getFinancePaymentDetails(int paymentId) async {
    return executeApiCall<PaymentEntity>(
      call: () => remoteDataSource.getFinancePaymentDetails(paymentId),
    );
  }

  @override
  Future<Either<Failure, void>> cancelFinancePayment(int paymentId, String reason) async {
    return executeApiCall<void>(
      call: () => remoteDataSource.cancelFinancePayment(paymentId, reason),
    );
  }

  @override
  Future<Either<Failure, ReceiptEntity>> cancelReceipt(int receiptId, String reason) async {
    return executeApiCall<ReceiptEntity>(
      call: () => remoteDataSource.cancelReceipt(receiptId, reason),
    );
  }

  @override
  Future<Either<Failure, PaymentsResponseEntity>> getPayments({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    return executeApiCall<PaymentsResponseEntity>(
      call: () => remoteDataSource.getPayments(
        page: page,
        perPage: perPage,
        search: search,
      ),
    );
  }
}