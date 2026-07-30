import 'package:equatable/equatable.dart';
import 'activity_logs_user_entity.dart';

class ActivityLogsItemEntity extends Equatable {
  final int id;
  final String createdAt;
  final ActivityLogsUserEntity user;
  final String type;
  final String action;
  final String message;
  final String? description;
  final String ipAddress;

  const ActivityLogsItemEntity({
    required this.id,
    required this.createdAt,
    required this.user,
    required this.type,
    required this.action,
    required this.message,
    this.description,
    required this.ipAddress,
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    user,
    type,
    action,
    message,
    description,
    ipAddress,
  ];
}
