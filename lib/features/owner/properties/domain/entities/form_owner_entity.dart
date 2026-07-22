import 'package:equatable/equatable.dart';

class FormOwnerEntity extends Equatable {
  final int id;
  final String name;
  final String? username;
  final String? email;
  final String? phone;
  final String? identityNumber;
  final String? userType;

  const FormOwnerEntity({
    required this.id,
    required this.name,
    this.username,
    this.email,
    this.phone,
    this.identityNumber,
    this.userType,
  });

  @override
  List<Object?> get props => [id, name, username, email, phone, identityNumber, userType];
}
