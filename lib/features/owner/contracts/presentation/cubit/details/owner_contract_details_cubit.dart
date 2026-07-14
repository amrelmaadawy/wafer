import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_owner_contract_details_use_case.dart';
import 'owner_contract_details_state.dart';

class OwnerContractDetailsCubit extends Cubit<OwnerContractDetailsState> {
  final GetOwnerContractDetailsUseCase _getContractDetailsUseCase;

  OwnerContractDetailsCubit(this._getContractDetailsUseCase)
      : super(const OwnerContractDetailsInitial());

  Future<void> getContractDetails(String contractId) async {
    emit(const OwnerContractDetailsLoading());
    final result = await _getContractDetailsUseCase(contractId);
    result.fold(
      (failure) => emit(OwnerContractDetailsError(failure.message)),
      (contract) => emit(OwnerContractDetailsLoaded(contract)),
    );
  }
}
