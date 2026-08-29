import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/delete_owner_warehouse_use_case.dart';
import 'owner_warehouse_delete_state.dart';

class OwnerWarehouseDeleteCubit extends Cubit<OwnerWarehouseDeleteState> {
  final DeleteOwnerWarehouseUseCase _deleteUseCase;

  OwnerWarehouseDeleteCubit(this._deleteUseCase)
      : super(OwnerWarehouseDeleteInitial());

  Future<void> deleteWarehouse(int id) async {
    if (isClosed) return;
    emit(OwnerWarehouseDeleteLoading());

    final result = await _deleteUseCase(id);

    if (!isClosed) {
      result.fold(
        (failure) => emit(OwnerWarehouseDeleteError(failure.message)),
        (_) => emit(OwnerWarehouseDeleteSuccess()),
      );
    }
  }
}
