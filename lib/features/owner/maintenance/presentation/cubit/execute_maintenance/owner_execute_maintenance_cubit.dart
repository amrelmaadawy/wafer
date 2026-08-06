import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/execute_owner_maintenance_use_case.dart';
import 'owner_execute_maintenance_state.dart';

class OwnerExecuteMaintenanceCubit extends Cubit<OwnerExecuteMaintenanceState> {
  final ExecuteOwnerMaintenanceUseCase executeMaintenanceUseCase;

  OwnerExecuteMaintenanceCubit({required this.executeMaintenanceUseCase})
    : super(const OwnerExecuteMaintenanceState());

  Future<void> executeMaintenanceRequest({
    required int id,
    required String technicianResponse,
    required double actualCost,
  }) async {
    emit(state.copyWith(status: OwnerExecuteMaintenanceStatus.loading));

    final result = await executeMaintenanceUseCase(
      ExecuteOwnerMaintenanceParams(
        id: id,
        technicianResponse: technicianResponse,
        actualCost: actualCost,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: OwnerExecuteMaintenanceStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (responseEntity) {
        emit(
          state.copyWith(
            status: OwnerExecuteMaintenanceStatus.success,
            responseEntity: responseEntity,
          ),
        );
      },
    );
  }
}
