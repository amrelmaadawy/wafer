import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/warehouse_item_details_entity.dart';
import '../repositories/owner_warehouse_repository.dart';

class GetOwnerWarehouseItemDetailsUseCase
    implements UseCase<WarehouseItemDetailsEntity, int> {
  final OwnerWarehouseRepository repository;

  GetOwnerWarehouseItemDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, WarehouseItemDetailsEntity>> call(int id) async {
    return await repository.getWarehouseItemDetails(id);
  }
}
