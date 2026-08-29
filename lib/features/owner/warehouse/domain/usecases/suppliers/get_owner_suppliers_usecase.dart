import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../entities/suppliers/supplier_entity.dart';
import '../../repositories/owner_suppliers_repository.dart';

class GetOwnerSuppliersUseCase implements UseCase<PaginatedSuppliersEntity, int> {
  final OwnerSuppliersRepository repository;

  GetOwnerSuppliersUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedSuppliersEntity>> call(int page) async {
    return await repository.getSuppliers(page);
  }
}
