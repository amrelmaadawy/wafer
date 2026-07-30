import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import '../../../domain/usecases/reject_owner_maintenance_use_case.dart';
import 'owner_reject_maintenance_state.dart';

class OwnerRejectMaintenanceCubit extends Cubit<OwnerRejectMaintenanceState> {
  final RejectOwnerMaintenanceUseCase _rejectUseCase;

  OwnerRejectMaintenanceCubit(this._rejectUseCase)
    : super(const OwnerRejectMaintenanceInitial());

  Future<void> rejectMaintenanceRequest({
    required int id,
    required String supervisorNotes,
  }) async {
    emit(const OwnerRejectMaintenanceLoading());

    final params = RejectOwnerMaintenanceParams(
      id: id,
      supervisorNotes: supervisorNotes,
    );

    final result = await _rejectUseCase(params);

    result.fold(
      (failure) => emit(OwnerRejectMaintenanceError(failure.message)),
      (_) => emit(
        OwnerRejectMaintenanceSuccess(LocaleKeys.maintenanceRejectSuccess.tr()),
      ),
    );
  }
}
