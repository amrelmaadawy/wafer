import '../../domain/entities/activity_logs_item_entity.dart';
import 'activity_logs_user_model.dart';

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
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      user: ActivityLogsUserModel.fromJson(json['user'] ?? {}),
      type: json['type'] ?? '',
      action: json['action'] ?? '',
      message: json['message'] ?? '',
      description: json['description'],
      ipAddress: json['ip_address'] ?? '',
    );
  }
}
