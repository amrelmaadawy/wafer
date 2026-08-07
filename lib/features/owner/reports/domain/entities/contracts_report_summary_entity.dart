import 'package:equatable/equatable.dart';

class ContractsReportSummaryEntity extends Equatable {
  final int total;
  final int active;
  final int expired;
  final int expiringNext30Days;
  final double totalRentValue;

  const ContractsReportSummaryEntity({
    required this.total,
    required this.active,
    required this.expired,
    required this.expiringNext30Days,
    required this.totalRentValue,
  });

  @override
  List<Object?> get props => [
    total,
    active,
    expired,
    expiringNext30Days,
    totalRentValue,
  ];
}
