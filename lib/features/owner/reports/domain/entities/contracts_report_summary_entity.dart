import 'package:equatable/equatable.dart';

class ContractsReportSummaryEntity extends Equatable {
  final int totalExpiring;
  final double totalRentValue;
  final int days;

  const ContractsReportSummaryEntity({
    required this.totalExpiring,
    required this.totalRentValue,
    required this.days,
  });

  @override
  List<Object?> get props => [
        totalExpiring,
        totalRentValue,
        days,
      ];
}
