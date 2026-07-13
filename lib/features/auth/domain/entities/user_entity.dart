import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? token;
  final String accountType; // e.g. "owner", "company", "tenant"
  final String? tenantId;
  final String? tenantName;
  final bool requiresPasswordChange;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.token,
    required this.accountType,
    this.tenantId,
    this.tenantName,
    this.requiresPasswordChange = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        avatar,
        token,
        accountType,
        tenantId,
        tenantName,
        requiresPasswordChange,
      ];
}
