import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/usecases/forward_owner_maintenance_use_case.dart';
import 'owner_forward_maintenance_state.dart';

class OwnerForwardMaintenanceCubit extends Cubit<OwnerForwardMaintenanceState> {
  final ForwardOwnerMaintenanceUseCase _forwardUseCase;

  OwnerForwardMaintenanceCubit(this._forwardUseCase)
    : super(const OwnerForwardMaintenanceInitial());

  Future<void> forwardMaintenanceRequest({
    required int id,
    String? notes,
  }) async {
    emit(const OwnerForwardMaintenanceLoading());

    final params = ForwardOwnerMaintenanceParams(
      id: id,
      notes: notes,
    );

    final result = await _forwardUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) => emit(OwnerForwardMaintenanceError(failure.message)),
      (_) => emit(
        OwnerForwardMaintenanceSuccess(
          LocaleKeys.maintenanceForwardSuccess.tr(),
        ),
      ),
    );
  }
}
