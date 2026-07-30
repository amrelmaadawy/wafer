import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_owner_maintenance_use_case.dart';
import 'owner_delete_maintenance_state.dart';

class OwnerDeleteMaintenanceCubit extends Cubit<OwnerDeleteMaintenanceState> {
  final DeleteOwnerMaintenanceUseCase _deleteUseCase;

  OwnerDeleteMaintenanceCubit(this._deleteUseCase)
      : super(const OwnerDeleteMaintenanceState());

  Future<void> deleteMaintenanceRequest(int id) async {
    emit(state.copyWith(status: DeleteMaintenanceStatus.loading));
    final result = await _deleteUseCase(id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: DeleteMaintenanceStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: DeleteMaintenanceStatus.success)),
    );
  }
}
