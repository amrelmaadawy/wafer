import '../../domain/entities/activity_logs_user_entity.dart';

class ActivityLogsUserModel extends ActivityLogsUserEntity {
  const ActivityLogsUserModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    required super.userType,
  });

  factory ActivityLogsUserModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogsUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      userType: json['user_type'] ?? '',
    );
  }
}
