import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/suppliers/get_owner_supplier_details_usecase.dart';
import 'owner_supplier_details_state.dart';

class OwnerSupplierDetailsCubit extends Cubit<OwnerSupplierDetailsState> {
  final GetOwnerSupplierDetailsUseCase getDetailsUseCase;

  OwnerSupplierDetailsCubit(this.getDetailsUseCase) : super(OwnerSupplierDetailsInitial());

  Future<void> fetchSupplierDetails(int supplierId) async {
    if (isClosed) return;
    
    emit(OwnerSupplierDetailsLoading());

    final result = await getDetailsUseCase(supplierId);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(OwnerSupplierDetailsError(failure.message));
      },
      (supplier) {
        emit(OwnerSupplierDetailsSuccess(supplier));
      },
    );
  }
}
