import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/update_owner_warehouse_params.dart';
import '../../../domain/usecases/update_owner_warehouse_use_case.dart';
import 'owner_warehouse_update_state.dart';

class OwnerWarehouseUpdateCubit extends Cubit<OwnerWarehouseUpdateState> {
  final UpdateOwnerWarehouseUseCase _updateUseCase;

  OwnerWarehouseUpdateCubit(this._updateUseCase)
      : super(OwnerWarehouseUpdateInitial());

  Future<void> updateWarehouse({
    required int id,
    String? name,
    String? code,
    String? notes,
    bool? isActive,
    int? parentId,
  }) async {
    if (isClosed) return;
    emit(OwnerWarehouseUpdateLoading());

    final params = UpdateOwnerWarehouseParams(
      name: name,
      code: code,
      notes: notes,
      isActive: isActive,
      parentId: parentId,
    );

    final result = await _updateUseCase(id, params);

    if (!isClosed) {
      result.fold(
        (failure) => emit(OwnerWarehouseUpdateError(failure.message)),
        (_) => emit(OwnerWarehouseUpdateSuccess()),
      );
    }
  }
}
