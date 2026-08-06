import '../../domain/entities/negotiations_list_response_entity.dart';
import 'negotiation_form_data_response_model.dart';
import 'negotiation_pagination_model.dart';

class NegotiationsListResponseModel extends NegotiationsListResponseEntity {
  const NegotiationsListResponseModel({
    required super.negotiations,
    required super.pagination,
  });

  factory NegotiationsListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return NegotiationsListResponseModel(
      negotiations:
          (data['maintenance_negotiations'] as List?)
              ?.map((e) => NegotiationModel.fromJson(e))
              .toList() ??
          [],
      pagination: NegotiationPaginationModel.fromJson(data['pagination'] ?? {}),
    );
  }
}
