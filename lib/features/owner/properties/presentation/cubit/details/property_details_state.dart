import 'package:equatable/equatable.dart';
import '../../../domain/entities/property_details_entity.dart';

abstract class PropertyDetailsState extends Equatable {
  const PropertyDetailsState();

  @override
  List<Object?> get props => [];
}

class PropertyDetailsInitial extends PropertyDetailsState {
  const PropertyDetailsInitial();
}

class PropertyDetailsLoading extends PropertyDetailsState {
  const PropertyDetailsLoading();
}

class PropertyDetailsLoaded extends PropertyDetailsState {
  final PropertyDetailsEntity property;
  final bool isMakingRepresentative;
  final bool isRemovingRepresentative;
  final int? actionOwnerId;

  const PropertyDetailsLoaded(
    this.property, {
    this.isMakingRepresentative = false,
    this.isRemovingRepresentative = false,
    this.actionOwnerId,
  });

  PropertyDetailsLoaded copyWith({
    PropertyDetailsEntity? property,
    bool? isMakingRepresentative,
    bool? isRemovingRepresentative,
    int? actionOwnerId,
  }) {
    return PropertyDetailsLoaded(
      property ?? this.property,
      isMakingRepresentative: isMakingRepresentative ?? this.isMakingRepresentative,
      isRemovingRepresentative: isRemovingRepresentative ?? this.isRemovingRepresentative,
      actionOwnerId: actionOwnerId ?? this.actionOwnerId,
    );
  }

  @override
  List<Object?> get props => [property, isMakingRepresentative, isRemovingRepresentative, actionOwnerId];
}

class PropertyDetailsError extends PropertyDetailsState {
  final String message;

  const PropertyDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
