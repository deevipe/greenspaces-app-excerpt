import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/app_navigation_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_form_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_list_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_list_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/delete_button_icon.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_item_entity.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_list_item_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/shimmer_loading/shimmer_general.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/shimmer_loading/shimmer_loader.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';

class ProtocolListWidget extends StatefulWidget {
  final ScrollController scrollController;
  final List<ProtocolListItem> list;
  final bool loadingMore;
  final int page;
  final int? maxPage;
  final int? protocolToDelete;
  const ProtocolListWidget(
      {super.key, required this.scrollController, required this.list, required this.loadingMore, required this.page, this.maxPage, this.protocolToDelete});

  @override
  State<ProtocolListWidget> createState() => _ProtocolListWidgetState();
}

class _ProtocolListWidgetState extends State<ProtocolListWidget> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  dynamic _showWarningDialog({required int index}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        BtnLabel.cancel,
        style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        BtnLabel.confirm,
        style: AppTextStyle.openSans12W400.apply(color: AppColors.secondaryDark),
      ),
      onPressed: () {
        StoreProvider.of<AppState>(context).dispatch(removeProtocol(id: widget.list[index].id));
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(AppDictionary.confirmTitle),
      content: Text('Вы действительно хотите удалить протокол с ID: ${widget.list[index].id}?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent * .80 && !widget.loadingMore) {
      _loadMore();
    }
  }

  void _loadMore() {
    final ProtocolListViewModel state = StoreProvider.of<AppState>(context).state.protocolListState;

    if ((state.maxPage ?? 0) > state.page) {
      StoreProvider.of<AppState>(context)
          .dispatch(getProtocolList(completer: null, revision: state.revision ?? false, page: state.page + 1, loadingMore: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.custom(
      padding: EdgeInsets.zero,
      key: const PageStorageKey('ProtocolList'),
      // physics: const ClampingScrollPhysics(),
      controller: widget.scrollController,
      childrenDelegate: SliverChildBuilderDelegate(
        (_, int index) {
          return InkwellButton(
            key: UniqueKey(),
            function: () async {
              StoreProvider.of<AppState>(context).dispatch(prepareProtocolForRevison(protocolId: widget.list[index].id));
              StoreProvider.of<AppState>(context).dispatch(UpdateAppNavigation(
                formIsOpen: true,
              ));
              context.tabsRouter.setActiveIndex(1);
            },
            child: widget.loadingMore == true && index == widget.list.length
                ? const Loader(color: AppColors.green)
                : Shimmer(
                    linearGradient: HelperUtils.getShimmerGradient(),
                    child: ShimmerLoading(
                      isLoading: widget.list[index].id == widget.protocolToDelete,
                      child: Stack(
                        children: [
                          ProtocolListItemWidget(
                            id: widget.list[index].id.toString(),
                            address: widget.list[index].address,
                            date: widget.list[index].dateString,
                            last: index == widget.list.length - 1,
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: InkwellButton(
                              function: () => _showWarningDialog(index: index),
                              child: const DeleteIcon(
                                background: AppColors.transparent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          );
        },
        childCount: widget.loadingMore == true ? widget.list.length + 1 : widget.list.length,
      ),
    );
  }
}
