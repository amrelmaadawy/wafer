import 'package:equatable/equatable.dart';
import '../../domain/entities/occupancy_property_entity.dart';

abstract class OwnerOccupancyState extends Equatable {
  const OwnerOccupancyState();

  @override
  List<Object?> get props => [];
}

class OwnerOccupancyInitial extends OwnerOccupancyState {
  const OwnerOccupancyInitial();
}

class OwnerOccupancyLoading extends OwnerOccupancyState {
  const OwnerOccupancyLoading();
}

class OwnerOccupancyLoaded extends OwnerOccupancyState {
  final List<OccupancyPropertyEntity> properties;
  final double overallRate;
  final int totalUnits;
  final int totalRented;
  final int totalVacant;

  const OwnerOccupancyLoaded({
    required this.properties,
    required this.overallRate,
    required this.totalUnits,
    required this.totalRented,
    required this.totalVacant,
  });

  @override
  List<Object?> get props => [
        properties,
        overallRate,
        totalUnits,
        totalRented,
        totalVacant,
      ];
}

class OwnerOccupancyEmpty extends OwnerOccupancyState {
  const OwnerOccupancyEmpty();
}

class OwnerOccupancyError extends OwnerOccupancyState {
  final String message;

  const OwnerOccupancyError(this.message);

  @override
  List<Object?> get props => [message];
}
