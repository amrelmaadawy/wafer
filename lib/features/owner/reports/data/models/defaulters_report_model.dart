import '../../domain/entities/defaulters_report_entity.dart';
import '../../domain/entities/defaulters_report_item_entity.dart';
import '../../domain/entities/defaulters_report_summary_entity.dart';
import 'report_pagination_model.dart';

class DefaultersReportSummaryModel extends DefaultersReportSummaryEntity {
  const DefaultersReportSummaryModel({
    required super.totalInstallments,
    required super.totalAmount,
    required super.totalPaid,
    required super.totalRemaining,
  });

  factory DefaultersReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return DefaultersReportSummaryModel(
      totalInstallments: _parseInt(json['total_installments']),
      totalAmount: _parseDouble(json['total_amount']),
      totalPaid: _parseDouble(json['total_paid']),
      totalRemaining: _parseDouble(json['total_remaining']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class DefaulterContractModel extends DefaulterContractEntity {
  const DefaulterContractModel({
    required super.id,
    required super.contractNumber,
    required super.status,
    required super.statusLabel,
    required super.startDate,
    required super.endDate,
    required super.totalRentValue,
  });

  factory DefaulterContractModel.fromJson(Map<String, dynamic> json) {
    return DefaulterContractModel(
      id: _parseInt(json['id']),
      contractNumber: json['contract_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      totalRentValue: _parseDouble(json['total_rent_value']),
    );
  }
  
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class DefaulterRenterModel extends DefaulterRenterEntity {
  const DefaulterRenterModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.userType,
  });

  factory DefaulterRenterModel.fromJson(Map<String, dynamic> json) {
    return DefaulterRenterModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      userType: json['user_type']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}

class DefaulterPropertyModel extends DefaulterPropertyEntity {
  const DefaulterPropertyModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory DefaulterPropertyModel.fromJson(Map<String, dynamic> json) {
    return DefaulterPropertyModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}

class DefaulterUnitModel extends DefaulterUnitEntity {
  const DefaulterUnitModel({
    required super.id,
    required super.name,
    required super.unitNumber,
    required super.status,
    required super.statusLabel,
  });

  factory DefaulterUnitModel.fromJson(Map<String, dynamic> json) {
    return DefaulterUnitModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      unitNumber: json['unit_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}

class DefaultersReportItemModel extends DefaultersReportItemEntity {
  const DefaultersReportItemModel({
    required super.id,
    required super.installmentNumber,
    required super.dueDate,
    required super.amount,
    required super.paidAmount,
    required super.remainingAmount,
    required super.daysOverdue,
    required super.contract,
    required super.renter,
    required super.property,
    required super.unit,
  });

  factory DefaultersReportItemModel.fromJson(Map<String, dynamic> json) {
    return DefaultersReportItemModel(
      id: _parseInt(json['id']),
      installmentNumber: _parseInt(json['installment_number']),
      dueDate: json['due_date']?.toString() ?? '',
      amount: _parseDouble(json['amount']),
      paidAmount: _parseDouble(json['paid_amount']),
      remainingAmount: _parseDouble(json['remaining_amount']),
      daysOverdue: _parseDouble(json['days_overdue']),
      contract: DefaulterContractModel.fromJson(json['contract'] ?? {}),
      renter: DefaulterRenterModel.fromJson(json['renter'] ?? {}),
      property: DefaulterPropertyModel.fromJson(json['property'] ?? {}),
      unit: DefaulterUnitModel.fromJson(json['unit'] ?? {}),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class DefaultersReportModel extends DefaultersReportEntity {
  const DefaultersReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
  });

  factory DefaultersReportModel.fromJson(Map<String, dynamic> json) {
    return DefaultersReportModel(
      summary: DefaultersReportSummaryModel.fromJson(json['summary'] ?? {}),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => DefaultersReportItemModel.fromJson(e))
              .toList() ??
          [],
      pagination: ReportPaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}
