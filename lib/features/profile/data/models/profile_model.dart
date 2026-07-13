import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
    required super.phone,
    super.avatar,
    required super.identityNumber,
    required super.identityExpiry,
    required super.gender,
    required super.accountType,
    required super.isActive,
    required super.joinedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
      identityNumber: json['identity_number']?.toString() ?? '',
      identityExpiry: json['identity_expiry']?.toString() ?? '',
      gender: json['gender']?.toString() ?? 'male',
      accountType: json['account_type']?.toString() ?? 'unknown',
      isActive: json['is_active'] as bool? ?? true,
      joinedAt: json['joined_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'identity_number': identityNumber,
      'identity_expiry': identityExpiry,
      'gender': gender,
      'account_type': accountType,
      'is_active': isActive,
      'joined_at': joinedAt,
    };
  }
}
