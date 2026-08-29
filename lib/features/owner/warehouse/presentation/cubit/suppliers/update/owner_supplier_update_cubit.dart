import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/error/failures.dart';
import '../../../../domain/entities/suppliers/update_owner_supplier_params.dart';
import '../../../../domain/usecases/suppliers/update_owner_supplier_usecase.dart';
import 'owner_supplier_update_state.dart';

class OwnerSupplierUpdateCubit extends Cubit<OwnerSupplierUpdateState> {
  final UpdateOwnerSupplierUseCase _updateOwnerSupplierUseCase;

  OwnerSupplierUpdateCubit(this._updateOwnerSupplierUseCase) : super(OwnerSupplierUpdateInitial());

  Future<void> updateSupplier(int id, UpdateOwnerSupplierParams params) async {
    emit(OwnerSupplierUpdateLoading());

    final result = await _updateOwnerSupplierUseCase(id, params);

    result.fold(
      (failure) {
        final validationErrors = (failure is ServerFailure) ? failure.validationErrors : null;
        emit(OwnerSupplierUpdateError(failure.message, validationErrors: validationErrors));
      },
      (supplier) => emit(OwnerSupplierUpdateSuccess(supplier)),
    );
  }
}
