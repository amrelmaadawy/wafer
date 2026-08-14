import 'package:equatable/equatable.dart';
import 'scope_value_id.dart';

class CreateMaintenanceSupervisorParams extends Equatable {
  final int userId;
  final String scopeType;
  final List<ScopeValueId>? scopeValues;
  final int? sortOrder;
  final bool isActive;

  const CreateMaintenanceSupervisorParams({
    required this.userId,
    required this.scopeType,
    this.scopeValues,
    this.sortOrder,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'user_id': userId,
      'scope_type': scopeType,
      'is_active': isActive ? 1 : 0, 
    };

    if (scopeValues != null && scopeValues!.isNotEmpty) {
      map['scope_values'] = scopeValues!.map((e) => e.toJson()).toList();
    }

    if (sortOrder != null) {
      map['sort_order'] = sortOrder;
    }

    return map;
  }

  @override
  List<Object?> get props => [
        userId,
        scopeType,
        scopeValues,
        sortOrder,
        isActive,
      ];
}
