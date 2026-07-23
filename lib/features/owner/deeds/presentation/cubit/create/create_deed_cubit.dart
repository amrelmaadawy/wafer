import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../properties/domain/usecases/get_property_form_options_use_case.dart';
import '../../../../properties/domain/entities/form_branch_entity.dart';
import '../../../domain/usecases/create_deed_use_case.dart';
import 'create_deed_state.dart';

class CreateDeedCubit extends Cubit<CreateDeedState> {
  final AddNewDeedUseCase _createDeedUseCase;
  final GetPropertyFormOptionsUseCase _getOptionsUseCase;

  List<FormBranchEntity> branches = [];

  CreateDeedCubit(this._createDeedUseCase, this._getOptionsUseCase) : super(const CreateDeedInitial());

  Future<void> fetchOptions() async {
    emit(const CreateDeedLoading());
    final result = await _getOptionsUseCase();
    if (isClosed) return;
    
    result.fold(
      (failure) => emit(CreateDeedError(failure.message)),
      (options) {
        branches = options.branches;
        emit(FormOptionsLoaded(options.branches));
      },
    );
  }

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
