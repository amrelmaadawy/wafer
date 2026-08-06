import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/update_finance_receipt_use_case.dart';
import 'update_finance_receipt_state.dart';

class UpdateFinanceReceiptCubit extends Cubit<UpdateFinanceReceiptState> {
  final UpdateFinanceReceiptUseCase updateFinanceReceiptUseCase;

  UpdateFinanceReceiptCubit({required this.updateFinanceReceiptUseCase})
      : super(UpdateFinanceReceiptInitial());

  Future<void> updateReceipt({
    required int receiptId,
    required num amount,
    required String receiptDate,
    String? notes,
  }) async {
    emit(UpdateFinanceReceiptLoading());

    final result = await updateFinanceReceiptUseCase(
      UpdateFinanceReceiptParams(
        receiptId: receiptId,
        amount: amount,
        receiptDate: receiptDate,
        notes: notes,
      ),
    );

    result.fold(
      (failure) => emit(UpdateFinanceReceiptError(failure.message)),
      (receipt) => emit(UpdateFinanceReceiptSuccess(
        receipt: receipt,
        message: 'تم تحديث السند بنجاح',
      )),
    );
  }
}
