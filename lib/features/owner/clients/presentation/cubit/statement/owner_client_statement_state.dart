import 'package:equatable/equatable.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/entities/client_statement_response_entity.dart';

abstract class OwnerClientStatementState extends Equatable {
  const OwnerClientStatementState();

  @override
  List<Object?> get props => [];
}

class OwnerClientStatementInitial extends OwnerClientStatementState {}

class OwnerClientStatementLoading extends OwnerClientStatementState {}

class OwnerClientStatementLoaded extends OwnerClientStatementState {
  final ClientStatementResponseEntity statementResponse;
  
  // Keep track of the current filters to show active states
  final String? startDate;
  final String? endDate;
  final String? transactionType;

  const OwnerClientStatementLoaded({
    required this.statementResponse,
    this.startDate,
    this.endDate,
    this.transactionType,
  });

  @override
  List<Object?> get props => [
        statementResponse,
        startDate,
        endDate,
        transactionType,
      ];
}

class OwnerClientStatementError extends OwnerClientStatementState {
  final Failure failure;

  const OwnerClientStatementError(this.failure);

  @override
  List<Object?> get props => [failure];
}
