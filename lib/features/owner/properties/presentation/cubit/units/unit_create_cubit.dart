import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auto_save_unit_use_case.dart';
import '../../../domain/usecases/create_draft_unit_use_case.dart';
import '../../../domain/usecases/publish_unit_use_case.dart';
import 'unit_create_state.dart';

class UnitCreateCubit extends Cubit<UnitCreateState> {
  final CreateDraftUnitUseCase _createDraftUnit;
  final AutoSaveUnitUseCase _autoSaveUnit;
  final PublishUnitUseCase _publishUnit;

  UnitCreateCubit({
    required CreateDraftUnitUseCase createDraftUnit,
    required AutoSaveUnitUseCase autoSaveUnit,
    required PublishUnitUseCase publishUnit,
  })  : _createDraftUnit = createDraftUnit,
        _autoSaveUnit = autoSaveUnit,
        _publishUnit = publishUnit,
        super(const UnitCreateState());

  Future<void> initDraftUnit(int propertyId) async {
    emit(state.copyWith(isLoading: true));
    final result = await _createDraftUnit(propertyId);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (unitId) => emit(state.copyWith(isLoading: false, draftUnitId: unitId)),
    );
  }

  Future<bool> saveAndPublish({
    required int propertyId,
    required String unitNumber,
    String? floor,
    num? area,
    String? type,
    required num rentPrice,
    num? deposit,
    String? specs,
  }) async {
    if (state.draftUnitId == null) return false;
    emit(state.copyWith(isSaving: true));

    final saveResult = await _autoSaveUnit(
      propertyId: propertyId,
      unitId: state.draftUnitId!,
      data: {
        'unit_number': unitNumber,
        'rent_price': rentPrice,
        'floor': floor,
        'area': area,
        'type': type,
        'deposit': deposit,
        'specs': specs,
      }..removeWhere((key, value) => value == null),
    );

    return saveResult.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return false;
      },
      (_) async {
        final publishResult = await _publishUnit(
          propertyId: propertyId,
          unitId: state.draftUnitId!,
        );
        return publishResult.fold(
          (failure) {
            emit(state.copyWith(isSaving: false, errorMessage: failure.message));
            return false;
          },
          (_) {
            emit(state.copyWith(isSaving: false, isPublished: true));
            return true;
          },
        );
      },
    );
  }
}
