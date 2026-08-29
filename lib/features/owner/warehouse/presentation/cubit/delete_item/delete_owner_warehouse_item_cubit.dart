import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../domain/usecases/delete_warehouse_item_use_case.dart';
import 'delete_owner_warehouse_item_state.dart';

class DeleteOwnerWarehouseItemCubit extends Cubit<DeleteOwnerWarehouseItemState> {
  final DeleteWarehouseItemUseCase _deleteWarehouseItemUseCase;

  DeleteOwnerWarehouseItemCubit(this._deleteWarehouseItemUseCase)
      : super(DeleteOwnerWarehouseItemInitial());

  Future<void> deleteItem(int id) async {
    emit(DeleteOwnerWarehouseItemLoading());
    final result = await _deleteWarehouseItemUseCase(id);
    result.fold(
      (failure) {
        emit(DeleteOwnerWarehouseItemError(_mapFailureToMessage(failure)));
      },
      (_) {
        emit(DeleteOwnerWarehouseItemSuccess());
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return failure.message;
  }
}
