import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../properties/domain/usecases/get_properties_list_use_case.dart';
import '../../../../properties/domain/usecases/get_property_units_use_case.dart';
import '../../../domain/usecases/create_owner_maintenance_use_case.dart';
import 'owner_create_maintenance_state.dart';

class OwnerCreateMaintenanceCubit extends Cubit<OwnerCreateMaintenanceState> {
  final GetPropertiesListUseCase _getPropertiesUseCase;
  final GetPropertyUnitsUseCase _getUnitsUseCase;
  final CreateOwnerMaintenanceUseCase _createMaintenanceUseCase;

  OwnerCreateMaintenanceCubit(
    this._getPropertiesUseCase,
    this._getUnitsUseCase,
    this._createMaintenanceUseCase,
  ) : super(const OwnerCreateMaintenanceState());

  void init() {
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    emit(state.copyWith(isPropertiesLoading: true, propertiesError: null));
    
    final result = await _getPropertiesUseCase();
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          isPropertiesLoading: false,
          propertiesError: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          isPropertiesLoading: false,
          properties: data.items,
        ));
      },
    );
  }

  Future<void> loadUnits(int propertyId) async {
    emit(state.copyWithNullUnitId(isUnitsLoading: true, unitsError: null, selectedPropertyId: propertyId));
    
    final result = await _getUnitsUseCase(propertyId);
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          isUnitsLoading: false,
          unitsError: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          isUnitsLoading: false,
          units: data.items,
        ));
      },
    );
  }

  void updateClientName(String val) => emit(state.copyWith(clientName: val));
  
  void updateClientPhone(String val) => emit(state.copyWith(clientPhone: val));
  
  void updateDescription(String val) => emit(state.copyWith(description: val));
  
  void updateRequestedDate(String val) => emit(state.copyWith(requestedDate: val));
  
  void updateIsPrivate(bool val) => emit(state.copyWith(isPrivate: val));
  
  void toggleMaintenanceType(String type) {
    final currentTypes = List<String>.from(state.maintenanceTypes);
    if (currentTypes.contains(type)) {
      currentTypes.remove(type);
    } else {
      currentTypes.add(type);
    }
    emit(state.copyWith(maintenanceTypes: currentTypes));
  }

  void selectUnit(int? unitId) {
    if (unitId == null) {
      emit(state.copyWithNullUnitId());
    } else {
      emit(state.copyWith(selectedUnitId: unitId));
    }
  }

  Future<void> submit() async {
    if (state.selectedPropertyId == null || 
        state.clientName.isEmpty || 
        state.clientPhone.isEmpty || 
        state.description.isEmpty || 
        state.requestedDate.isEmpty) {
      emit(state.copyWith(
        status: CreateMaintenanceStatus.failure,
        errorMessage: LocaleKeys.maintenanceCreateFillAllFields.tr(),
      ));
      emit(state.copyWith(status: CreateMaintenanceStatus.initial));
      return;
    }

    emit(state.copyWith(status: CreateMaintenanceStatus.loading, errorMessage: null));

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
        emit(state.copyWith(
          status: CreateMaintenanceStatus.failure,
          errorMessage: failure.message,
        ));
        emit(state.copyWith(status: CreateMaintenanceStatus.initial));
      },
      (_) {
        emit(state.copyWith(status: CreateMaintenanceStatus.success));
      },
    );
  }
}
