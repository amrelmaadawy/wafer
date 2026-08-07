import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/features/owner/finance/domain/usecases/cancel_finance_payment_use_case.dart';
import 'cancel_finance_payment_state.dart';

class CancelFinancePaymentCubit extends Cubit<CancelFinancePaymentState> {
  final CancelFinancePaymentUseCase cancelFinancePaymentUseCase;

  CancelFinancePaymentCubit({required this.cancelFinancePaymentUseCase})
      : super(CancelFinancePaymentInitial());

  Future<void> cancelPayment(int paymentId, String reason) async {
    emit(CancelFinancePaymentLoading());

    final result = await cancelFinancePaymentUseCase(paymentId, reason);

    result.fold(
      (failure) {
        if (!isClosed) emit(CancelFinancePaymentError(message: failure.message));
      },
      (_) {
        if (!isClosed) emit(CancelFinancePaymentSuccess());
      },
    );
  }
}
