import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/business_rules/payment_business_rules.dart';
import '../../../domain/usecases/cancel_finance_payment_use_case.dart';
import 'cancel_finance_payment_state.dart';

class CancelFinancePaymentCubit extends Cubit<CancelFinancePaymentState> {
  final CancelFinancePaymentUseCase cancelFinancePaymentUseCase;

  CancelFinancePaymentCubit({required this.cancelFinancePaymentUseCase})
      : super(CancelFinancePaymentInitial());

  Future<void> cancelPayment(
    int paymentId,
    String reason, {
    String? currentStatus,
  }) async {
    if (currentStatus != null) {
      final violation = PaymentBusinessRules.validateTransition(currentStatus, 'cancelled');
      if (violation != null) {
        if (!isClosed) emit(CancelFinancePaymentError(message: violation.messageKey.tr()));
        return;
      }
    }

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
