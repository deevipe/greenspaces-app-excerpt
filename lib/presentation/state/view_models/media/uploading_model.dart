import 'package:flutter/foundation.dart';

@immutable
class UploadingModel {
  final dynamic file;
  final int uploadedBytes;
  final int totalBytes;
  final bool uploading;
  final bool uploadDone;
  final bool uploadError;

  const UploadingModel({
    required this.file,
    required this.uploadedBytes,
    required this.totalBytes,
    required this.uploading,
    required this.uploadDone,
    required this.uploadError,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadingModel &&
          runtimeType == other.runtimeType &&
          identical(file, other.file) &&
          uploadedBytes == other.uploadedBytes &&
          totalBytes == other.totalBytes &&
          uploading == other.uploading &&
          uploadError == other.uploadError &&
          uploadDone == other.uploadDone;

  @override
  int get hashCode => file.hashCode ^ uploadedBytes.hashCode ^ totalBytes.hashCode ^ uploadDone.hashCode ^ uploadError.hashCode;
}
