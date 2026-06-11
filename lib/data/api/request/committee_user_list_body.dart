class CommitteeUserListBody {
  final String userToken;
  final String committeeId;
  CommitteeUserListBody({required this.userToken, required this.committeeId});

  Map<String, dynamic> toApi() => {
        'userTokenId': userToken,
        'committeeId': committeeId,
      };
}
