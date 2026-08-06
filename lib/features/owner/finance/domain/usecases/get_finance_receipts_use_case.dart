import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/receipts_response_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinanceReceiptsUseCase
    implements UseCase<ReceiptsResponseEntity, GetFinanceReceiptsParams> {
  final FinanceRepository repository;

  GetFinanceReceiptsUseCase(this.repository);

  @override
  Future<Either<Failure, ReceiptsResponseEntity>> call(
    GetFinanceReceiptsParams params,
  ) async {
    return await repository.getReceipts(
      page: params.page,
      perPage: params.perPage,
      search: params.search,
    );
  }
}

class GetFinanceReceiptsParams extends Equatable {
  final int page;
  final int perPage;
  final String? search;

  const GetFinanceReceiptsParams({
    required this.page,
    required this.perPage,
    this.search,
  });

  @override
  List<Object?> get props => [page, perPage, search];
}
