import 'package:equatable/equatable.dart';

abstract class UnreadCountState extends Equatable {
  const UnreadCountState();

  @override
  List<Object?> get props => [];
}

class UnreadCountInitial extends UnreadCountState {
  const UnreadCountInitial();
}

class UnreadCountLoading extends UnreadCountState {
  const UnreadCountLoading();
}

class UnreadCountLoaded extends UnreadCountState {
  final int count;

  const UnreadCountLoaded(this.count);

  @override
  List<Object?> get props => [count];
}

class UnreadCountError extends UnreadCountState {
  final String message;

  const UnreadCountError(this.message);

  @override
  List<Object?> get props => [message];
}
