import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_account_entity.dart';
import '../entities/finance_accounts_response_entity.dart';
import '../entities/finance_overview_entity.dart';
import '../entities/receipts_response_entity.dart';
import '../entities/receipt_entity.dart';
import '../entities/payment_entity.dart';
import '../entities/payments_response_entity.dart';
import '../entities/finance_form_data_entity.dart';
import '../usecases/create_finance_account_use_case.dart';
import '../usecases/create_finance_receipt_use_case.dart';
import '../usecases/update_finance_account_use_case.dart';
import '../usecases/update_finance_receipt_use_case.dart';

abstract class FinanceRepository {
  Future<Either<Failure, FinanceOverviewEntity>> getFinanceOverview();

  Future<Either<Failure, FinanceFormDataEntity>> getFinanceFormData();

  Future<Either<Failure, FinanceAccountsResponseEntity>> getAccounts({
    int page = 1,
    int perPage = 15,
    String? search,
    String? accountType,
    bool? isActive,
    bool? isPostable,
  });

  Future<Either<Failure, FinanceAccountEntity>> createAccount(
    CreateFinanceAccountParams params,
  );

  Future<Either<Failure, ReceiptEntity>> createReceipt(
    CreateFinanceReceiptParams params,
  );

  Future<Either<Failure, ReceiptEntity>> updateReceipt(
    UpdateFinanceReceiptParams params,
  );

  Future<Either<Failure, ReceiptEntity>> cancelReceipt(int receiptId, String reason);

  Future<Either<Failure, ReceiptEntity>> getReceiptDetails(int receiptId);

  Future<Either<Failure, PaymentEntity>> createPayment(Map<String, dynamic> params);

  Future<Either<Failure, FinanceAccountEntity>> updateAccount(
    UpdateFinanceAccountParams params,
  );

  Future<Either<Failure, FinanceAccountEntity>> getAccountDetails(int id);

  Future<Either<Failure, ReceiptsResponseEntity>> getReceipts({
    int page = 1,
    int perPage = 15,
    String? search,
  });

  Future<Either<Failure, PaymentsResponseEntity>> getPayments({
    int page = 1,
    int perPage = 15,
    String? search,
  });
}
