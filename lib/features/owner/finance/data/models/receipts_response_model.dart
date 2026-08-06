import '../../domain/entities/receipts_response_entity.dart';
import 'receipt_model.dart';

class ReceiptsResponseModel extends ReceiptsResponseEntity {
  const ReceiptsResponseModel({
    required super.receipts,
    required super.pagination,
    required super.filters,
  });

  factory ReceiptsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return ReceiptsResponseModel(
      receipts: () {
        final receiptsData = data['receipts'];
        if (receiptsData is List) {
          return receiptsData.map((item) => ReceiptModel.fromJson(item)).toList();
        } else if (receiptsData is Map && receiptsData.containsKey('data') && receiptsData['data'] is List) {
          return (receiptsData['data'] as List).map((item) => ReceiptModel.fromJson(item)).toList();
        }
        return <ReceiptModel>[];
      }(),
      pagination: PaginationModel.fromJson(
        data['pagination'] ?? (data['receipts'] is Map ? data['receipts'] : {}),
      ),
      filters: FiltersModel.fromJson(data['filters'] ?? {}),
    );
  }
}

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 15,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class FiltersModel extends FiltersEntity {
  const FiltersModel({
    required super.applied,
    required super.supported,
  });

  factory FiltersModel.fromJson(Map<String, dynamic> json) {
    List<String> parseList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      } else if (value is Map) {
        return value.values.map((e) => e.toString()).toList();
      }
      return [];
    }

    return FiltersModel(
      applied: parseList(json['applied']),
      supported: parseList(json['supported']),
    );
  }
}
