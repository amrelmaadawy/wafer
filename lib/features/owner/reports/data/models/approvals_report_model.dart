import '../../domain/entities/approvals_report_entity.dart';
import '../../domain/entities/maintenance_requests_report_entity.dart'
    show PaginationEntity;
import '../../domain/entities/revenue_report_entity.dart'
    show PropertyFilterItemEntity;

class ApprovalsReportModel extends ApprovalsReportEntity {
  const ApprovalsReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
    required super.filterOptions,
  });

  factory ApprovalsReportModel.fromJson(Map<String, dynamic> json) {
    return ApprovalsReportModel(
      summary: ApprovalsSummaryModel.fromJson(json['summary'] ?? {}),
      items:
          (json['items'] as List?)
              ?.map((item) => ApprovalItemModel.fromJson(item))
              .toList() ??
          [],
      pagination: ApprovalsPaginationModel.fromJson(json['pagination'] ?? {}),
      filterOptions: ApprovalsFilterOptionsModel.fromJson(
        json['filter_options'] ?? {},
      ),
    );
  }
}

class ApprovalsSummaryModel extends ApprovalsSummaryEntity {
  const ApprovalsSummaryModel({
    required super.total,
    required super.approved,
    required super.pending,
    required super.rejected,
  });

  factory ApprovalsSummaryModel.fromJson(Map<String, dynamic> json) {
    return ApprovalsSummaryModel(
      total: (json['total'] as num?)?.toInt() ?? 0,
      approved: (json['approved'] as num?)?.toInt() ?? 0,
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      rejected: (json['rejected'] as num?)?.toInt() ?? 0,
    );
  }
}

class ApprovalItemModel extends ApprovalItemEntity {
  const ApprovalItemModel({
    required super.id,
    required super.status,
    super.statusLabel,
    super.typeValue,
    super.typeLabel,
    super.typeIcon,
    super.typeColor,
    super.title,
    super.date,
    super.amount,
    super.userName,
  });

  factory ApprovalItemModel.fromJson(Map<String, dynamic> json) {
    final approvable = json['approvable'] as Map<String, dynamic>? ?? {};
    final workflow = json['workflow'] as Map<String, dynamic>? ?? {};
    final initiator = json['initiator'] as Map<String, dynamic>? ?? {};

    // Try to extract a title from common approvable fields
    final title =
        approvable['contract_number']?.toString() ??
        approvable['receipt_number']?.toString() ??
        approvable['reference_number']?.toString() ??
        approvable['name']?.toString() ??
        workflow['name']?.toString() ??
        '';

    // Try to extract an amount from common approvable fields
    final amount =
        approvable['total_rent_value']?.toString() ??
        approvable['amount']?.toString() ??
        approvable['total_amount']?.toString() ??
        approvable['value']?.toString();

    return ApprovalItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'pending',
      statusLabel: json['status_label']?.toString(),
      typeValue: json['approvable_type']?.toString(),
      typeLabel: workflow['name']?.toString(),
      typeIcon: null, // Removed from JSON
      typeColor: null, // Removed from JSON
      title: title,
      date: json['created_at']?.toString(),
      amount: amount,
      userName: initiator['name']?.toString(),
    );
  }
}

class ApprovalsPaginationModel extends PaginationEntity {
  const ApprovalsPaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory ApprovalsPaginationModel.fromJson(Map<String, dynamic> json) {
    return ApprovalsPaginationModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 15,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class ApprovalsFilterOptionsModel extends ApprovalsFilterOptionsEntity {
  const ApprovalsFilterOptionsModel({
    required super.statuses,
    required super.approvableTypes,
    required super.users,
    required super.properties,
  });

  factory ApprovalsFilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return ApprovalsFilterOptionsModel(
      statuses:
          (json['statuses'] as List?)
              ?.map((e) => FilterOptionItemModel.fromJson(e))
              .toList() ??
          [],
      approvableTypes:
          (json['approvable_types'] as List?)
              ?.map((e) => ApprovableTypeFilterItemModel.fromJson(e))
              .toList() ??
          [],
      users:
          (json['users'] as List?)
              ?.map((e) => UserFilterItemModel.fromJson(e))
              .toList() ??
          [],
      properties:
          (json['properties'] as List?)
              ?.map((e) => ApprovalsPropertyFilterItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FilterOptionItemModel extends FilterOptionItemEntity {
  const FilterOptionItemModel({required super.value, required super.label});

  factory FilterOptionItemModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionItemModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}

class ApprovableTypeFilterItemModel extends ApprovableTypeFilterItemEntity {
  const ApprovableTypeFilterItemModel({
    required super.value,
    required super.label,
    super.icon,
    super.color,
  });

  factory ApprovableTypeFilterItemModel.fromJson(Map<String, dynamic> json) {
    return ApprovableTypeFilterItemModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      icon: json['icon']?.toString(),
      color: json['color']?.toString(),
    );
  }
}

class UserFilterItemModel extends UserFilterItemEntity {
  const UserFilterItemModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
  });

  factory UserFilterItemModel.fromJson(Map<String, dynamic> json) {
    return UserFilterItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
    );
  }
}

class ApprovalsPropertyFilterItemModel extends PropertyFilterItemEntity {
  const ApprovalsPropertyFilterItemModel({
    required super.id,
    super.name,
    required super.code,
  });

  factory ApprovalsPropertyFilterItemModel.fromJson(Map<String, dynamic> json) {
    return ApprovalsPropertyFilterItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString(),
      code: json['code']?.toString() ?? '',
    );
  }
}
