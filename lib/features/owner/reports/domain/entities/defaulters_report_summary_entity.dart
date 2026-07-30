import 'package:equatable/equatable.dart';

class DefaultersReportSummaryEntity extends Equatable {
  final int totalInstallments;
  final double totalAmount;
  final double totalPaid;
  final double totalRemaining;

  const DefaultersReportSummaryEntity({
    required this.totalInstallments,
    required this.totalAmount,
    required this.totalPaid,
    required this.totalRemaining,
  });

  @override
  List<Object?> get props => [
    totalInstallments,
    totalAmount,
    totalPaid,
    totalRemaining,
  ];
}
