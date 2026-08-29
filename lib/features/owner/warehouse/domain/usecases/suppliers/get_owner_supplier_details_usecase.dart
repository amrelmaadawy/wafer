import 'package:dartz/dartz.dart';

import 'package:wafer/core/error/failures.dart';
import 'package:wafer/core/usecases/usecase.dart';
import '../../entities/suppliers/supplier_entity.dart';
import '../../repositories/owner_suppliers_repository.dart';

class GetOwnerSupplierDetailsUseCase implements UseCase<SupplierEntity, int> {
  final OwnerSuppliersRepository repository;

  GetOwnerSupplierDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, SupplierEntity>> call(int supplierId) async {
    return await repository.getSupplierDetails(supplierId);
  }
}
