import '../../domain/entities/form_owner_entity.dart';

class FormOwnerModel extends FormOwnerEntity {
  const FormOwnerModel({
    required super.id,
    required super.name,
    super.username,
    super.email,
    super.phone,
    super.identityNumber,
    super.userType,
  });

  factory FormOwnerModel.fromJson(Map<String, dynamic> json) {
    return FormOwnerModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      identityNumber: json['identity_number']?.toString(),
      userType: json['user_type']?.toString(),
    );
  }
}
