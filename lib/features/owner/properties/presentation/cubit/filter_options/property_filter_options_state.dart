import 'package:equatable/equatable.dart';
import '../../../domain/entities/property_form_options_entity.dart';

sealed class PropertyFilterOptionsState extends Equatable {
  const PropertyFilterOptionsState();

  @override
  List<Object?> get props => [];
}

class PropertyFilterOptionsInitial extends PropertyFilterOptionsState {
  const PropertyFilterOptionsInitial();
}

class PropertyFilterOptionsLoading extends PropertyFilterOptionsState {
  const PropertyFilterOptionsLoading();
}

class PropertyFilterOptionsLoaded extends PropertyFilterOptionsState {
  final PropertyFormOptionsEntity options;

  const PropertyFilterOptionsLoaded(this.options);

  @override
  List<Object?> get props => [options];
}

class PropertyFilterOptionsError extends PropertyFilterOptionsState {
  final String message;

  const PropertyFilterOptionsError(this.message);

  @override
  List<Object?> get props => [message];
}
