import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/create_deed_use_case.dart';
import 'create_deed_state.dart';

class CreateDeedCubit extends Cubit<CreateDeedState> {
  final AddNewDeedUseCase _createDeedUseCase;

  CreateDeedCubit(this._createDeedUseCase) : super(const CreateDeedInitial());

  Future<void> submitDeed(AddNewDeedParams params) async {
    emit(const CreateDeedLoading());

    final result = await _createDeedUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) => emit(CreateDeedError(failure.message)),
      (_) => emit(const CreateDeedSuccess()),
    );
  }
}
