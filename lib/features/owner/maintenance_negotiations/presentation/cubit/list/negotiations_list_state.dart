import 'package:equatable/equatable.dart';
import '../../../domain/entities/negotiation_form_data_entity.dart';

enum NegotiationsListStatus { initial, loading, success, failure }

class NegotiationsListState extends Equatable {
  final NegotiationsListStatus status;
  final List<NegotiationEntity> negotiations;
  final String? errorMessage;
  final bool hasReachedMax;

  const NegotiationsListState({
    this.status = NegotiationsListStatus.initial,
    this.negotiations = const [],
    this.errorMessage,
    this.hasReachedMax = false,
  });

  NegotiationsListState copyWith({
    NegotiationsListStatus? status,
    List<NegotiationEntity>? negotiations,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return NegotiationsListState(
      status: status ?? this.status,
      negotiations: negotiations ?? this.negotiations,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, negotiations, errorMessage, hasReachedMax];
}
