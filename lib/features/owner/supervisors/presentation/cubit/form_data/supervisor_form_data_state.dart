import 'package:equatable/equatable.dart';
import '../../../domain/entities/supervisor_form_data_entity.dart';

abstract class SupervisorFormDataState extends Equatable {
  const SupervisorFormDataState();

  @override
  List<Object?> get props => [];
}

class SupervisorFormDataInitial extends SupervisorFormDataState {}

class SupervisorFormDataLoading extends SupervisorFormDataState {}

class SupervisorFormDataSuccess extends SupervisorFormDataState {
  final SupervisorFormDataEntity data;

  const SupervisorFormDataSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class SupervisorFormDataError extends SupervisorFormDataState {
  final String message;

  const SupervisorFormDataError(this.message);

  @override
  List<Object?> get props => [message];
}
