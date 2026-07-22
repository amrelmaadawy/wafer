import 'package:equatable/equatable.dart';

class PropertyOwnerEntity extends Equatable {
  final String id;
  final String name;
  final num percentage;
  final String? phone;
  final String? email;

  const PropertyOwnerEntity({
    required this.id,
    required this.name,
    required this.percentage,
    this.phone,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, percentage, phone, email];
}
