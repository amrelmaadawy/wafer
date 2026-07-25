import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_unit_details_use_case.dart';
import 'unit_details_state.dart';

class UnitDetailsCubit extends Cubit<UnitDetailsState> {
  final GetUnitDetailsUseCase _getUnitDetailsUseCase;
  int _lastPropertyId = 0;
  int _lastUnitId = 0;

  UnitDetailsCubit(this._getUnitDetailsUseCase) : super(UnitDetailsInitial());

  Future<void> fetchUnitDetails(int propertyId, int unitId) async {
    _lastPropertyId = propertyId;
    _lastUnitId = unitId;
    emit(UnitDetailsLoading());
    final result = await _getUnitDetailsUseCase(propertyId, unitId);
    result.fold(
      (failure) => emit(UnitDetailsError(failure.message)),
      (unit) => emit(UnitDetailsLoaded(unit)),
    );
  }

  Future<void> retryFetch() async {
    if (_lastPropertyId != 0 && _lastUnitId != 0) {
      await fetchUnitDetails(_lastPropertyId, _lastUnitId);
    }
  }
}
