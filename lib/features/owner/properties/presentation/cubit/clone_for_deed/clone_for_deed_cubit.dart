import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/properties_repository.dart';
import 'clone_for_deed_state.dart';

class CloneForDeedCubit extends Cubit<CloneForDeedState> {
  final PropertiesRepository _repository;

  CloneForDeedCubit(this._repository) : super(CloneForDeedInitial());

  Future<void> cloneForDeed(int propertyId, bool copyData) async {
    emit(CloneForDeedLoading());
    final result = await _repository.cloneForDeed(propertyId, copyData);
    result.fold(
      (failure) => emit(CloneForDeedError(failure.message)),
      (newPropertyId) => emit(CloneForDeedSuccess(newPropertyId)),
    );
  }
}

