import '../../domain/entities/activity_logs_item_entity.dart';
import 'activity_logs_user_model.dart';
import 'report_model_parsing.dart';

class ActivityLogsItemModel extends ActivityLogsItemEntity {
  const ActivityLogsItemModel({
    required super.id,
    required super.createdAt,
    required super.user,
    required super.type,
    required super.action,
    required super.message,
    super.description,
    required super.ipAddress,
  });

  factory ActivityLogsItemModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogsItemModel(
      id: reportInt(json['id']),
      createdAt: reportString(json['created_at']),
      user: ActivityLogsUserModel.fromJson(reportMap(json['user'])),
      type: reportString(json['type']),
      action: reportString(json['action']),
      message: reportString(json['message']),
      description: json['description']?.toString(),
      ipAddress: reportString(json['ip_address']),
    );
  }
}
