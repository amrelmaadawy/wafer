import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/payments_response_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinancePaymentsUseCase
    implements UseCase<PaymentsResponseEntity, GetFinancePaymentsParams> {
  final FinanceRepository repository;

  GetFinancePaymentsUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentsResponseEntity>> call(
      GetFinancePaymentsParams params) async {
    return await repository.getPayments(
      page: params.page,
      perPage: params.perPage,
      search: params.search,
    );
  }
}

class GetFinancePaymentsParams {
  final int page;
  final int perPage;
  final String? search;

  GetFinancePaymentsParams({
    this.page = 1,
    this.perPage = 15,
    this.search,
  });
}
