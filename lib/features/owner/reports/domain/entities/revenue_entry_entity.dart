import 'package:equatable/equatable.dart';

class RevenueEntryEntity extends Equatable {
  final String month;
  final double expected;
  final double collected;

  const RevenueEntryEntity({
    required this.month,
    required this.expected,
    required this.collected,
  });

  double get overdue => (expected - collected).clamp(0, double.infinity);
  double get collectionRate => expected > 0 ? collected / expected : 0.0;

  @override
  List<Object?> get props => [month, expected, collected];
}
