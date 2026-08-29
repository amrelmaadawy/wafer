import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/warehouse_entity.dart';
import '../repositories/owner_warehouse_repository.dart';

class GetOwnerWarehouseDetailsUseCase implements UseCase<WarehouseEntity, int> {
  final OwnerWarehouseRepository repository;

  GetOwnerWarehouseDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, WarehouseEntity>> call(int params) async {
    return await repository.getWarehouseDetails(params);
  }
}
