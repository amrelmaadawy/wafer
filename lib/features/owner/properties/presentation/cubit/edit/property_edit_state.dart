import 'package:equatable/equatable.dart';

class PropertyEditState extends Equatable {
  final bool isSaving;
  final bool isSuccess;
  final String? errorMessage;

  const PropertyEditState({
    this.isSaving = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  PropertyEditState copyWith({
    bool? isSaving,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return PropertyEditState(
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isSaving, isSuccess, errorMessage];
}
