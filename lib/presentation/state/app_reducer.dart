import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/app_navigation_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/auth_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/media_file_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/media_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/protocol/protocol_general_data_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/protocol/protocol_green_space_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/protocol/protocol_history_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/protocol/protocol_object_create_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/protocol/protocol_representatives_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/protocol/protocol_list_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/protocol/protocol_territory_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/protocol/protocol_work_category_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/protocol/protocol_work_condition_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/reducers/user_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    authScreenState: authReducer(state.authScreenState, action),
    userAppBarState: userReducer(state.userAppBarState, action),
    appNavState: appNavReducer(state.appNavState, action),
    protocolListState: protocolListReducer(state.protocolListState, action),
    protocolGeneralStepState: protocolGeneralReducer(state.protocolGeneralStepState, action),
    protocolCategoryStepState: protocolWorkCategoryReducer(state.protocolCategoryStepState, action),
    protocolConditionStepState: protocolWorkConditionReducer(state.protocolConditionStepState, action),
    protocolRepresentativesState: protocolRepresentativesReducer(
      state.protocolRepresentativesState,
      action,
    ),
    protocolTerritoryState: protocolTerritoryReducer(
      state.protocolTerritoryState,
      action,
    ),
    protocolGreenSpaceState: protocolGreenSpaceReducer(
      state.protocolGreenSpaceState,
      action,
    ),
    protocolCreateObjectState: protocolObjectCreateReducer(
      state.protocolCreateObjectState,
      action,
    ),
    protocolHistoryState: protocolHistoryReducer(
      state.protocolHistoryState,
      action,
    ),
    mediaState: mediaReducer(state.mediaState, action),
    mediaFileState: mediaFileReducer(state.mediaFileState, action),
  );
}
