import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/verify_close_owner_maintenance_use_case.dart';
import 'owner_verify_close_maintenance_state.dart';

class OwnerVerifyCloseMaintenanceCubit extends Cubit<OwnerVerifyCloseMaintenanceState> {
  final VerifyCloseOwnerMaintenanceUseCase verifyCloseUseCase;

  OwnerVerifyCloseMaintenanceCubit({
    required this.verifyCloseUseCase,
  }) : super(const OwnerVerifyCloseMaintenanceState());

  Future<void> verifyCloseMaintenanceRequest({
    required int id,
    required String qaCode,
    required double actualCost,
    required String notes,
  }) async {
    emit(state.copyWith(status: OwnerVerifyCloseMaintenanceStatus.loading));

    final result = await verifyCloseUseCase(
      VerifyCloseOwnerMaintenanceParams(
        id: id,
        qaCode: qaCode,
        actualCost: actualCost,
        notes: notes,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: OwnerVerifyCloseMaintenanceStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (item) {
        emit(
          state.copyWith(
            status: OwnerVerifyCloseMaintenanceStatus.success,
            item: item,
          ),
        );
      },
    );
  }
}
