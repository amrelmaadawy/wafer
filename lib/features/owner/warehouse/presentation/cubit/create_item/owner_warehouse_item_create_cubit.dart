import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/create_warehouse_item_params.dart';
import '../../../domain/usecases/create_owner_warehouse_item_use_case.dart';
import 'owner_warehouse_item_create_state.dart';

class OwnerWarehouseItemCreateCubit
    extends Cubit<OwnerWarehouseItemCreateState> {
  final CreateOwnerWarehouseItemUseCase createWarehouseItemUseCase;

  OwnerWarehouseItemCreateCubit({required this.createWarehouseItemUseCase})
    : super(OwnerWarehouseItemCreateInitial());

  Future<void> createItem(CreateWarehouseItemParams params) async {
    emit(OwnerWarehouseItemCreateLoading());

    final result = await createWarehouseItemUseCase(params);

    result.fold(
      (failure) => emit(OwnerWarehouseItemCreateError(failure.message)),
      (item) => emit(OwnerWarehouseItemCreateSuccess(item)),
    );
  }
}
