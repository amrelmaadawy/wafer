import 'package:equatable/equatable.dart';

class NotificationItemEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? readAt;
  final String createdAt;
  final Map<String, dynamic>? data;

  const NotificationItemEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.readAt,
    required this.createdAt,
    this.data,
  });

  bool get isRead => readAt != null && readAt!.isNotEmpty && readAt != 'null';

  @override
  List<Object?> get props => [id, title, body, type, readAt, createdAt, data];
}
