class ProtocolDetailBody {
  final String userToken;
  final int id;

  ProtocolDetailBody({
    required this.userToken,
    required this.id,
  });

  Map<String, dynamic> toApi() => {'userTokenId': userToken, 'id': id};
}
