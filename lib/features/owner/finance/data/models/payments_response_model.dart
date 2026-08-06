import '../../domain/entities/payments_response_entity.dart';
import 'payment_model.dart';
import 'receipts_response_model.dart';

class PaymentsResponseModel extends PaymentsResponseEntity {
  const PaymentsResponseModel({
    required super.payments,
    required super.pagination,
    required super.filters,
  });

  factory PaymentsResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentsResponseModel(
      payments: List<PaymentModel>.from(
        (json['payments'] as List).map((x) => PaymentModel.fromJson(x)),
      ),
      pagination: PaginationModel.fromJson(json['pagination']),
      filters: FiltersModel.fromJson(json['filters']),
    );
  }
}
