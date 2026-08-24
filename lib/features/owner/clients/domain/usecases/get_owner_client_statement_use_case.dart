import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/client_statement_response_entity.dart';
import '../repositories/owner_clients_repository.dart';

class GetOwnerClientStatementParams {
  final int clientId;
  final String? startDate;
  final String? endDate;
  final String? transactionType;

  const GetOwnerClientStatementParams({
    required this.clientId,
    this.startDate,
    this.endDate,
    this.transactionType,
  });
}

class GetOwnerClientStatementUseCase {
  final OwnerClientsRepository repository;

  GetOwnerClientStatementUseCase(this.repository);

  Future<Either<Failure, ClientStatementResponseEntity>> call(
    GetOwnerClientStatementParams params,
  ) async {
    return await repository.getClientStatement(
      clientId: params.clientId,
      startDate: params.startDate,
      endDate: params.endDate,
      transactionType: params.transactionType,
    );
  }
}
