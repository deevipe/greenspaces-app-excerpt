import 'package:gisogs_greenspacesapp/presentation/state/actions/media_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/media_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:redux/redux.dart';

final mediaReducer = combineReducers<MediaViewModel>([
  TypedReducer<MediaViewModel, ProcessingMediaAction>(_processing),
  TypedReducer<MediaViewModel, AddSelectedPicture>(_addPic),
  TypedReducer<MediaViewModel, SuccessMediaAction>(_success),
  TypedReducer<MediaViewModel, ResetMediaState>(_reset),
  TypedReducer<MediaViewModel, TakingPicture>(_shooting),
  TypedReducer<MediaViewModel, UploadingFileProcess>(_uploadingProcess),
]);

MediaViewModel _processing(MediaViewModel state, ProcessingMediaAction action) {
  return state.copyWith(isProcessing: true);
}

MediaViewModel _addPic(MediaViewModel state, AddSelectedPicture action) {
  List<UploadingModel> newList = List.from(state.uploadQueue);

  // if maxSelectedPicture set to 0, then there is no limit
  if (state.maxPictures == 0 || state.uploadQueue.length < state.maxPictures) {
    newList.add(UploadingModel(file: action.asset, uploadedBytes: 0, totalBytes: 0, uploading: false, uploadError: false, uploadDone: false));
  } else {
    newList.removeAt(0);
    newList.add(UploadingModel(file: action.asset, uploadedBytes: 0, totalBytes: 0, uploading: false, uploadError: false, uploadDone: false));
  }

  return state.copyWith(uploadQueue: newList, isProcessing: false);
}

MediaViewModel _success(MediaViewModel state, SuccessMediaAction action) {
  return state.copyWith(
    uploadQueue: action.pictures,
    isProcessing: false,
  );
}

MediaViewModel _reset(MediaViewModel state, ResetMediaState action) {
  return state.copyWith(
    uploadQueue: [],
    isProcessing: false,
  );
}

MediaViewModel _shooting(MediaViewModel state, TakingPicture action) {
  return state.copyWith(
    uploadQueue: state.uploadQueue,
    isProcessing: true,
  );
}

MediaViewModel _uploadingProcess(MediaViewModel state, UploadingFileProcess action) {
  return state.copyWith(
    uploadQueue: action.updatedQueue,
    isProcessing: false,
  );
}
