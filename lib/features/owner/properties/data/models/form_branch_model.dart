import '../../domain/entities/form_branch_entity.dart';

class FormBranchModel extends FormBranchEntity {
  const FormBranchModel({
    required super.id,
    required super.name,
    super.city,
    super.district,
    required super.status,
  });

  factory FormBranchModel.fromJson(Map<String, dynamic> json) {
    return FormBranchModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      city: json['city']?.toString(),
      district: json['district']?.toString(),
      status: json['status']?.toString() ?? 'active',
    );
  }
}
