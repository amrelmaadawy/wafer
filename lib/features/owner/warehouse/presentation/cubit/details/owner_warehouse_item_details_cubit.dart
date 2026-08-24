import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_owner_warehouse_item_details_use_case.dart';
import 'owner_warehouse_item_details_state.dart';

class OwnerWarehouseItemDetailsCubit
    extends Cubit<OwnerWarehouseItemDetailsState> {
  final GetOwnerWarehouseItemDetailsUseCase getDetailsUseCase;

  OwnerWarehouseItemDetailsCubit({required this.getDetailsUseCase})
      : super(OwnerWarehouseItemDetailsInitial());

  Future<void> fetchItemDetails(int itemId) async {
    emit(OwnerWarehouseItemDetailsLoading());

    final result = await getDetailsUseCase(itemId);

    result.fold(
      (failure) => emit(OwnerWarehouseItemDetailsError(failure.message)),
      (details) => emit(OwnerWarehouseItemDetailsLoaded(details)),
    );
  }
}
