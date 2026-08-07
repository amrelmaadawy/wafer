import 'package:dartz/dartz.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';
import '../../../../../core/data/base_repository.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';

import '../../domain/entities/finance_account_entity.dart';
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
  Future<Either<Failure, FinanceAccountsResponseEntity>> getAccounts({
    int page = 1,
    int perPage = 15,
    String? search,
    String? accountType,
    bool? isActive,
    bool? isPostable,
  }) async {
    return executeApiCall<FinanceAccountsResponseEntity>(
      call: () => remoteDataSource.getAccounts(
        page: page,
        perPage: perPage,
        search: search,
        accountType: accountType,
        isActive: isActive,
        isPostable: isPostable,
      ),
    );
  }

  @override
  Future<Either<Failure, FinanceAccountEntity>> createAccount(
    CreateFinanceAccountParams params,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final accountModel = await remoteDataSource.createAccount(params.toJson());
      return Right(accountModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FinanceAccountEntity>> updateAccount(
    UpdateFinanceAccountParams params,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final accountModel = await remoteDataSource.updateAccount(params.id, params.toJson());
      return Right(accountModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FinanceAccountEntity>> getAccountDetails(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final accountModel = await remoteDataSource.getAccountDetails(id);
      return Right(accountModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ReceiptsResponseEntity>> getReceipts({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await remoteDataSource.getReceipts(
        page: page,
        perPage: perPage,
        search: search,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReceiptEntity>> updateReceipt(UpdateFinanceReceiptParams params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final body = {
        'amount': params.amount,
        'receipt_date': params.receiptDate,
        if (params.notes != null && params.notes!.isNotEmpty) 'notes': params.notes,
      };

      final receiptModel = await remoteDataSource.updateReceipt(params.receiptId, body);
      return Right(receiptModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReceiptEntity>> getReceiptDetails(int receiptId) async {
    if (await networkInfo.isConnected) {
      try {
        final receipt = await remoteDataSource.getReceiptDetails(receiptId);
        return Right(receipt);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> createPayment(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createPayment(params);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> updatePayment(int paymentId, Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updatePayment(paymentId, params);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ReceiptEntity>> cancelReceipt(int receiptId, String reason) async {
    if (await networkInfo.isConnected) {
      try {
        final receipt = await remoteDataSource.cancelReceipt(receiptId, reason);
        return Right(receipt);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PaymentsResponseEntity>> getPayments({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePayments = await remoteDataSource.getPayments(
          page: page,
          perPage: perPage,
          search: search,
        );
        return Right(remotePayments);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}
