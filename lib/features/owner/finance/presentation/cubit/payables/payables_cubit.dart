import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/payable_entity.dart';
import '../../../domain/usecases/get_payables_use_case.dart';
import 'payables_state.dart';

class PayablesCubit extends Cubit<PayablesState> {
  final GetPayablesUseCase getPayablesUseCase;
  List<PayableEntity> _allPayables = [];

  PayablesCubit({required this.getPayablesUseCase})
      : super(PayablesInitial());

  Future<void> loadPayables({String? status, int? propertyId}) async {
    emit(PayablesLoading());

    final result = await getPayablesUseCase(
      status: status,
      propertyId: propertyId,
    );

    result.fold(
      (failure) => emit(PayablesError(message: failure.message)),
      (payables) {
        _allPayables = _sortPayables(payables);
        if (_allPayables.isEmpty) {
          emit(const PayablesEmpty());
        } else {
          _emitLoadedState(activeStatus: status ?? 'all');
        }
      },
    );
  }

  void filterByStatus(String status) {
    if (_allPayables.isEmpty) return;
    _emitLoadedState(activeStatus: status);
  }

  List<PayableEntity> _sortPayables(List<PayableEntity> list) {
    final copy = List<PayableEntity>.from(list);
    copy.sort((a, b) {
      final pA = _statusPriority(a.status);
      final pB = _statusPriority(b.status);
      if (pA != pB) return pA.compareTo(pB);
      return b.remainingAmount.compareTo(a.remainingAmount);
    });
    return copy;
  }

  int _statusPriority(String status) {
    switch (status.toLowerCase()) {
      case 'overdue':
        return 0;
      case 'pending':
        return 1;
      case 'partial':
        return 2;
      case 'paid':
        return 3;
      default:
        return 4;
    }
  }

  void _emitLoadedState({required String activeStatus}) {
    List<PayableEntity> filtered = _allPayables;
    if (activeStatus != 'all') {
      filtered = _allPayables
          .where((p) => p.status.toLowerCase() == activeStatus.toLowerCase())
          .toList();
    }

    final totalAmount = _allPayables.fold<num>(0, (sum, p) => sum + p.totalAmount);
    final totalPaid = _allPayables.fold<num>(0, (sum, p) => sum + p.paidAmount);
    final totalRemaining = _allPayables.fold<num>(0, (sum, p) => sum + p.remainingAmount);
    final overdueCount = _allPayables.where((p) => p.status.toLowerCase() == 'overdue').length;
    final paymentRate = totalAmount > 0 ? (totalPaid / totalAmount) * 100 : 0.0;

    emit(PayablesLoaded(
      payables: filtered,
      allPayables: _allPayables,
      activeStatus: activeStatus,
      totalAmount: totalAmount,
      totalPaid: totalPaid,
      totalRemaining: totalRemaining,
      paymentRate: paymentRate,
      overdueCount: overdueCount,
    ));
  }
}
