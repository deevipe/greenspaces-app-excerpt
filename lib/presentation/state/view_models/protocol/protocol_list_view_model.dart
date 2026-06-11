import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_item_entity.dart';

@immutable
class ProtocolListViewModel {
  final List<ProtocolListItem> list;
  final bool isLoading;
  final int page;
  final int? maxPage;
  final bool? loadingMore;
  final bool? isError;
  final String? errorMessage;
  final bool? revision;
  final int? idToDelete;

  const ProtocolListViewModel({
    required this.list,
    required this.isLoading,
    required this.page,
    this.maxPage,
    this.loadingMore,
    this.revision,
    this.isError,
    this.errorMessage,
    this.idToDelete,
  });

  factory ProtocolListViewModel.initial() => const ProtocolListViewModel(list: [], isLoading: false, revision: false, page: 1);

  ProtocolListViewModel copyWith({
    List<ProtocolListItem>? list,
    bool? loadingMore,
    int? page,
    int? maxPage,
    bool? revision,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    int? idToDelete,
  }) =>
      ProtocolListViewModel(
        list: list ?? this.list,
        loadingMore: loadingMore ?? this.loadingMore,
        revision: revision ?? this.revision,
        isLoading: isLoading ?? this.isLoading,
        page: page ?? this.page,
        maxPage: maxPage ?? this.maxPage,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        idToDelete: idToDelete,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolListViewModel &&
          runtimeType == other.runtimeType &&
          listEquals(list, other.list) &&
          page == other.page &&
          loadingMore == other.loadingMore &&
          maxPage == other.maxPage &&
          revision == other.revision &&
          isLoading == other.isLoading &&
          isError == other.isError &&
          idToDelete == other.idToDelete &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      list.hashCode ^
      isLoading.hashCode ^
      revision.hashCode ^
      isError.hashCode ^
      errorMessage.hashCode ^
      loadingMore.hashCode ^
      idToDelete.hashCode ^
      page.hashCode ^
      maxPage.hashCode;
}
