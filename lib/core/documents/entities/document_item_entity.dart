import 'package:equatable/equatable.dart';

enum DocumentType {
  pdf,
  image,
  other;

  static DocumentType fromMimeOrUrl({String? mimeType, String? url}) {
    if (mimeType != null) {
      final mime = mimeType.toLowerCase();
      if (mime.contains('pdf')) return DocumentType.pdf;
      if (mime.contains('image') ||
          mime.contains('jpeg') ||
          mime.contains('png') ||
          mime.contains('webp') ||
          mime.contains('gif')) {
        return DocumentType.image;
      }
    }
    if (url != null) {
      final lower = url.toLowerCase().split('?').first;
      if (lower.endsWith('.pdf')) return DocumentType.pdf;
      if (lower.endsWith('.png') ||
          lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.webp') ||
          lower.endsWith('.svg') ||
          lower.endsWith('.gif')) {
        return DocumentType.image;
      }
    }
    return DocumentType.other;
  }
}

class DocumentItemEntity extends Equatable {
  final String id;
  final String name;
  final String url;
  final String? mimeType;
  final String? fileSize;
  final String? createdAt;
  final String? description;
  final DocumentType type;

  const DocumentItemEntity({
    required this.id,
    required this.name,
    required this.url,
    this.mimeType,
    this.fileSize,
    this.createdAt,
    this.description,
    this.type = DocumentType.other,
  });

  factory DocumentItemEntity.inferred({
    required String id,
    required String name,
    required String url,
    String? mimeType,
    String? fileSize,
    String? createdAt,
    String? description,
    DocumentType? type,
  }) {
    return DocumentItemEntity(
      id: id,
      name: name,
      url: url,
      mimeType: mimeType,
      fileSize: fileSize,
      createdAt: createdAt,
      description: description,
      type: type ??
          DocumentType.fromMimeOrUrl(
            mimeType: mimeType,
            url: url,
          ),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        url,
        mimeType,
        fileSize,
        createdAt,
        description,
        type,
      ];
}
