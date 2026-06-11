class CustomDictionaryBody {
  final String userTokenId;
  final String dictionaryCode;

  CustomDictionaryBody({required this.dictionaryCode, required this.userTokenId});

    Map<String, dynamic> toApi() => {
        'userTokenId': userTokenId,
        'id': dictionaryCode,
      };
}
