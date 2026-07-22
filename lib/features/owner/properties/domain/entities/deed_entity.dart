import 'package:equatable/equatable.dart';

class DeedEntity extends Equatable {
  final int id;
  final String deedNumber;
  final String? deedDate;
  final String? city;
  final String? district;
  final String? ownerName;

  const DeedEntity({
    required this.id,
    required this.deedNumber,
    this.deedDate,
    this.city,
    this.district,
    this.ownerName,
  });

  @override
  List<Object?> get props => [id, deedNumber, deedDate, city, district, ownerName];
}
