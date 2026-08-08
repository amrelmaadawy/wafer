import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_unit_use_case.dart';
import 'unit_delete_state.dart';

class UnitDeleteCubit extends Cubit<UnitDeleteState> {
  final DeleteUnitUseCase _deleteUnitUseCase;

  UnitDeleteCubit(this._deleteUnitUseCase) : super(UnitDeleteInitial());

  Future<void> deleteUnit(int unitId) async {
    emit(UnitDeleteLoading());
    final result = await _deleteUnitUseCase(unitId);
    result.fold(
      (failure) => emit(UnitDeleteError(failure.message)),
      (_) => emit(UnitDeleteSuccess()),
    );
  }
}
