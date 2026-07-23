import 'package:equatable/equatable.dart';
import '../../../../properties/domain/entities/form_branch_entity.dart';

abstract class CreateDeedState extends Equatable {
  const CreateDeedState();

  @override
  List<Object> get props => [];
}

class CreateDeedInitial extends CreateDeedState {
  const CreateDeedInitial();
}

class FormOptionsLoaded extends CreateDeedState {
  final List<FormBranchEntity> branches;
  const FormOptionsLoaded(this.branches);

  @override
  List<Object> get props => [branches];
}

class CreateDeedLoading extends CreateDeedState {
  const CreateDeedLoading();
}

class CreateDeedSuccess extends CreateDeedState {
  const CreateDeedSuccess();
}

class CreateDeedError extends CreateDeedState {
  final String message;

  const CreateDeedError(this.message);

  @override
  List<Object> get props => [message];
}
