import 'package:equatable/equatable.dart';
import '../../domain/entities/revenue_entry_entity.dart';

abstract class OwnerRevenueState extends Equatable {
  const OwnerRevenueState();

  @override
  List<Object?> get props => [];
}

class OwnerRevenueInitial extends OwnerRevenueState {
  const OwnerRevenueInitial();
}

class OwnerRevenueLoading extends OwnerRevenueState {
  const OwnerRevenueLoading();
}

class OwnerRevenueLoaded extends OwnerRevenueState {
  final List<RevenueEntryEntity> entries;
  final double totalExpected;
  final double totalCollected;
  final double collectionRate;

  const OwnerRevenueLoaded({
    required this.entries,
    required this.totalExpected,
    required this.totalCollected,
    required this.collectionRate,
  });

  @override
  List<Object?> get props =>
      [entries, totalExpected, totalCollected, collectionRate];
}

class OwnerRevenueEmpty extends OwnerRevenueState {
  const OwnerRevenueEmpty();
}

class OwnerRevenueError extends OwnerRevenueState {
  final String message;

  const OwnerRevenueError(this.message);

  @override
  List<Object?> get props => [message];
}
