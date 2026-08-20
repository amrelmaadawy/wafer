import 'package:dartz/dartz.dart';
import '../../../../../core/data/base_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/clients_list_response_entity.dart';
import '../../domain/repositories/owner_clients_repository.dart';
import '../datasources/owner_clients_remote_data_source.dart';

class OwnerClientsRepositoryImpl extends BaseRepository implements OwnerClientsRepository {
  final OwnerClientsRemoteDataSource remoteDataSource;

  OwnerClientsRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, ClientsListResponseEntity>> getClients({
    int page = 1,
    Map<String, dynamic>? filters,
  }) async {
    return executeApiCall<ClientsListResponseEntity>(
      call: () => remoteDataSource.getClients(page: page, filters: filters),
    );
  }
}
