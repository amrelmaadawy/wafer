import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../../domain/entities/update_warehouse_item_params.dart';
import '../../../domain/usecases/update_owner_warehouse_item_use_case.dart';
import 'owner_warehouse_item_update_state.dart';

class OwnerWarehouseItemUpdateCubit extends Cubit<OwnerWarehouseItemUpdateState> {
  final UpdateOwnerWarehouseItemUseCase updateUseCase;

  OwnerWarehouseItemUpdateCubit({
    required this.updateUseCase,
  }) : super(OwnerWarehouseItemUpdateInitial());

  Future<void> updateItem({
    required int id,
    num? minQuantity,
    num? sellingPrice,
    String? description,
  }) async {
    emit(OwnerWarehouseItemUpdateLoading());

    final params = UpdateWarehouseItemParams(
      id: id,
      minQuantity: minQuantity,
      sellingPrice: sellingPrice,
      description: description,
    );

    final result = await updateUseCase(params);

    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(OwnerWarehouseItemUpdateError(
            failure.message,
            validationErrors: failure.validationErrors,
          ));
        } else {
          emit(OwnerWarehouseItemUpdateError(failure.message));
        }
      },
      (successResult) => emit(OwnerWarehouseItemUpdateSuccess(successResult)),
    );
  }
}
