import '../../domain/entities/activity_logs_user_entity.dart';
import 'report_model_parsing.dart';

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
      id: reportInt(json['id']),
      name: reportString(json['name']),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      userType: reportString(json['user_type']),
    );
  }
}
