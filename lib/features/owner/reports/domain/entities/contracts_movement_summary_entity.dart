import 'package:equatable/equatable.dart';

class ContractsMovementSummaryEntity extends Equatable {
  final int totalMovements;
  final int creations;
  final int renewals;
  final int terminations;

  const ContractsMovementSummaryEntity({
    required this.totalMovements,
    required this.creations,
    required this.renewals,
    required this.terminations,
  });

  @override
  List<Object?> get props => [
    totalMovements,
    creations,
    renewals,
    terminations,
  ];
}
