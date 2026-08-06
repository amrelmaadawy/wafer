import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/start_owner_maintenance_use_case.dart';
import 'owner_start_maintenance_state.dart';

class OwnerStartMaintenanceCubit extends Cubit<OwnerStartMaintenanceState> {
  final StartOwnerMaintenanceUseCase _startMaintenanceUseCase;

  OwnerStartMaintenanceCubit(this._startMaintenanceUseCase)
    : super(OwnerStartMaintenanceInitial());

  Future<void> startMaintenanceRequest(int id) async {
    emit(OwnerStartMaintenanceLoading());
    final result = await _startMaintenanceUseCase(id);
    result.fold(
      (failure) => emit(OwnerStartMaintenanceError(failure.message)),
      (item) => emit(OwnerStartMaintenanceSuccess(item)),
    );
  }
}
