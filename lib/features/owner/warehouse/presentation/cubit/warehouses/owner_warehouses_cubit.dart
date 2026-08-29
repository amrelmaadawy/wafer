import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_owner_warehouses_use_case.dart';
import 'owner_warehouses_state.dart';

class OwnerWarehousesCubit extends Cubit<OwnerWarehousesState> {
  final GetOwnerWarehousesUseCase getOwnerWarehousesUseCase;

  OwnerWarehousesCubit({
    required this.getOwnerWarehousesUseCase,
  }) : super(OwnerWarehousesInitial());

  Future<void> fetchWarehouses() async {
    emit(OwnerWarehousesLoading());

    final result = await getOwnerWarehousesUseCase(const NoParams());

    if (!isClosed) {
      result.fold(
        (failure) => emit(OwnerWarehousesError(message: failure.message)),
        (response) => emit(OwnerWarehousesLoaded(response: response)),
      );
    }
  }
}
