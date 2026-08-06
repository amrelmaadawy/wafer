import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_finance_receipt_details_use_case.dart';
import 'finance_receipt_details_state.dart';

class FinanceReceiptDetailsCubit extends Cubit<FinanceReceiptDetailsState> {
  final GetFinanceReceiptDetailsUseCase getFinanceReceiptDetailsUseCase;

  FinanceReceiptDetailsCubit({required this.getFinanceReceiptDetailsUseCase})
      : super(FinanceReceiptDetailsInitial());

  Future<void> fetchReceiptDetails(int receiptId) async {
    emit(FinanceReceiptDetailsLoading());

    final result = await getFinanceReceiptDetailsUseCase(
      GetFinanceReceiptDetailsParams(receiptId: receiptId),
    );

    result.fold(
      (failure) => emit(FinanceReceiptDetailsError(failure.message)),
      (receipt) => emit(FinanceReceiptDetailsSuccess(receipt)),
    );
  }
}
