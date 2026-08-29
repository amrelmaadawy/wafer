import 'package:dartz/dartz.dart';

import '../../../../../../core/error/failures.dart';
import '../../entities/suppliers/supplier_entity.dart';
import '../../entities/suppliers/create_owner_supplier_params.dart';
import '../../repositories/owner_suppliers_repository.dart';

class CreateOwnerSupplierUseCase {
  final OwnerSuppliersRepository repository;

  CreateOwnerSupplierUseCase(this.repository);

  Future<Either<Failure, SupplierEntity>> call(CreateOwnerSupplierParams params) {
    return repository.createSupplier(params);
  }
}
