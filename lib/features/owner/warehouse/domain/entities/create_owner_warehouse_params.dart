class CreateOwnerWarehouseParams {
  final String name;
  final String code;
  final String? notes;
  final bool isActive;

  const CreateOwnerWarehouseParams({
    required this.name,
    required this.code,
    this.notes,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'is_active': isActive,
    };
  }
}
