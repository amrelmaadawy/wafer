import '../../domain/entities/clients_list_response_entity.dart';
import 'clients_pagination_model.dart';
import 'client_model.dart';

class ClientsListResponseModel extends ClientsListResponseEntity {
  const ClientsListResponseModel({
    required super.clients,
    required super.pagination,
  });

  factory ClientsListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    
    final clientsList = (data['clients'] as List?)
        ?.map((e) => ClientModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [];

    final pagination = data['pagination'] != null
        ? ClientsPaginationModel.fromJson(data['pagination'] as Map<String, dynamic>)
        : const ClientsPaginationModel(
            currentPage: 1,
            lastPage: 1,
            perPage: 15,
            total: 0,
            from: 0,
            to: 0,
          );

    return ClientsListResponseModel(
      clients: clientsList,
      pagination: pagination,
    );
  }
}
