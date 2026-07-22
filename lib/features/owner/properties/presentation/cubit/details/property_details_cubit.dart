import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_property_details_use_case.dart';
import 'property_details_state.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  final GetPropertyDetailsUseCase _getPropertyDetailsUseCase;

  PropertyDetailsCubit(this._getPropertyDetailsUseCase)
      : super(const PropertyDetailsInitial());

  Future<void> loadDetails(int propertyId) async {
    emit(const PropertyDetailsLoading());
    final result = await _getPropertyDetailsUseCase(propertyId);
    result.fold(
      (failure) => emit(PropertyDetailsError(failure.message)),
      (property) => emit(PropertyDetailsLoaded(property)),
    );
  }
}
