import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String? avatar;
  final String identityNumber;
  final String identityExpiry;
  final String gender;
  final String accountType;
  final bool isActive;
  final String joinedAt;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    this.avatar,
    required this.identityNumber,
    required this.identityExpiry,
    required this.gender,
    required this.accountType,
    required this.isActive,
    required this.joinedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        email,
        phone,
        avatar,
        identityNumber,
        identityExpiry,
        gender,
        accountType,
        isActive,
        joinedAt,
      ];
}
