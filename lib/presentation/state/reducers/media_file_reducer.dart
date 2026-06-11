import 'package:gisogs_greenspacesapp/presentation/state/actions/media_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/files_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:redux/redux.dart';

final mediaFileReducer = combineReducers<FilesViewModel>([
  TypedReducer<FilesViewModel, ProcessingMediaFileAction>(_processing),
  TypedReducer<FilesViewModel, AddSelectedFile>(_addFile),
  TypedReducer<FilesViewModel, SuccessMediaFileAction>(_success),
  TypedReducer<FilesViewModel, ResetMediaState>(_reset),
  TypedReducer<FilesViewModel, UploadingPFileProcess>(_uploadingProcess),
]);

FilesViewModel _processing(FilesViewModel state, ProcessingMediaFileAction action) {
  return state.copyWith(isProcessing: true);
}

FilesViewModel _addFile(FilesViewModel state, AddSelectedFile action) {
  List<UploadingModel> newList = List.from(state.uploadQueue);

  // if maxSelectedPicture set to 0, then there is no limit
  if (state.maxFiles == 0 || state.uploadQueue.length < state.maxFiles) {
    newList.add(UploadingModel(file: action.file, uploadedBytes: 0, totalBytes: 0, uploading: false, uploadError: false, uploadDone: false));
  } else {
    newList.removeAt(0);
    newList.add(UploadingModel(file: action.file, uploadedBytes: 0, totalBytes: 0, uploading: false, uploadError: false, uploadDone: false));
  }

  return state.copyWith(uploadQueue: newList);
}

FilesViewModel _success(FilesViewModel state, SuccessMediaFileAction action) {
  return state.copyWith(
    uploadQueue: action.files,
    isProcessing: false,
  );
}

FilesViewModel _reset(FilesViewModel state, ResetMediaState action) {
  return state.copyWith(
    uploadQueue: [],
    isProcessing: false,
  );
}


FilesViewModel _uploadingProcess(FilesViewModel state, UploadingPFileProcess action) {
  return state.copyWith(
    uploadQueue: action.updatedQueue,
    isProcessing: false,
  );
}
