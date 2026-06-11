import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';

@immutable
class FilesViewModel {
  final bool isProcessing;
  final List<UploadingModel> uploadQueue;
  final int maxFiles;

  const FilesViewModel({
    required this.isProcessing,
    required this.uploadQueue,
    required this.maxFiles,
  });

  FilesViewModel copyWith({bool? isProcessing, List<UploadingModel>? uploadQueue, int? maxFiles}) => FilesViewModel(
        isProcessing: isProcessing ?? this.isProcessing,
        uploadQueue: uploadQueue ?? this.uploadQueue,
        maxFiles: maxFiles ?? this.maxFiles,
      );

  factory FilesViewModel.initial() => const FilesViewModel(isProcessing: false, uploadQueue: [], maxFiles: 0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilesViewModel &&
          runtimeType == other.runtimeType &&
          HelperUtils.compareQueues(uploadQueue, other.uploadQueue) &&
          isProcessing == other.isProcessing &&
          maxFiles == other.maxFiles;

  @override
  int get hashCode => uploadQueue.hashCode ^ maxFiles.hashCode ^ isProcessing.hashCode;
}
