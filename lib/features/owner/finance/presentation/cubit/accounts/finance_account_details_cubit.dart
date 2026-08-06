import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_finance_account_details_use_case.dart';
import 'finance_account_details_state.dart';

class FinanceAccountDetailsCubit extends Cubit<FinanceAccountDetailsState> {
  final GetFinanceAccountDetailsUseCase getAccountDetailsUseCase;

  FinanceAccountDetailsCubit({required this.getAccountDetailsUseCase})
      : super(FinanceAccountDetailsInitial());

  Future<void> fetchAccountDetails(int id) async {
    emit(FinanceAccountDetailsLoading());

    final result = await getAccountDetailsUseCase(id);

    result.fold(
      (failure) {
        String message = 'Unexpected Error';
        if (failure is ServerFailure) {
          message = failure.message;
        } else if (failure is NetworkFailure) {
          message = failure.message;
        }
        emit(FinanceAccountDetailsError(message));
      },
      (account) {
        emit(FinanceAccountDetailsSuccess(account));
      },
    );
  }
}
