import 'package:equatable/equatable.dart';

class StatementSummaryEntity extends Equatable {
  final num openingBalance;
  final num totalDebit;
  final num totalCredit;
  final num currentBalance;

  const StatementSummaryEntity({
    required this.openingBalance,
    required this.totalDebit,
    required this.totalCredit,
    required this.currentBalance,
  });

  @override
  List<Object?> get props => [
        openingBalance,
        totalDebit,
        totalCredit,
        currentBalance,
      ];
}
