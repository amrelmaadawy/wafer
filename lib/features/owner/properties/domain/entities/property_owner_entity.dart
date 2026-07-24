import 'package:equatable/equatable.dart';

class PropertyOwnerEntity extends Equatable {
  final int id;
  final String name;
  final num percentage;
  final String? phone;
  final String? email;
  final String? username;
  final bool isRepresentative;

  const PropertyOwnerEntity({
    required this.id,
    required this.name,
    required this.percentage,
    this.phone,
    this.email,
    this.username,
    this.isRepresentative = false,
  });

  @override
  List<Object?> get props => [id, name, percentage, phone, email, username, isRepresentative];
}
