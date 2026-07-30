import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../domain/usecases/update_owner_maintenance_use_case.dart';
import 'owner_update_maintenance_state.dart';

class OwnerUpdateMaintenanceCubit extends Cubit<OwnerUpdateMaintenanceState> {
  final UpdateOwnerMaintenanceUseCase _updateUseCase;

  OwnerUpdateMaintenanceCubit(this._updateUseCase)
      : super(OwnerUpdateMaintenanceInitial());

  Future<void> updateMaintenanceRequest({
    required int id,
    required String description,
    String? scheduledDate,
    required List<dynamic> maintenanceTypes,
  }) async {
    if (description.trim().isEmpty || maintenanceTypes.isEmpty) {
      emit(OwnerUpdateMaintenanceError(
          message: LocaleKeys.maintenanceCreateFillAllFields.tr()));
      return;
    }

    emit(OwnerUpdateMaintenanceLoading());

    final params = UpdateOwnerMaintenanceParams(
      id: id,
      description: description,
      scheduledDate: scheduledDate,
      maintenanceTypes: maintenanceTypes,
    );

    final result = await _updateUseCase(params);

    result.fold(
      (failure) {
        emit(OwnerUpdateMaintenanceError(message: failure.message));
      },
      (success) {
        emit(OwnerUpdateMaintenanceSuccess(
            message: LocaleKeys.maintenanceUpdatedSuccessfully.tr()));
      },
    );
  }
}
