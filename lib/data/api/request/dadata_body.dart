class DadataRequestBody {
  final String query;
  DadataRequestBody({required this.query});

    Map<String, dynamic> toApi() => {
    'query': query,
  };
}
