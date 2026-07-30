import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/usecases/approve_owner_maintenance_use_case.dart';
import 'owner_approve_maintenance_state.dart';

class OwnerApproveMaintenanceCubit extends Cubit<OwnerApproveMaintenanceState> {
  final ApproveOwnerMaintenanceUseCase _approveUseCase;

  OwnerApproveMaintenanceCubit(this._approveUseCase)
    : super(const OwnerApproveMaintenanceInitial());

  Future<void> approveMaintenanceRequest({
    required int id,
    required num estimatedCost,
    num? advancePayment,
    required String costBearer,
    String? supervisorNotes,
  }) async {
    emit(const OwnerApproveMaintenanceLoading());

    final params = ApproveOwnerMaintenanceParams(
      id: id,
      estimatedCost: estimatedCost,
      advancePayment: advancePayment,
      costBearer: costBearer,
      supervisorNotes: supervisorNotes,
    );

    final result = await _approveUseCase(params);

    result.fold(
      (failure) => emit(OwnerApproveMaintenanceError(failure.message)),
      (_) => emit(
        OwnerApproveMaintenanceSuccess(
          LocaleKeys.maintenanceApproveSuccess.tr(),
        ),
      ),
    );
  }
}
