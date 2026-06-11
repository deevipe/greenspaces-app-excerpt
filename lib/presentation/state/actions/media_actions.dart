// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:photo_manager/photo_manager.dart';

class AddSelectedPicture {
  final AssetEntity asset;
  AddSelectedPicture({required this.asset});
}

class AddSelectedFile {
  final PlatformFile file;
  AddSelectedFile({required this.file});
}

class ProcessingMediaAction {}

class ProcessingMediaFileAction {}

class SuccessMediaAction {
  final List<UploadingModel> pictures;
  SuccessMediaAction({
    required this.pictures,
  });
}

class SuccessMediaFileAction {
  final List<UploadingModel> files;
  SuccessMediaFileAction({
    required this.files,
  });
}

class ResetMediaState {}

class TakingPicture {}

class UploadingFileProcess {
  final List<UploadingModel> updatedQueue;
  UploadingFileProcess({required this.updatedQueue});
}
class UploadingPFileProcess {
  final List<UploadingModel> updatedQueue;
  UploadingPFileProcess({required this.updatedQueue});
}
