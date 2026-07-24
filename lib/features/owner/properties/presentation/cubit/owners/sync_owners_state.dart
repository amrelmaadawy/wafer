import 'package:equatable/equatable.dart';
import '../../../domain/entities/form_owner_entity.dart';
import '../../../domain/entities/property_owner_entity.dart';

// Represents a draft owner entry being edited in the sheet
class DraftOwnerEntry extends Equatable {
  final FormOwnerEntity owner;
  final double percentage;
  final bool isRepresentative;

  const DraftOwnerEntry({
    required this.owner,
    this.percentage = 0.0,
    this.isRepresentative = false,
  });

  DraftOwnerEntry copyWith({
    double? percentage,
    bool? isRepresentative,
  }) {
    return DraftOwnerEntry(
      owner: owner,
      percentage: percentage ?? this.percentage,
      isRepresentative: isRepresentative ?? this.isRepresentative,
    );
  }

  @override
  List<Object?> get props => [owner.id, percentage, isRepresentative];
}

class SyncOwnersState extends Equatable {
  final bool isLoading;
  final bool isSyncing;
  final bool isSuccess;
  final String? errorMessage;
  final List<FormOwnerEntity> availableOwners;
  final List<DraftOwnerEntry> assignedOwners;

  const SyncOwnersState({
    this.isLoading = false,
    this.isSyncing = false,
    this.isSuccess = false,
    this.errorMessage,
    this.availableOwners = const [],
    this.assignedOwners = const [],
  });

  double get totalPercentage =>
      assignedOwners.fold(0.0, (sum, e) => sum + e.percentage);

  bool get isValid => (totalPercentage - 100.0).abs() < 0.001;

  bool get hasRepresentative => assignedOwners.any((e) => e.isRepresentative);

  SyncOwnersState copyWith({
    bool? isLoading,
    bool? isSyncing,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
    List<FormOwnerEntity>? availableOwners,
    List<DraftOwnerEntry>? assignedOwners,
  }) {
    return SyncOwnersState(
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      availableOwners: availableOwners ?? this.availableOwners,
      assignedOwners: assignedOwners ?? this.assignedOwners,
    );
  }

  /// Build from current property owners for initial state
  factory SyncOwnersState.fromCurrentOwners({
    required List<FormOwnerEntity> availableOwners,
    required List<PropertyOwnerEntity> currentOwners,
  }) {
    final assigned = currentOwners.map((o) {
      final form = availableOwners.where((a) => a.id == o.id).firstOrNull;
      return DraftOwnerEntry(
        owner: form ??
            FormOwnerEntity(
              id: o.id,
              name: o.name,
              phone: o.phone,
              email: o.email,
            ),
        percentage: o.percentage.toDouble(),
        isRepresentative: o.isRepresentative,
      );
    }).toList();

    return SyncOwnersState(
      availableOwners: availableOwners,
      assignedOwners: assigned,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSyncing,
        isSuccess,
        errorMessage,
        availableOwners,
        assignedOwners,
      ];
}
