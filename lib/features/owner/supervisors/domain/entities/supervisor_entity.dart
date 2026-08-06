import 'package:equatable/equatable.dart';

class SupervisorEntity extends Equatable {
  final int id;
  final SupervisorUserListEntity? user;
  final SupervisorScopeEntity? scope;
  final int? sortOrder;
  final bool isActive;
  final SupervisorUserListEntity? createdBy;
  final String? createdAt;

  const SupervisorEntity({
    required this.id,
    this.user,
    this.scope,
    this.sortOrder,
    this.isActive = true,
    this.createdBy,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    scope,
    sortOrder,
    isActive,
    createdBy,
    createdAt,
  ];
}

class SupervisorUserListEntity extends Equatable {
  final int id;
  final String? name;
  final String? email;
  final String? phone;

  const SupervisorUserListEntity({
    required this.id,
    this.name,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, email, phone];
}

class SupervisorScopeEntity extends Equatable {
  final String? type;
  final String? typeLabel;
  final String? condition;
  final List<int>? values;

  const SupervisorScopeEntity({
    this.type,
    this.typeLabel,
    this.condition,
    this.values,
  });

  @override
  List<Object?> get props => [type, typeLabel, condition, values];
}
