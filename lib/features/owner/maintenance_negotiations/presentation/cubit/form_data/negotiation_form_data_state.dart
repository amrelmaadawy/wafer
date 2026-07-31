import 'package:equatable/equatable.dart';
import '../../../domain/entities/negotiation_form_data_entity.dart';

enum NegotiationFormDataStatus { initial, loading, success, failure }

class NegotiationFormDataState extends Equatable {
  final NegotiationFormDataStatus status;
  final NegotiationFormDataEntity? formData;
  final String? errorMessage;

  const NegotiationFormDataState({
    this.status = NegotiationFormDataStatus.initial,
    this.formData,
    this.errorMessage,
  });

  NegotiationFormDataState copyWith({
    NegotiationFormDataStatus? status,
    NegotiationFormDataEntity? formData,
    String? errorMessage,
  }) {
    return NegotiationFormDataState(
      status: status ?? this.status,
      formData: formData ?? this.formData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, formData, errorMessage];
}
