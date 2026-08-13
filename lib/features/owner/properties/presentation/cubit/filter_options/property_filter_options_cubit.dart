import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_property_form_options_use_case.dart';
import 'property_filter_options_state.dart';

class PropertyFilterOptionsCubit extends Cubit<PropertyFilterOptionsState> {
  final GetPropertyFormOptionsUseCase _getOptions;

  PropertyFilterOptionsCubit(this._getOptions)
    : super(const PropertyFilterOptionsInitial());

  Future<void> load() async {
    if (state is PropertyFilterOptionsLoaded ||
        state is PropertyFilterOptionsLoading) {
      return;
    }
    emit(const PropertyFilterOptionsLoading());
    final result = await _getOptions();
    result.fold(
      (failure) => emit(PropertyFilterOptionsError(failure.message)),
      (options) => emit(PropertyFilterOptionsLoaded(options)),
    );
  }
}
