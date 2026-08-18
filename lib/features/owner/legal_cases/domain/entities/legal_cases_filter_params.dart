import 'package:equatable/equatable.dart';

class LegalCasesFilterParams extends Equatable {
  final int page;
  final int perPage;
  final String? search;
  final String? status;
  final String? caseType;
  final String? priority;
  final String? dateFrom;
  final String? dateTo;
  final String? sortBy;
  final String? sortOrder;

  const LegalCasesFilterParams({
    this.page = 1,
    this.perPage = 15,
    this.search,
    this.status,
    this.caseType,
    this.priority,
    this.dateFrom,
    this.dateTo,
    this.sortBy,
    this.sortOrder,
  });

  LegalCasesFilterParams copyWith({
    int? page,
    int? perPage,
    String? search,
    String? status,
    String? caseType,
    String? priority,
    String? dateFrom,
    String? dateTo,
    String? sortBy,
    String? sortOrder,
    bool clearSearch = false,
    bool clearStatus = false,
    bool clearCaseType = false,
    bool clearPriority = false,
    bool clearDates = false,
  }) {
    return LegalCasesFilterParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: clearSearch ? null : (search ?? this.search),
      status: clearStatus ? null : (status ?? this.status),
      caseType: clearCaseType ? null : (caseType ?? this.caseType),
      priority: clearPriority ? null : (priority ?? this.priority),
      dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDates ? null : (dateTo ?? this.dateTo),
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toQueryMap() {
    final map = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (search != null && search!.trim().isNotEmpty) {
      map['search'] = search!.trim();
    }
    if (status != null && status!.isNotEmpty) {
      map['status'] = status;
    }
    if (caseType != null && caseType!.isNotEmpty) {
      map['case_type'] = caseType;
    }
    if (priority != null && priority!.isNotEmpty) {
      map['priority'] = priority;
    }
    if (dateFrom != null && dateFrom!.isNotEmpty) {
      map['date_from'] = dateFrom;
    }
    if (dateTo != null && dateTo!.isNotEmpty) {
      map['date_to'] = dateTo;
    }
    if (sortBy != null && sortBy!.isNotEmpty) {
      map['sort_by'] = sortBy;
    }
    if (sortOrder != null && sortOrder!.isNotEmpty) {
      map['sort_order'] = sortOrder;
    }
    return map;
  }

  @override
  List<Object?> get props => [
        page,
        perPage,
        search,
        status,
        caseType,
        priority,
        dateFrom,
        dateTo,
        sortBy,
        sortOrder,
      ];
}
