import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/property_display_mode.dart';
import '../../../domain/usecases/get_property_display_mode_use_case.dart';
import '../../../domain/usecases/save_property_display_mode_use_case.dart';
import 'property_display_state.dart';

class PropertyDisplayCubit extends Cubit<PropertyDisplayState> {
  final SavePropertyDisplayModeUseCase _saveMode;

  PropertyDisplayCubit(GetPropertyDisplayModeUseCase getMode, this._saveMode)
    : super(PropertyDisplayState(getMode()));

  Future<void> changeMode(PropertyDisplayMode mode) async {
    if (mode == state.mode) return;
    emit(PropertyDisplayState(mode));
    await _saveMode(mode);
  }
}
