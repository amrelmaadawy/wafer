import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.avatar,
    super.token,
    required super.accountType,
    super.tenantId,
    super.tenantName,
    super.requiresPasswordChange = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    final tenantJson = json['tenant'] as Map<String, dynamic>? ?? {};

    return UserModel(
      id: userJson['id']?.toString() ?? '',
      name: userJson['name'] ?? '',
      email: userJson['email'] ?? '',
      phone: userJson['phone'],
      avatar: userJson['avatar'],
      token: json['token'],
      accountType: json['account_type'] ?? 'unknown',
      tenantId: tenantJson['id']?.toString(),
      tenantName: tenantJson['name'],
      requiresPasswordChange: json['requires_password_change'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'account_type': accountType,
      'requires_password_change': requiresPasswordChange,
      'user': {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
      },
      'tenant': {
        'id': tenantId,
        'name': tenantName,
      },
    };
  }
}
