class UpdateOwnerWarehouseParams {
  final String? name;
  final String? code;
  final String? notes;
  final bool? isActive;
  final int? parentId;

  UpdateOwnerWarehouseParams({
    this.name,
    this.code,
    this.notes,
    this.isActive,
    this.parentId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (code != null) map['code'] = code;
    if (notes != null) map['notes'] = notes;
    if (isActive != null) map['is_active'] = isActive;
    if (parentId != null) map['parent_id'] = parentId;
    return map;
  }
}
