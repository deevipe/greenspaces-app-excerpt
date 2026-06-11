class SearchOrgBody {
  final String userToken;
  final String query;

  SearchOrgBody({
    required this.userToken,
    required this.query,
  });

  Map<String, dynamic> toApi() => {'userTokenId': userToken, 'term': query};
}
