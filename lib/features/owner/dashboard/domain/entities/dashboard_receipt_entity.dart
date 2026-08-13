import 'package:equatable/equatable.dart';

class ReceiptEntity extends Equatable {
  final String id;
  final String tenantName;
  final String propertyName;
  final String unitNumber;
  final num amount;
  final String date;

  const ReceiptEntity({
    required this.id,
    required this.tenantName,
    required this.propertyName,
    required this.unitNumber,
    required this.amount,
    required this.date,
  });

  @override
  List<Object?> get props => [
    id,
    tenantName,
    propertyName,
    unitNumber,
    amount,
    date,
  ];
}
