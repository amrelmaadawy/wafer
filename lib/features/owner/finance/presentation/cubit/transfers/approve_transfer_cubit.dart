import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import '../../../domain/usecases/approve_transfer_use_case.dart';
import 'approve_transfer_state.dart';

class ApproveTransferCubit extends Cubit<ApproveTransferState> {
  final ApproveTransferUseCase approveTransferUseCase;

  ApproveTransferCubit({required this.approveTransferUseCase}) : super(ApproveTransferInitial());

  Future<void> approveTransfer(int transferId) async {
    emit(ApproveTransferLoading());
    final result = await approveTransferUseCase(transferId);
    
    result.fold(
      (failure) => emit(ApproveTransferError(failure.message)),
      (transfer) => emit(ApproveTransferSuccess(
        transfer: transfer,
        message: LocaleKeys.common_success.tr(), // Will add a specific key for approval success later
      )),
    );
  }
}
