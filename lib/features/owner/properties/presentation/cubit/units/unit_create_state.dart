import 'package:equatable/equatable.dart';

class UnitCreateState extends Equatable {
  final int? draftUnitId;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final bool isPublished;

  const UnitCreateState({
    this.draftUnitId,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.isPublished = false,
  });

  UnitCreateState copyWith({
    int? draftUnitId,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool? isPublished,
  }) {
    return UnitCreateState(
      draftUnitId: draftUnitId ?? this.draftUnitId,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  @override
  List<Object?> get props => [
        draftUnitId,
        isLoading,
        isSaving,
        errorMessage,
        isPublished,
      ];
}
