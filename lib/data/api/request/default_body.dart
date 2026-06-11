class DefaultBody {
  final String? userToken;

  const DefaultBody({this.userToken});

  Map<String, dynamic> toApi() => {
        'userTokenId': userToken ?? '',
      };
}
