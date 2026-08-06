import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/cancel_finance_receipt_use_case.dart';
import 'cancel_finance_receipt_state.dart';

class CancelFinanceReceiptCubit extends Cubit<CancelFinanceReceiptState> {
  final CancelFinanceReceiptUseCase cancelFinanceReceiptUseCase;

  CancelFinanceReceiptCubit({required this.cancelFinanceReceiptUseCase})
      : super(CancelFinanceReceiptInitial());

  Future<void> cancelReceipt(int receiptId, String reason) async {
    emit(CancelFinanceReceiptLoading());

    final result = await cancelFinanceReceiptUseCase(
      CancelFinanceReceiptParams(receiptId: receiptId, reason: reason),
    );

    result.fold(
      (failure) => emit(CancelFinanceReceiptError(failure.message)),
      (receipt) => emit(CancelFinanceReceiptSuccess(receipt)),
    );
  }
}
