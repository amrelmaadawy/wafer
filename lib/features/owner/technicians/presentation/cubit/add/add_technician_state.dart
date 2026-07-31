import 'package:equatable/equatable.dart';
import '../../../domain/entities/technician_entity.dart';

abstract class AddTechnicianState extends Equatable {
  const AddTechnicianState();

  @override
  List<Object?> get props => [];
}

class AddTechnicianInitial extends AddTechnicianState {}

class AddTechnicianLoading extends AddTechnicianState {}

class AddTechnicianSuccess extends AddTechnicianState {
  final TechnicianEntity technician;

  const AddTechnicianSuccess(this.technician);

  @override
  List<Object?> get props => [technician];
}

class AddTechnicianFailure extends AddTechnicianState {
  final String errorMessage;

  const AddTechnicianFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
