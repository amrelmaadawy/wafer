import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.g.dart';
import 'package:wafer/features/owner/finance/domain/usecases/update_finance_payment_use_case.dart';
import 'update_finance_payment_state.dart';

class UpdateFinancePaymentCubit extends Cubit<UpdateFinancePaymentState> {
  final UpdateFinancePaymentUseCase updateFinancePaymentUseCase;

  UpdateFinancePaymentCubit({required this.updateFinancePaymentUseCase})
      : super(UpdateFinancePaymentInitial());

  Future<void> updatePayment({
    required int paymentId,
    required num amount,
    required String paymentDate,
    String? notes,
  }) async {
    emit(UpdateFinancePaymentLoading());
    final result = await updateFinancePaymentUseCase(
      UpdateFinancePaymentParams(
        paymentId: paymentId,
        amount: amount,
        paymentDate: paymentDate,
        notes: notes,
      ),
    );

    result.fold(
      (failure) => emit(UpdateFinancePaymentError(failure.message)),
      (payment) => emit(UpdateFinancePaymentSuccess(
        payment: payment,
        message: LocaleKeys.owner_finance_update_payment_success.tr(),
      )),
    );
  }
}
