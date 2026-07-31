import 'package:equatable/equatable.dart';
import '../../domain/entities/technician_form_data_entity.dart';

abstract class TechnicianFormDataState extends Equatable {
  const TechnicianFormDataState();

  @override
  List<Object?> get props => [];
}

class TechnicianFormDataInitial extends TechnicianFormDataState {}

class TechnicianFormDataLoading extends TechnicianFormDataState {}

class TechnicianFormDataSuccess extends TechnicianFormDataState {
  final TechnicianFormDataEntity data;

  const TechnicianFormDataSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class TechnicianFormDataError extends TechnicianFormDataState {
  final String message;

  const TechnicianFormDataError(this.message);

  @override
  List<Object?> get props => [message];
}
