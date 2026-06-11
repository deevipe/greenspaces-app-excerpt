import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';

@immutable
class MediaViewModel {
  final bool isProcessing;
  final List<UploadingModel> uploadQueue;
  final int maxPictures;

  const MediaViewModel({
    required this.isProcessing,
    required this.maxPictures,
    required this.uploadQueue,
  });

  MediaViewModel copyWith({
    bool? isProcessing,
    int? maxPictures,
    List<UploadingModel>? uploadQueue,
  }) =>
      MediaViewModel(
        isProcessing: isProcessing ?? this.isProcessing,
        maxPictures: maxPictures ?? this.maxPictures,
        uploadQueue: uploadQueue ?? this.uploadQueue,
      );

  factory MediaViewModel.initial() => const MediaViewModel(isProcessing: false, maxPictures: 10, uploadQueue: []);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaViewModel &&
          runtimeType == other.runtimeType &&
          HelperUtils.compareQueues(uploadQueue, other.uploadQueue) &&
          isProcessing == other.isProcessing &&
          maxPictures == other.maxPictures;

  @override
  int get hashCode => maxPictures.hashCode ^ isProcessing.hashCode ^ uploadQueue.hashCode;

}
