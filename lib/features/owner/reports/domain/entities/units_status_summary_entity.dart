import 'package:equatable/equatable.dart';

class UnitsStatusSummaryEntity extends Equatable {
  final int total;
  final int vacant;
  final int rented;
  final int maintenance;

  const UnitsStatusSummaryEntity({
    required this.total,
    required this.vacant,
    required this.rented,
    required this.maintenance,
  });

  @override
  List<Object?> get props => [total, vacant, rented, maintenance];
}
