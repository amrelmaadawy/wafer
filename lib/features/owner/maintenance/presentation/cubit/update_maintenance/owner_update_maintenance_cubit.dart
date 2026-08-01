import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../domain/usecases/update_owner_maintenance_use_case.dart';
import '../../../domain/usecases/get_owner_maintenance_form_data_use_case.dart';
import 'owner_update_maintenance_state.dart';

class OwnerUpdateMaintenanceCubit extends Cubit<OwnerUpdateMaintenanceState> {
  final UpdateOwnerMaintenanceUseCase _updateUseCase;
  final GetOwnerMaintenanceFormDataUseCase _getFormDataUseCase;

  OwnerUpdateMaintenanceCubit(this._updateUseCase, this._getFormDataUseCase)
    : super(const OwnerUpdateMaintenanceState());

  Future<void> init() async {
    emit(state.copyWith(isFormDataLoading: true));
    final result = await _getFormDataUseCase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isFormDataLoading: false,
            formDataError: failure.message,
          ),
        );
      },
      (formData) {
        emit(
          state.copyWith(
            isFormDataLoading: false,
            availableMaintenanceTypes: formData.maintenanceTypes,
          ),
        );
      },
    );
  }

  Future<void> updateMaintenanceRequest({
    required int id,
    required String description,
    String? scheduledDate,
    required List<String> maintenanceTypes,
  }) async {
    if (description.trim().isEmpty || maintenanceTypes.isEmpty) {
      emit(
        state.copyWith(
          status: UpdateMaintenanceStatus.failure,
          errorMessage: LocaleKeys.maintenanceCreateFillAllFields.tr(),
        ),
      );
      return;
    }

    emit(state.copyWith(status: UpdateMaintenanceStatus.loading));

    final params = UpdateOwnerMaintenanceParams(
      id: id,
      description: description,
      scheduledDate: scheduledDate,
      maintenanceTypes: maintenanceTypes,
    );

    final result = await _updateUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: UpdateMaintenanceStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: UpdateMaintenanceStatus.success,
            successMessage: LocaleKeys.maintenanceUpdatedSuccessfully.tr(),
          ),
        );
      },
    );
  }
}
