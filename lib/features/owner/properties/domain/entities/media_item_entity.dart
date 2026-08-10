import 'package:equatable/equatable.dart';

class MediaItemEntity extends Equatable {
  final int id;
  final String path;
  final String url;
  final String type;
  final String? description;
  final String? createdAt;

  const MediaItemEntity({
    required this.id,
    required this.path,
    required this.url,
    required this.type,
    this.description,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, path, url, type, description, createdAt];
}

class MediaDetailsEntity extends Equatable {
  final List<MediaItemEntity> images;
  final List<MediaItemEntity> videos;
  final List<MediaItemEntity> files;

  const MediaDetailsEntity({
    this.images = const [],
    this.videos = const [],
    this.files = const [],
  });

  @override
  List<Object?> get props => [images, videos, files];
}
