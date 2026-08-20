import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/usecases/update_owner_contract_use_case.dart';
import 'owner_update_contract_state.dart';

class OwnerUpdateContractCubit extends Cubit<OwnerUpdateContractState> {
  final UpdateOwnerContractUseCase _updateContractUseCase;

  OwnerUpdateContractCubit(this._updateContractUseCase)
      : super(const OwnerUpdateContractInitial());

  Future<void> updateContract({
    required String id,
    int? renewalNoticeDays,
    String? notes,
  }) async {
    emit(const OwnerUpdateContractLoading());

    final result = await _updateContractUseCase(
      id: id,
      renewalNoticeDays: renewalNoticeDays,
      notes: notes,
    );

    result.fold(
      (failure) {
        if (failure is ServerFailure && failure.validationErrors != null) {
          emit(
            OwnerUpdateContractError(
              failure.message,
              validationErrors: failure.validationErrors,
            ),
          );
        } else {
          emit(OwnerUpdateContractError(failure.message));
        }
      },
      (_) => emit(const OwnerUpdateContractSuccess()),
    );
  }
}
