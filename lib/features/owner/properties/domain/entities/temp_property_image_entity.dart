import 'package:equatable/equatable.dart';

class TempPropertyImageEntity extends Equatable {
  final String localPath;
  final String? tempPath;
  final String? url;
  final String? description;
  final bool isUploading;
  final bool uploadFailed;

  const TempPropertyImageEntity({
    required this.localPath,
    this.tempPath,
    this.url,
    this.description,
    this.isUploading = false,
    this.uploadFailed = false,
  });

  TempPropertyImageEntity copyWith({
    String? localPath,
    String? tempPath,
    String? url,
    String? description,
    bool? isUploading,
    bool? uploadFailed,
  }) {
    return TempPropertyImageEntity(
      localPath: localPath ?? this.localPath,
      tempPath: tempPath ?? this.tempPath,
      url: url ?? this.url,
      description: description ?? this.description,
      isUploading: isUploading ?? this.isUploading,
      uploadFailed: uploadFailed ?? this.uploadFailed,
    );
  }

  @override
  List<Object?> get props => [
        localPath,
        tempPath,
        url,
        description,
        isUploading,
        uploadFailed,
      ];
}
