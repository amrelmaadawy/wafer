import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/services/connectivity_service.dart';
import '../../../domain/usecases/get_owner_maintenance_form_data_use_case.dart';
import '../../../domain/usecases/create_owner_maintenance_use_case.dart';
import 'owner_create_maintenance_state.dart';

class OwnerCreateMaintenanceCubit extends Cubit<OwnerCreateMaintenanceState> {
  final GetOwnerMaintenanceFormDataUseCase _getFormDataUseCase;
  final CreateOwnerMaintenanceUseCase _createMaintenanceUseCase;
  final ConnectivityService _connectivityService;

  OwnerCreateMaintenanceCubit(
    this._getFormDataUseCase,
    this._createMaintenanceUseCase,
    this._connectivityService,
  ) : super(const OwnerCreateMaintenanceState());

  void init() {
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    emit(state.copyWith(isFormDataLoading: true, formDataError: null));

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
      (data) {
        emit(state.copyWith(isFormDataLoading: false, formData: data));
      },
    );
  }

  void loadUnits(int propertyId) {
    if (state.formData == null) return;

    // Attempt to find the property and its nested units
    final property = state.formData!.properties
        .where((p) => p.id == propertyId)
        .firstOrNull;

    final units = property?.units ?? [];

    emit(
      state.copyWithNullUnitId(
        selectedPropertyId: propertyId,
        filteredUnits: units,
      ),
    );
  }

  void updateClientName(String val) => emit(state.copyWith(clientName: val));
  void updateClientPhone(String val) => emit(state.copyWith(clientPhone: val));
  void updateDescription(String val) => emit(state.copyWith(description: val));
  void updateRequestedDate(String val) =>
      emit(state.copyWith(requestedDate: val));
  void updateSelectedUnit(int val) => emit(state.copyWith(selectedUnitId: val));

  void toggleMaintenanceType(String typeIdStr) {
    final types = List<String>.from(state.maintenanceTypes);
    if (types.contains(typeIdStr)) {
      types.remove(typeIdStr);
    } else {
      types.add(typeIdStr);
    }
    emit(state.copyWith(maintenanceTypes: types));
  }

  void togglePrivate(bool val) => emit(state.copyWith(isPrivate: val));

  Future<void> submit() async {
    if (state.selectedPropertyId == null) {
      emit(
        state.copyWith(
          status: CreateMaintenanceStatus.failure,
          errorMessage: LocaleKeys.maintenanceCreateRequiredField.tr(),
        ),
      );
      emit(state.copyWith(status: CreateMaintenanceStatus.initial));
      return;
    }

    emit(state.copyWith(status: CreateMaintenanceStatus.loading));

    final params = CreateOwnerMaintenanceParams(
      propertyId: state.selectedPropertyId!,
      unitId: state.selectedUnitId,
      clientName: state.clientName,
      clientPhone: state.clientPhone,
      description: state.description,
      requestedDate: state.requestedDate,
      maintenanceTypes: state.maintenanceTypes,
      isPrivate: state.isPrivate,
    );

    final result = await _createMaintenanceUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CreateMaintenanceStatus.failure,
            errorMessage: failure.message,
          ),
        );
        emit(state.copyWith(status: CreateMaintenanceStatus.initial));
      },
      (_) async {
        final isOnline = await _connectivityService.isConnected;
        if (!isOnline) {
          emit(state.copyWith(status: CreateMaintenanceStatus.offlineQueued));
        } else {
          emit(state.copyWith(status: CreateMaintenanceStatus.success));
        }
      },
    );
  }
}
