import 'package:equatable/equatable.dart';
import '../../domain/entities/defaulter_entity.dart';

abstract class OwnerDefaultersState extends Equatable {
  const OwnerDefaultersState();

  @override
  List<Object?> get props => [];
}

class OwnerDefaultersInitial extends OwnerDefaultersState {
  const OwnerDefaultersInitial();
}

class OwnerDefaultersLoading extends OwnerDefaultersState {
  const OwnerDefaultersLoading();
}

class OwnerDefaultersLoaded extends OwnerDefaultersState {
  final List<DefaulterEntity> defaulters;
  final double totalOverdueAmount;
  final int totalDefaultersCount;

  const OwnerDefaultersLoaded({
    required this.defaulters,
    required this.totalOverdueAmount,
    required this.totalDefaultersCount,
  });

  @override
  List<Object?> get props => [
        defaulters,
        totalOverdueAmount,
        totalDefaultersCount,
      ];
}

class OwnerDefaultersEmpty extends OwnerDefaultersState {
  const OwnerDefaultersEmpty();
}

class OwnerDefaultersError extends OwnerDefaultersState {
  final String message;

  const OwnerDefaultersError(this.message);

  @override
  List<Object?> get props => [message];
}
