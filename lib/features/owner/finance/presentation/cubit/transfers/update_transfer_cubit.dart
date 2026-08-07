import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import '../../../domain/usecases/update_transfer_use_case.dart';
import 'update_transfer_state.dart';

class UpdateTransferCubit extends Cubit<UpdateTransferState> {
  final UpdateTransferUseCase updateTransferUseCase;

  UpdateTransferCubit({required this.updateTransferUseCase}) : super(UpdateTransferInitial());

  Future<void> updateTransfer(UpdateTransferParams params) async {
    emit(UpdateTransferLoading());
    final result = await updateTransferUseCase(params);
    
    result.fold(
      (failure) => emit(UpdateTransferError(failure.message)),
      (transfer) => emit(UpdateTransferSuccess(
        transfer: transfer,
        message: LocaleKeys.owner_finance_transfer_success.tr(), // We can add an update translation key if needed, or reuse this
      )),
    );
  }
}
