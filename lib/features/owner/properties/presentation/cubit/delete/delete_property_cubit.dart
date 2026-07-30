import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_property_use_case.dart';
import 'delete_property_state.dart';

class DeletePropertyCubit extends Cubit<DeletePropertyState> {
  final DeletePropertyUseCase _deletePropertyUseCase;

  DeletePropertyCubit(this._deletePropertyUseCase)
    : super(const DeletePropertyInitial());

  Future<void> deleteProperty(int propertyId) async {
    emit(const DeletePropertyLoading());
    final result = await _deletePropertyUseCase(propertyId);
    result.fold(
      (failure) => emit(DeletePropertyError(failure.message)),
      (_) => emit(const DeletePropertySuccess()),
    );
  }
}
