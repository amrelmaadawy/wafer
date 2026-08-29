import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/create_owner_warehouse_params.dart';
import '../../../domain/usecases/create_owner_warehouse_use_case.dart';
import 'owner_warehouse_create_state.dart';

class OwnerWarehouseCreateCubit extends Cubit<OwnerWarehouseCreateState> {
  final CreateOwnerWarehouseUseCase _createWarehouseUseCase;

  OwnerWarehouseCreateCubit(this._createWarehouseUseCase)
      : super(OwnerWarehouseCreateInitial());

  Future<void> createWarehouse({
    required String name,
    required String code,
    String? notes,
    required bool isActive,
  }) async {
    emit(OwnerWarehouseCreateLoading());

    final params = CreateOwnerWarehouseParams(
      name: name,
      code: code,
      notes: notes,
      isActive: isActive,
    );

    final result = await _createWarehouseUseCase(params);

    result.fold(
      (failure) => emit(OwnerWarehouseCreateError(failure.message)),
      (warehouse) => emit(OwnerWarehouseCreateSuccess(warehouse)),
    );
  }
}
