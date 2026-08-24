import 'package:equatable/equatable.dart';

class StatementPeriodEntity extends Equatable {
  final String startDate;
  final String endDate;
  final String transactionType;

  const StatementPeriodEntity({
    required this.startDate,
    required this.endDate,
    required this.transactionType,
  });

  @override
  List<Object?> get props => [startDate, endDate, transactionType];
}
