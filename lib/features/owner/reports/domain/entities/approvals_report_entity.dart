import 'package:equatable/equatable.dart';
import 'maintenance_requests_report_entity.dart' show PaginationEntity;
import 'revenue_report_entity.dart' show PropertyFilterItemEntity;

class ApprovalsReportEntity extends Equatable {
  final ApprovalsSummaryEntity summary;
  final List<ApprovalItemEntity> items;
  final PaginationEntity pagination;
  final ApprovalsFilterOptionsEntity filterOptions;

  const ApprovalsReportEntity({
    required this.summary,
    required this.items,
    required this.pagination,
    required this.filterOptions,
  });

  @override
  List<Object?> get props => [summary, items, pagination, filterOptions];
}

class ApprovalsSummaryEntity extends Equatable {
  final int total;
  final int approved;
  final int pending;
  final int rejected;

  const ApprovalsSummaryEntity({
    required this.total,
    required this.approved,
    required this.pending,
    required this.rejected,
  });

  @override
  List<Object?> get props => [total, approved, pending, rejected];
}

class ApprovalItemEntity extends Equatable {
  final int id;
  final String status;
  final String? typeValue;
  final String? typeLabel;
  final String? typeIcon;
  final String? typeColor;
  final String? title;
  final String? date;
  final String? amount;
  final String? userName;

  const ApprovalItemEntity({
    required this.id,
    required this.status,
    this.typeValue,
    this.typeLabel,
    this.typeIcon,
    this.typeColor,
    this.title,
    this.date,
    this.amount,
    this.userName,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        typeValue,
        typeLabel,
        typeIcon,
        typeColor,
        title,
        date,
        amount,
        userName,
      ];
}

class ApprovalsFilterOptionsEntity extends Equatable {
  final List<FilterOptionItemEntity> statuses;
  final List<ApprovableTypeFilterItemEntity> approvableTypes;
  final List<UserFilterItemEntity> users;
  final List<PropertyFilterItemEntity> properties;

  const ApprovalsFilterOptionsEntity({
    required this.statuses,
    required this.approvableTypes,
    required this.users,
    required this.properties,
  });

  @override
  List<Object?> get props => [statuses, approvableTypes, users, properties];
}

class FilterOptionItemEntity extends Equatable {
  final String value;
  final String label;

  const FilterOptionItemEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class ApprovableTypeFilterItemEntity extends Equatable {
  final String value;
  final String label;
  final String? icon;
  final String? color;

  const ApprovableTypeFilterItemEntity({
    required this.value,
    required this.label,
    this.icon,
    this.color,
  });

  @override
  List<Object?> get props => [value, label, icon, color];
}

class UserFilterItemEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;

  const UserFilterItemEntity({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, email, phone];
}
