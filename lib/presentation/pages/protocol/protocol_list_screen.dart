import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_list_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_list_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_list_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/custom_refresh_indicator.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/error_message_text.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';

class ProtocolListScreen extends StatefulWidget {
  const ProtocolListScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolListScreen> createState() => _ProtocolListScreenState();
}

class _ProtocolListScreenState extends State<ProtocolListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<dynamic> refreshCallback() {
    final Completer completer = Completer();
    StoreProvider.of<AppState>(context)
        .dispatch(getProtocolList(completer: completer, revision: StoreProvider.of<AppState>(context).state.protocolListState.revision ?? false, page: 1));

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtocolListViewModel>(
      converter: (store) => store.state.protocolListState,
      onInit: (store) => store.state.protocolListState.list.isNotEmpty
          ? null
          : store.dispatch(getProtocolList(completer: null, revision: StoreProvider.of<AppState>(context).state.protocolListState.revision ?? false, page: 1)),
      distinct: true,
      builder: (_, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 150,
              builder: (
                BuildContext context,
                RefreshIndicatorMode refreshState,
                double pulledExtent,
                double refreshTriggerPullDistance,
                double refreshIndicatorExtent,
              ) {
                return CustomRefreshIndicator(
                  refreshState: refreshState,
                  pulledExtent: pulledExtent,
                  refreshTriggerPullDistance: refreshTriggerPullDistance,
                  refreshIndicatorExtent: refreshIndicatorExtent,
                );
              },
              onRefresh: () async {
                return refreshCallback();
              },
            ),
            (state.isLoading || state.isError == true || state.list.isEmpty)
                ? SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProjectScreenHeader(
                              title: StoreProvider.of<AppState>(context).state.protocolListState.revision == true
                                  ? ProtocolHeaderTitles.protocolRevisionProjectHeader
                                  : ProtocolHeaderTitles.protocolProjectHeader),
                          state.isLoading
                              ? const Expanded(
                                  child: Center(
                                    child: Loader(),
                                  ),
                                )
                              : state.isError == true
                                  ? Expanded(
                                      child: Center(
                                        child: ErrorMessageText(message: state.errorMessage ?? GeneralErrors.generalError),
                                      ),
                                    )
                                  : const Expanded(
                                      child: Center(
                                        child: ErrorMessageText(message: GeneralErrors.emptyProtocolDraft),
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProjectScreenHeader(
                                  title: StoreProvider.of<AppState>(context).state.protocolListState.revision == true
                                      ? ProtocolHeaderTitles.protocolRevisionProjectHeader
                                      : ProtocolHeaderTitles.protocolProjectHeader),
                              SizedBox(
                                height: MediaQuery.of(context).size.height - 260 > 0 ? MediaQuery.of(context).size.height - 260 : 0,
                                child: ProtocolListWidget(
                                  scrollController: _scrollController,
                                  list: state.list,
                                  loadingMore: state.loadingMore ?? false,
                                  page: state.page,
                                  maxPage: state.maxPage,
                                  protocolToDelete: state.idToDelete,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
          ],
        );
      },
    );
  }
}
