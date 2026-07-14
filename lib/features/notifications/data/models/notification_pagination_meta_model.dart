import '../../domain/entities/notification_pagination_meta_entity.dart';

class NotificationPaginationMetaModel extends NotificationPaginationMetaEntity {
  const NotificationPaginationMetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory NotificationPaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return NotificationPaginationMetaModel(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}
