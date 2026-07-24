import 'package:equatable/equatable.dart';
import '../../../domain/entities/property_details_entity.dart';

abstract class PublishPropertyState extends Equatable {
  const PublishPropertyState();

  @override
  List<Object?> get props => [];
}

class PublishPropertyInitial extends PublishPropertyState {
  const PublishPropertyInitial();
}

class PublishPropertyLoading extends PublishPropertyState {
  const PublishPropertyLoading();
}

class PublishPropertySuccess extends PublishPropertyState {
  final PropertyDetailsEntity property;

  const PublishPropertySuccess(this.property);

  @override
  List<Object?> get props => [property];
}

class PublishPropertyError extends PublishPropertyState {
  final String message;

  const PublishPropertyError(this.message);

  @override
  List<Object?> get props => [message];
}
