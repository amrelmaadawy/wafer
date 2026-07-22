import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_property_units_use_case.dart';
import 'units_list_state.dart';

class UnitsListCubit extends Cubit<UnitsListState> {
  final GetPropertyUnitsUseCase _getPropertyUnitsUseCase;

  UnitsListCubit(this._getPropertyUnitsUseCase)
      : super(const UnitsListInitial());

  Future<void> loadUnits(int propertyId) async {
    emit(const UnitsListLoading());
    final result = await _getPropertyUnitsUseCase(propertyId);
    result.fold(
      (failure) => emit(UnitsListError(failure.message)),
      (units) {
        if (units.isEmpty) {
          emit(const UnitsListEmpty());
        } else {
          emit(UnitsListLoaded(units));
        }
      },
    );
  }
}
