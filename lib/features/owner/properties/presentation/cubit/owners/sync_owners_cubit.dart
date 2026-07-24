import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/form_owner_entity.dart';
import '../../../domain/entities/property_owner_entity.dart';
import '../../../domain/usecases/get_property_form_data_use_case.dart';
import '../../../domain/usecases/sync_owners_use_case.dart';
import 'sync_owners_state.dart';

class SyncOwnersCubit extends Cubit<SyncOwnersState> {
  final SyncOwnersUseCase _syncOwnersUseCase;
  final GetPropertyFormDataUseCase _getFormDataUseCase;

  SyncOwnersCubit(this._syncOwnersUseCase, this._getFormDataUseCase)
      : super(const SyncOwnersState());

  Future<void> loadOwnersFromApi({
    required List<PropertyOwnerEntity> currentOwners,
  }) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getFormDataUseCase(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, errorMessage: f.message)),
      (formData) {
        emit(SyncOwnersState.fromCurrentOwners(
          availableOwners: formData.options.owners,
          currentOwners: currentOwners,
        ));
      },
    );
  }

  bool addOwner(FormOwnerEntity owner) {
    final alreadyAdded = state.assignedOwners.any((e) => e.owner.id == owner.id);
    if (alreadyAdded) return false;

    final updated = [...state.assignedOwners, DraftOwnerEntry(owner: owner)];
    emit(state.copyWith(assignedOwners: updated, clearError: true));
    return true;
  }

  void removeOwner(int ownerId) {
    final updated = state.assignedOwners
        .where((e) => e.owner.id != ownerId)
        .toList();
    emit(state.copyWith(assignedOwners: updated));
  }

  void updatePercentage(int ownerId, double percentage) {
    final updated = state.assignedOwners.map((e) {
      if (e.owner.id == ownerId) {
        return e.copyWith(percentage: percentage.clamp(0.0, 100.0));
      }
      return e;
    }).toList();
    emit(state.copyWith(assignedOwners: updated, clearError: true));
  }

  void setRepresentative(int ownerId) {
    final updated = state.assignedOwners.map((e) {
      return e.copyWith(isRepresentative: e.owner.id == ownerId);
    }).toList();
    emit(state.copyWith(assignedOwners: updated));
  }

  void autoDistribute() {
    if (state.assignedOwners.isEmpty) return;
    final perOwner = (100.0 / state.assignedOwners.length);
    final updated = state.assignedOwners
        .asMap()
        .entries
        .map((entry) {
          final isLast = entry.key == state.assignedOwners.length - 1;
          // Last owner gets the remainder to avoid float rounding issues
          final pct = isLast
              ? 100.0 - perOwner * (state.assignedOwners.length - 1)
              : perOwner;
          return entry.value.copyWith(percentage: double.parse(pct.toStringAsFixed(2)));
        })
        .toList();
    emit(state.copyWith(assignedOwners: updated, clearError: true));
  }

  Future<bool> syncOwners(int propertyId) async {
    if (!state.isValid) return false;
    if (state.assignedOwners.isEmpty) return false;

    // Auto-assign representative if none selected
    List<DraftOwnerEntry> owners = state.assignedOwners;
    if (!state.hasRepresentative) {
      owners = state.assignedOwners.asMap().entries.map((entry) {
        return entry.value.copyWith(isRepresentative: entry.key == 0);
      }).toList();
    }

    emit(state.copyWith(isSyncing: true, clearError: true));

    final payload = owners.map((e) => {
      'id': e.owner.id,
      'percentage': e.percentage,
      'is_representative': e.isRepresentative,
    }).toList();

    final result = await _syncOwnersUseCase(propertyId, payload);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSyncing: false, errorMessage: failure.message));
        return false;
      },
      (_) {
        emit(state.copyWith(isSyncing: false, isSuccess: true));
        return true;
      },
    );
  }
}
