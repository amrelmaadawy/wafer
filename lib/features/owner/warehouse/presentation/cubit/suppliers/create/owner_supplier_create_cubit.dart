import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/error/failures.dart';
import '../../../../domain/entities/suppliers/create_owner_supplier_params.dart';
import '../../../../domain/usecases/suppliers/create_owner_supplier_usecase.dart';
import 'owner_supplier_create_state.dart';

class OwnerSupplierCreateCubit extends Cubit<OwnerSupplierCreateState> {
  final CreateOwnerSupplierUseCase _createUseCase;

  OwnerSupplierCreateCubit(this._createUseCase) : super(OwnerSupplierCreateInitial());

  Future<void> createSupplier(CreateOwnerSupplierParams params) async {
    if (isClosed) return;
    emit(OwnerSupplierCreateLoading());

    final result = await _createUseCase(params);

    if (isClosed) return;
    result.fold(
      (failure) {
        if (failure is ServerFailure && failure.validationErrors != null) {
          emit(OwnerSupplierCreateError(failure.message, validationErrors: failure.validationErrors));
        } else {
          emit(OwnerSupplierCreateError(failure.message));
        }
      },
      (_) => emit(OwnerSupplierCreateSuccess()),
    );
  }
}
