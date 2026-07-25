import 'package:equatable/equatable.dart';

abstract class DeletePropertyState extends Equatable {
  const DeletePropertyState();

  @override
  List<Object> get props => [];
}

class DeletePropertyInitial extends DeletePropertyState {
  const DeletePropertyInitial();
}

class DeletePropertyLoading extends DeletePropertyState {
  const DeletePropertyLoading();
}

class DeletePropertySuccess extends DeletePropertyState {
  const DeletePropertySuccess();
}

class DeletePropertyError extends DeletePropertyState {
  final String message;

  const DeletePropertyError(this.message);

  @override
  List<Object> get props => [message];
}
