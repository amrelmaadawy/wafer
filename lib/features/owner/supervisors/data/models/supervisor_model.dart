import '../../domain/entities/supervisor_entity.dart';

class SupervisorModel extends SupervisorEntity {
  const SupervisorModel({
    required super.id,
    super.user,
    super.scope,
    super.sortOrder,
    super.isActive,
    super.createdBy,
    super.createdAt,
  });

  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    return SupervisorModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      user: json['user'] != null
          ? SupervisorUserListModel.fromJson(json['user'])
          : null,
      scope: json['scope'] != null
          ? SupervisorScopeModel.fromJson(json['scope'])
          : null,
      sortOrder: json['sort_order'] != null
          ? (json['sort_order'] is int
                ? json['sort_order']
                : int.tryParse(json['sort_order'].toString()))
          : null,
      isActive:
          json['is_active'] == 1 ||
          json['is_active'] == true ||
          json['is_active'] == '1',
      createdBy: json['created_by'] != null
          ? SupervisorUserListModel.fromJson(json['created_by'])
          : null,
      createdAt: json['created_at']?.toString(),
    );
  }
}

class SupervisorUserListModel extends SupervisorUserListEntity {
  const SupervisorUserListModel({
    required super.id,
    super.name,
    super.email,
    super.phone,
  });

  factory SupervisorUserListModel.fromJson(Map<String, dynamic> json) {
    return SupervisorUserListModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
    );
  }
}

class SupervisorScopeModel extends SupervisorScopeEntity {
  const SupervisorScopeModel({
    super.type,
    super.typeLabel,
    super.condition,
    super.values,
  });

  factory SupervisorScopeModel.fromJson(Map<String, dynamic> json) {
    return SupervisorScopeModel(
      type: json['type']?.toString(),
      typeLabel: json['type_label']?.toString(),
      condition: json['condition']?.toString(),
      values: json['values'] != null && json['values'] is List
          ? (json['values'] as List)
                .map((e) => int.tryParse(e.toString()) ?? 0)
                .toList()
          : null,
    );
  }
}
