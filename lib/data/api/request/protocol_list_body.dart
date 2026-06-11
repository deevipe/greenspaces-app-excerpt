class ProtocolListBody {
  final String userToken;
  // final bool revision;
  final int page;
  final int count;
  ProtocolListBody({
    required this.userToken,
    // required this.revision,
    required this.count,
    required this.page,
  });

  Map<String, dynamic> toApi() => {'userTokenId': userToken, 'listType': 'new', 'page': page, 'count': count};
}
