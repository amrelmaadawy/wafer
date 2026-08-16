import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/receivable_entity.dart';
import '../../../domain/usecases/get_receivables_use_case.dart';
import 'receivables_state.dart';

class ReceivablesCubit extends Cubit<ReceivablesState> {
  final GetReceivablesUseCase getReceivablesUseCase;
  List<ReceivableEntity> _allReceivables = [];

  ReceivablesCubit({required this.getReceivablesUseCase})
      : super(ReceivablesInitial());

  Future<void> loadReceivables({String? status, int? propertyId}) async {
    emit(ReceivablesLoading());

    final result = await getReceivablesUseCase(
      status: status,
      propertyId: propertyId,
    );

    result.fold(
      (failure) => emit(ReceivablesError(message: failure.message)),
      (receivables) {
        _allReceivables = _sortReceivables(receivables);
        if (_allReceivables.isEmpty) {
          emit(const ReceivablesEmpty());
        } else {
          _emitLoadedState(activeStatus: status ?? 'all');
        }
      },
    );
  }

  void filterByStatus(String status) {
    if (_allReceivables.isEmpty) return;
    _emitLoadedState(activeStatus: status);
  }

  List<ReceivableEntity> _sortReceivables(List<ReceivableEntity> list) {
    final copy = List<ReceivableEntity>.from(list);
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
      case 'partial':
        return 1;
      case 'pending':
        return 2;
      case 'paid':
        return 3;
      default:
        return 4;
    }
  }

  void _emitLoadedState({required String activeStatus}) {
    List<ReceivableEntity> filtered = _allReceivables;
    if (activeStatus != 'all') {
      filtered = _allReceivables
          .where((r) => r.status.toLowerCase() == activeStatus.toLowerCase())
          .toList();
    }

    final totalAmount = _allReceivables.fold<num>(0, (sum, r) => sum + r.totalAmount);
    final totalPaid = _allReceivables.fold<num>(0, (sum, r) => sum + r.paidAmount);
    final totalRemaining = _allReceivables.fold<num>(0, (sum, r) => sum + r.remainingAmount);
    final overdueCount = _allReceivables.where((r) => r.status.toLowerCase() == 'overdue').length;
    final collectionRate = totalAmount > 0 ? (totalPaid / totalAmount) * 100 : 0.0;

    emit(ReceivablesLoaded(
      receivables: filtered,
      allReceivables: _allReceivables,
      activeStatus: activeStatus,
      totalAmount: totalAmount,
      totalPaid: totalPaid,
      totalRemaining: totalRemaining,
      collectionRate: collectionRate,
      overdueCount: overdueCount,
    ));
  }
}
