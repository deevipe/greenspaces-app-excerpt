import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/app_navigation_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/files_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/media_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_general_data_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_green_space_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_history_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_object_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_representatives_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_list_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_territory_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_work_category_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_work_conditions_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/user/auth_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/user/user_view_model.dart';

@immutable
class AppState {
  final AuthViewModel authScreenState;
  final UserViewModel userAppBarState;
  final AppNavigationViewModel appNavState;
  final ProtocolListViewModel protocolListState;
  final ProtocolRepresentativesViewModel protocolRepresentativesState;
  final ProtocolGeneralViewModel protocolGeneralStepState;
  final ProtocolWorkCategoryViewModel protocolCategoryStepState;
  final ProtocolWorkConditionViewModel protocolConditionStepState;
  final ProtocolTerritoryViewModel protocolTerritoryState;
  final ProtocolGreenSpaceViewModel protocolGreenSpaceState;
  final ProtocolObjectViewModel protocolCreateObjectState;
  final ProtocolHistoryViewModel protocolHistoryState;
  final MediaViewModel mediaState;
  final FilesViewModel mediaFileState;

  const AppState({
    required this.authScreenState,
    required this.userAppBarState,
    required this.appNavState,
    required this.protocolListState,
    required this.protocolRepresentativesState,
    required this.protocolGeneralStepState,
    required this.protocolCategoryStepState,
    required this.protocolConditionStepState,
    required this.protocolTerritoryState,
    required this.protocolGreenSpaceState,
    required this.protocolCreateObjectState,
    required this.protocolHistoryState,
    required this.mediaState,
    required this.mediaFileState,
  });

  factory AppState.initialState() => AppState(
        authScreenState: AuthViewModel.initial(),
        userAppBarState: UserViewModel.initial(),
        appNavState: AppNavigationViewModel.initial(),
        protocolListState: ProtocolListViewModel.initial(),
        protocolRepresentativesState: ProtocolRepresentativesViewModel.initial(),
        protocolGeneralStepState: ProtocolGeneralViewModel.initial(),
        protocolCategoryStepState: ProtocolWorkCategoryViewModel.initial(),
        protocolConditionStepState: ProtocolWorkConditionViewModel.initial(),
        protocolTerritoryState: ProtocolTerritoryViewModel.initial(),
        protocolGreenSpaceState: ProtocolGreenSpaceViewModel.initial(),
        protocolCreateObjectState: ProtocolObjectViewModel.initial(),
        protocolHistoryState: ProtocolHistoryViewModel.initial(),
        mediaState: MediaViewModel.initial(),
        mediaFileState: FilesViewModel.initial(),
      );

  AppState copyWith({
    AuthViewModel? authScreenState,
    UserViewModel? userAppBarState,
    AppNavigationViewModel? appNavState,
    ProtocolListViewModel? protocolListState,
    ProtocolRepresentativesViewModel? protocolRepresentativesState,
    ProtocolGeneralViewModel? protocolGeneralStepState,
    ProtocolWorkCategoryViewModel? protocolCategoryStepState,
    ProtocolWorkConditionViewModel? protocolConditionStepState,
    ProtocolTerritoryViewModel? protocolTerritoryState,
    ProtocolGreenSpaceViewModel? protocolGreenSpaceState,
    ProtocolObjectViewModel? protocolCreateObjectState,
    ProtocolHistoryViewModel? protocolHistoryState,
    MediaViewModel? mediaState,
    FilesViewModel? mediaFileState,
  }) =>
      AppState(
        authScreenState: authScreenState ?? this.authScreenState,
        userAppBarState: userAppBarState ?? this.userAppBarState,
        appNavState: appNavState ?? this.appNavState,
        protocolListState: protocolListState ?? this.protocolListState,
        protocolGeneralStepState: protocolGeneralStepState ?? this.protocolGeneralStepState,
        protocolCategoryStepState: protocolCategoryStepState ?? this.protocolCategoryStepState,
        protocolConditionStepState: protocolConditionStepState ?? this.protocolConditionStepState,
        protocolRepresentativesState: protocolRepresentativesState ?? this.protocolRepresentativesState,
        protocolTerritoryState: protocolTerritoryState ?? this.protocolTerritoryState,
        protocolGreenSpaceState: protocolGreenSpaceState ?? this.protocolGreenSpaceState,
        protocolCreateObjectState: protocolCreateObjectState ?? this.protocolCreateObjectState,
        protocolHistoryState: protocolHistoryState ?? this.protocolHistoryState,
        mediaState: mediaState ?? this.mediaState,
        mediaFileState: mediaFileState ?? this.mediaFileState,
      );
}
