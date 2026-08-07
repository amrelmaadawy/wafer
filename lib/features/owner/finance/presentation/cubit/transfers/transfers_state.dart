part of 'transfers_cubit.dart';

abstract class TransfersState extends Equatable {
  const TransfersState();

  @override
  List<Object?> get props => [];
}

class TransfersInitial extends TransfersState {}

class TransfersLoading extends TransfersState {}

class TransfersLoaded extends TransfersState {
  final List<TransferEntity> transfers;
  final bool hasReachedMax;

  const TransfersLoaded({required this.transfers, required this.hasReachedMax});

  @override
  List<Object?> get props => [transfers, hasReachedMax];
}

class TransfersLoadingMore extends TransfersState {
  final List<TransferEntity> transfers;
  final bool hasReachedMax;

  const TransfersLoadingMore({required this.transfers, required this.hasReachedMax});

  @override
  List<Object?> get props => [transfers, hasReachedMax];
}

class TransfersEmpty extends TransfersState {}

class TransfersError extends TransfersState {
  final String message;
  final List<TransferEntity> transfers;

  const TransfersError({required this.message, this.transfers = const []});

  @override
  List<Object?> get props => [message, transfers];
}
