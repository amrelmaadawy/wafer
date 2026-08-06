import 'package:equatable/equatable.dart';

import 'payment_entity.dart';
import 'receipts_response_entity.dart';

class PaymentsResponseEntity extends Equatable {
  final List<PaymentEntity> payments;
  final PaginationEntity pagination;
  final FiltersEntity filters;

  const PaymentsResponseEntity({
    required this.payments,
    required this.pagination,
    required this.filters,
  });

  @override
  List<Object?> get props => [payments, pagination, filters];
}
