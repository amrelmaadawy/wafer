import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/property_details_entity.dart';
import '../../../domain/usecases/get_property_details_use_case.dart';
import '../../../domain/usecases/make_representative_use_case.dart';
import '../../../domain/usecases/remove_representative_use_case.dart';
import 'property_details_state.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  final GetPropertyDetailsUseCase _getPropertyDetailsUseCase;
  final MakeRepresentativeUseCase _makeRepresentativeUseCase;
  final RemoveRepresentativeUseCase _removeRepresentativeUseCase;

  PropertyDetailsCubit(
    this._getPropertyDetailsUseCase,
    this._makeRepresentativeUseCase,
    this._removeRepresentativeUseCase,
  ) : super(const PropertyDetailsInitial());

  Future<void> loadDetails(int propertyId) async {
    emit(const PropertyDetailsLoading());
    final result = await _getPropertyDetailsUseCase(propertyId);
    result.fold(
      (failure) => emit(PropertyDetailsError(failure.message)),
      (property) => emit(PropertyDetailsLoaded(property)),
    );
  }

  void updateProperty(PropertyDetailsEntity property) {
    emit(PropertyDetailsLoaded(property));
  }

  Future<void> makeRepresentative(int propertyId, int ownerId) async {
    if (state is PropertyDetailsLoaded) {
      final currentState = state as PropertyDetailsLoaded;
      emit(currentState.copyWith(isMakingRepresentative: true, actionOwnerId: ownerId));
      
      final result = await _makeRepresentativeUseCase(propertyId, ownerId);
      
      result.fold(
        (failure) {
          emit(currentState.copyWith(isMakingRepresentative: false, actionOwnerId: null));
          emit(PropertyDetailsError(failure.message));
          // Re-emit loaded so UI doesn't get stuck in error state
          emit(currentState);
        },
        (updatedProperty) {
          emit(PropertyDetailsLoaded(updatedProperty));
        },
      );
    }
  }

  Future<void> removeRepresentative(int propertyId, int ownerId) async {
    if (state is PropertyDetailsLoaded) {
      final currentState = state as PropertyDetailsLoaded;
      emit(currentState.copyWith(isRemovingRepresentative: true, actionOwnerId: ownerId));
      
      final result = await _removeRepresentativeUseCase(propertyId, ownerId);
      
      result.fold(
        (failure) {
          emit(currentState.copyWith(isRemovingRepresentative: false, actionOwnerId: null));
          emit(PropertyDetailsError(failure.message));
          // Re-emit loaded so UI doesn't get stuck in error state
          emit(currentState);
        },
        (updatedProperty) {
          emit(PropertyDetailsLoaded(updatedProperty));
        },
      );
    }
  }
}
