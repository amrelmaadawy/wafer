import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/warehouse_items_response_entity.dart';
import '../repositories/owner_warehouse_repository.dart';

class GetOwnerWarehouseItemsUseCase
    implements
        UseCase<WarehouseItemsResponseEntity, GetOwnerWarehouseItemsParams> {
  final OwnerWarehouseRepository repository;

  GetOwnerWarehouseItemsUseCase(this.repository);

  @override
  Future<Either<Failure, WarehouseItemsResponseEntity>> call(
    GetOwnerWarehouseItemsParams params,
  ) {
    return repository.getWarehouseItems(
      page: params.page,
      search: params.search,
      category: params.category,
      warehouseId: params.warehouseId,
      status: params.status,
    );
  }
}

class GetOwnerWarehouseItemsParams extends Equatable {
  final int page;
  final String? search;
  final String? category;
  final int? warehouseId;
  final String? status;

  const GetOwnerWarehouseItemsParams({
    this.page = 1,
    this.search,
    this.category,
    this.warehouseId,
    this.status,
  });

  @override
  List<Object?> get props => [page, search, category, warehouseId, status];
}
