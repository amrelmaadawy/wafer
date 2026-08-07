import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_finance_payment_details_use_case.dart';
import 'finance_payment_details_state.dart';

class FinancePaymentDetailsCubit extends Cubit<FinancePaymentDetailsState> {
  final GetFinancePaymentDetailsUseCase getPaymentDetailsUseCase;

  FinancePaymentDetailsCubit({required this.getPaymentDetailsUseCase})
      : super(FinancePaymentDetailsInitial());

  Future<void> fetchPaymentDetails(int paymentId) async {
    emit(FinancePaymentDetailsLoading());

    final result = await getPaymentDetailsUseCase(paymentId);

    result.fold(
      (failure) {
        if (!isClosed) emit(FinancePaymentDetailsError(message: failure.message));
      },
      (payment) {
        if (!isClosed) emit(FinancePaymentDetailsSuccess(payment: payment));
      },
    );
  }
}
