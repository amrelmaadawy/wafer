import 'package:equatable/equatable.dart';

class DefaulterEntity extends Equatable {
  final int id;
  final String tenantName;
  final String unitName;
  final String propertyName;
  final double overdueAmount;
  final String overdueSince;
  final int installmentsCount;

  const DefaulterEntity({
    required this.id,
    required this.tenantName,
    required this.unitName,
    required this.propertyName,
    required this.overdueAmount,
    required this.overdueSince,
    required this.installmentsCount,
  });

  @override
  List<Object?> get props => [
        id,
        tenantName,
        unitName,
        propertyName,
        overdueAmount,
        overdueSince,
        installmentsCount,
      ];
}
