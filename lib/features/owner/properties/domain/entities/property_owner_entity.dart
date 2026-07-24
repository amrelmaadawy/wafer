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

  PropertyOwnerEntity copyWith({
    int? id,
    String? name,
    num? percentage,
    String? phone,
    String? email,
    String? username,
    bool? isRepresentative,
  }) {
    return PropertyOwnerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      percentage: percentage ?? this.percentage,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      username: username ?? this.username,
      isRepresentative: isRepresentative ?? this.isRepresentative,
    );
  }

  @override
  List<Object?> get props => [id, name, percentage, phone, email, username, isRepresentative];
}
