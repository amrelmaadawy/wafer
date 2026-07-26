import 'package:equatable/equatable.dart';

class RevenueEntryEntity extends Equatable {
  final String month;
  final double expected;
  final double collected;
  final double remaining;
  final double collectionRate;

  const RevenueEntryEntity({
    required this.month,
    required this.expected,
    required this.collected,
    required this.remaining,
    required this.collectionRate,
  });

  @override
  List<Object?> get props => [month, expected, collected, remaining, collectionRate];
}
