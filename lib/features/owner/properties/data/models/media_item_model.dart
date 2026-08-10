import '../../domain/entities/media_item_entity.dart';

class MediaItemModel extends MediaItemEntity {
  const MediaItemModel({
    required super.id,
    required super.path,
    required super.url,
    required super.type,
    super.description,
    super.createdAt,
  });

  factory MediaItemModel.fromJson(Map<String, dynamic> json) {
    return MediaItemModel(
      id: json['id'] as int? ?? 0,
      path: json['path'] as String? ?? '',
      url: json['url'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}

class MediaDetailsModel extends MediaDetailsEntity {
  const MediaDetailsModel({
    super.images = const [],
    super.videos = const [],
    super.files = const [],
  });

  factory MediaDetailsModel.fromJson(Map<String, dynamic> json) {
    return MediaDetailsModel(
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => MediaItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => MediaItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      files: (json['files'] as List<dynamic>?)
              ?.map((e) => MediaItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
