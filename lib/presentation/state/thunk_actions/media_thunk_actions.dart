import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:gisogs_greenspacesapp/domain/enums/file_upload_entity_type.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/use_case_module.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/media_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/files_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/media_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> bulkAddPictures({required List<AssetEntity> list}) => (Store<AppState> store) async {
      store.dispatch(ProcessingMediaAction());
      try {
        List<UploadingModel> currentList = List.from(store.state.mediaState.uploadQueue);
        // сначала исключим из списка уже добавленные фото
        for (UploadingModel item in currentList) {
          list.removeWhere((element) => element == item.file);
        }
        List<UploadingModel> newList = list
            .map((e) => UploadingModel(file: e, uploadedBytes: 0, totalBytes: 0, uploadError: false, uploading: false, uploadDone: false))
            .toList()
            .cast<UploadingModel>();

        currentList.addAll(newList);
        store.dispatch(SuccessMediaAction(
          pictures: currentList,
        ));
      } catch (_) {}
    };

ThunkAction<AppState> removePicture({required AssetEntity file}) => (Store<AppState> store) async {
      store.dispatch(ProcessingMediaAction());
      final MediaViewModel state = store.state.mediaState;
      List<UploadingModel> currentSelected = List.from(state.uploadQueue);

      if (currentSelected.isNotEmpty) {
        currentSelected.removeWhere((element) => element.file.id == file.id);
      }

      store.dispatch(SuccessMediaAction(
        pictures: currentSelected,
      ));
    };

ThunkAction<AppState> bulkAddFiles({required List<PlatformFile> list}) => (Store<AppState> store) async {
      store.dispatch(ProcessingMediaFileAction());
      try {
        List<UploadingModel> currentList = List.from(store.state.mediaFileState.uploadQueue);
        // сначала исключим из списка уже добавленные фото
        for (UploadingModel item in currentList) {
          list.removeWhere((element) => element == item.file);
        }
        List<UploadingModel> newList = list
            .map((e) => UploadingModel(file: e, uploadedBytes: 0, totalBytes: 0, uploadError: false, uploading: false, uploadDone: false))
            .toList()
            .cast<UploadingModel>();

        currentList.addAll(newList);
        store.dispatch(SuccessMediaFileAction(
          files: currentList,
        ));
      } catch (_) {}
    };

ThunkAction<AppState> removeFile({required PlatformFile file}) => (Store<AppState> store) async {
      store.dispatch(ProcessingMediaFileAction());
      final FilesViewModel state = store.state.mediaFileState;
      List<UploadingModel> currentSelected = List.from(state.uploadQueue);

      if (currentSelected.isNotEmpty) {
        currentSelected.removeWhere((element) => element.file.hashCode == file.hashCode);
      }

      store.dispatch(SuccessMediaFileAction(
        files: currentSelected,
      ));
    };

ThunkAction<AppState> uploadFile({
  AssetEntity? photo,
  PlatformFile? pFile,
  required int index,
  required int elementId,
  required UploadEntityType entityType,
  required bool photoForObject,
  String? customFileName,
}) =>
    (Store<AppState> store) async {
      List<UploadingModel> currentQueue = photo != null ? List.from(store.state.mediaState.uploadQueue) : List.from(store.state.mediaFileState.uploadQueue);

      // Обновим Объект
      currentQueue[index] = UploadingModel(
        file: currentQueue[index].file,
        uploadedBytes: currentQueue[index].uploadedBytes,
        totalBytes: currentQueue[index].totalBytes,
        uploading: true,
        uploadDone: currentQueue[index].uploadDone,
        uploadError: currentQueue[index].uploadError,
      );

      if (photo != null) {
        store.dispatch(UploadingFileProcess(updatedQueue: currentQueue));
      } else {
        store.dispatch(UploadingPFileProcess(updatedQueue: currentQueue));
      }

      final StreamController<Map<String, int>> progressStreamController = StreamController();
      final File? file = photo != null
          ? await photo.file
          : pFile != null
              ? File(pFile.path!)
              : null;
      if (file != null) {
        try {
          UseCaseModule.protocol().uploadFile(
            elementId: elementId,
            file: file,
            progressStreamController: progressStreamController,
            entityType: entityType,
            photo: photoForObject,
            customFileName: customFileName,
          );
        } catch (e) {
          List<UploadingModel> currentQueue = List.from(store.state.mediaState.uploadQueue);
          currentQueue[index] = UploadingModel(
            file: currentQueue[index].file,
            uploadedBytes: currentQueue[index].uploadedBytes,
            totalBytes: currentQueue[index].totalBytes,
            uploading: false,
            uploadDone: false,
            uploadError: true,
          );

          if (photo != null) {
            store.dispatch(UploadingFileProcess(updatedQueue: currentQueue));
          } else {
            store.dispatch(UploadingPFileProcess(updatedQueue: currentQueue));
          }
        }

        await for (Map<String, int> p in progressStreamController.stream) {
          List<UploadingModel> currentQueueStream =
              photo != null ? List.from(store.state.mediaState.uploadQueue) : List.from(store.state.mediaFileState.uploadQueue);
          if (p['sent'] != p['total']) {
            currentQueueStream[index] = UploadingModel(
              file: currentQueueStream[index].file,
              uploadedBytes: p['sent'] ?? currentQueueStream[index].uploadedBytes,
              totalBytes: p['total'] ?? currentQueueStream[index].totalBytes,
              uploading: true,
              uploadDone: currentQueueStream[index].uploadDone,
              uploadError: currentQueueStream[index].uploadError,
            );
          } else {
            currentQueueStream[index] = UploadingModel(
              file: currentQueueStream[index].file,
              uploadedBytes: p['sent'] ?? currentQueueStream[index].uploadedBytes,
              totalBytes: p['total'] ?? currentQueueStream[index].totalBytes,
              uploading: false,
              uploadDone: true,
              uploadError: currentQueueStream[index].uploadError,
            );
          }

          if (photo != null) {
            store.dispatch(UploadingFileProcess(updatedQueue: currentQueueStream));
          } else {
            store.dispatch(UploadingPFileProcess(updatedQueue: currentQueueStream));
          }
        }
      }
    };
