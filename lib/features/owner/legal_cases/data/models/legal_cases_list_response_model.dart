import '../../domain/entities/legal_cases_list_response_entity.dart';
import 'legal_case_item_model.dart';

class LegalCasesListResponseModel extends LegalCasesListResponseEntity {
  const LegalCasesListResponseModel({
    super.legalCases,
    super.pagination,
    super.filters,
    super.stats,
  });

  factory LegalCasesListResponseModel.fromJson(Map<String, dynamic> json) {
    return LegalCasesListResponseModel(
      legalCases: (json['legal_cases'] != null && json['legal_cases'] is List)
          ? (json['legal_cases'] as List)
              .map((e) => LegalCaseItemModel.fromJson(e))
              .toList()
          : null,
      pagination: (json['pagination'] != null && json['pagination'] is Map)
          ? LegalCasePaginationModel.fromJson(json['pagination'])
          : null,
      filters: (json['filters'] != null && json['filters'] is Map)
          ? LegalCaseFiltersModel.fromJson(json['filters'])
          : null,
      stats: (json['stats'] != null && json['stats'] is Map)
          ? LegalCaseStatsModel.fromJson(json['stats'])
          : null,
    );
  }
}

class LegalCasePaginationModel extends LegalCasePaginationEntity {
  const LegalCasePaginationModel({
    super.currentPage,
    super.lastPage,
    super.perPage,
    super.total,
    super.from,
    super.to,
  });

  factory LegalCasePaginationModel.fromJson(Map<String, dynamic> json) {
    return LegalCasePaginationModel(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      total: json['total'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
    );
  }
}

class LegalCaseFiltersModel extends LegalCaseFiltersEntity {
  const LegalCaseFiltersModel({super.applied, super.supported});

  factory LegalCaseFiltersModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseFiltersModel(
      applied: (json['applied'] != null && json['applied'] is List) ? json['applied'] as List<dynamic> : null,
      supported: (json['supported'] != null && json['supported'] is List)
          ? (json['supported'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }
}

class LegalCaseStatsModel extends LegalCaseStatsEntity {
  const LegalCaseStatsModel({super.total, super.byStatus});

  factory LegalCaseStatsModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseStatsModel(
      total: json['total'] as int?,
      byStatus: (json['by_status'] != null && json['by_status'] is Map)
          ? (json['by_status'] as Map).map((k, v) => MapEntry(k.toString(), int.tryParse(v.toString()) ?? 0))
          : null,
    );
  }
}
