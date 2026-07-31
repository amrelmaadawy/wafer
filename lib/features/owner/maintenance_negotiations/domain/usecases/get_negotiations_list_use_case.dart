import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/negotiations_list_response_entity.dart';
import '../repositories/maintenance_negotiation_repository.dart';
import 'package:equatable/equatable.dart';

class GetNegotiationsListUseCase implements UseCase<NegotiationsListResponseEntity, NegotiationsListParams> {
  final MaintenanceNegotiationRepository repository;

  GetNegotiationsListUseCase(this.repository);

  @override
  Future<Either<Failure, NegotiationsListResponseEntity>> call(NegotiationsListParams params) async {
    return await repository.getNegotiationsList(
      page: params.page,
      perPage: params.perPage,
    );
  }
}

class NegotiationsListParams extends Equatable {
  final int page;
  final int perPage;

  const NegotiationsListParams({
    this.page = 1,
    this.perPage = 15,
  });

  @override
  List<Object?> get props => [page, perPage];
}
