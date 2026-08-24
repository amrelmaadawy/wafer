import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/clients_list_response_entity.dart';
import '../entities/client_entity.dart';
import '../entities/client_statement_response_entity.dart';

abstract class OwnerClientsRepository {
  Future<Either<Failure, ClientsListResponseEntity>> getClients({
    int page = 1,
    Map<String, dynamic>? filters,
  });

  Future<Either<Failure, ClientEntity>> updateClient({
    required int clientId,
    required Map<String, dynamic> body,
  });

  Future<Either<Failure, void>> deleteClient(int clientId);

  Future<Either<Failure, List<ClientEntity>>> searchClients(String keyword);

  Future<Either<Failure, ClientStatementResponseEntity>> getClientStatement({
    required int clientId,
    String? startDate,
    String? endDate,
    String? transactionType,
  });
}
