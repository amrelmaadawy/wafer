import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/patch_property_use_case.dart';
import 'property_edit_state.dart';

class PropertyEditCubit extends Cubit<PropertyEditState> {
  final PatchPropertyUseCase _patchProperty;

  PropertyEditCubit(this._patchProperty)
      : super(const PropertyEditState());

  Future<void> saveChanges(int propertyId, Map<String, dynamic> data) async {
    emit(state.copyWith(isSaving: true));
    final result = await _patchProperty(propertyId, data);
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, isSuccess: true)),
    );
  }
}
