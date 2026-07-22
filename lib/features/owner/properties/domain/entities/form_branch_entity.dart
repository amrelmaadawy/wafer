import 'package:equatable/equatable.dart';

class FormBranchEntity extends Equatable {
  final int id;
  final String name;
  final String? city;
  final String? district;
  final String status;

  const FormBranchEntity({
    required this.id,
    required this.name,
    this.city,
    this.district,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, city, district, status];
}
