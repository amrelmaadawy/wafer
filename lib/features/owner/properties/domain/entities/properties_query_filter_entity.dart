import 'package:equatable/equatable.dart';

class PropertiesQueryFilterEntity extends Equatable {
  final String? search;
  final String? status;
  final String? propertyType;
  final String? usageType;
  final int? branchId;
  final int? deedId;
  final int page;
  final int perPage;
  final bool includeTree;

  const PropertiesQueryFilterEntity({
    this.search,
    this.status,
    this.propertyType,
    this.usageType,
    this.branchId,
    this.deedId,
    this.page = 1,
    this.perPage = 15,
    this.includeTree = true,
  });

  PropertiesQueryFilterEntity copyWith({
    String? Function()? search,
    String? Function()? status,
    String? Function()? propertyType,
    String? Function()? usageType,
    int? Function()? branchId,
    int? Function()? deedId,
    int? page,
    int? perPage,
    bool? includeTree,
  }) {
    return PropertiesQueryFilterEntity(
      search: search != null ? search() : this.search,
      status: status != null ? status() : this.status,
      propertyType: propertyType != null ? propertyType() : this.propertyType,
      usageType: usageType != null ? usageType() : this.usageType,
      branchId: branchId != null ? branchId() : this.branchId,
      deedId: deedId != null ? deedId() : this.deedId,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      includeTree: includeTree ?? this.includeTree,
    );
  }

  Map<String, dynamic> toQueryParams() {
    return {
      'page': page,
      'per_page': perPage,
      'include_tree': includeTree,
      if (search != null && search!.trim().isNotEmpty) 'search': search!.trim(),
      if (status != null && status != 'all' && status!.isNotEmpty) 'status': status,
      if (propertyType != null && propertyType != 'all' && propertyType!.isNotEmpty)
        'property_type': propertyType,
      if (usageType != null && usageType != 'all' && usageType!.isNotEmpty)
        'usage_type': usageType,
      if (branchId != null) 'branch_id': branchId,
      if (deedId != null) 'deed_id': deedId,
    };
  }

  @override
  List<Object?> get props => [
        search,
        status,
        propertyType,
        usageType,
        branchId,
        deedId,
        page,
        perPage,
        includeTree,
      ];
}
