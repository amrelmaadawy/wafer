import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/suppliers/delete_owner_supplier_usecase.dart';
import 'owner_supplier_delete_state.dart';

class OwnerSupplierDeleteCubit extends Cubit<OwnerSupplierDeleteState> {
  final DeleteOwnerSupplierUseCase _deleteOwnerSupplierUseCase;

  OwnerSupplierDeleteCubit(this._deleteOwnerSupplierUseCase) : super(OwnerSupplierDeleteInitial());

  Future<void> deleteSupplier(int id) async {
    emit(OwnerSupplierDeleteLoading());

    final result = await _deleteOwnerSupplierUseCase(id);

    result.fold(
      (failure) => emit(OwnerSupplierDeleteError(failure.message)),
      (_) => emit(OwnerSupplierDeleteSuccess()),
    );
  }
}
