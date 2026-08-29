import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_warehouse_details_usecase.dart';
import 'owner_warehouse_details_state.dart';

class OwnerWarehouseDetailsCubit extends Cubit<OwnerWarehouseDetailsState> {
  final GetOwnerWarehouseDetailsUseCase getOwnerWarehouseDetailsUseCase;

  OwnerWarehouseDetailsCubit({
    required this.getOwnerWarehouseDetailsUseCase,
  }) : super(OwnerWarehouseDetailsInitial());

  Future<void> fetchWarehouseDetails(int id) async {
    emit(OwnerWarehouseDetailsLoading());
    final result = await getOwnerWarehouseDetailsUseCase(id);
    if (!isClosed) {
      result.fold(
        (failure) => emit(OwnerWarehouseDetailsError(failure.message)),
        (warehouse) => emit(OwnerWarehouseDetailsLoaded(warehouse)),
      );
    }
  }
}
