class ProtocolSeeder {
  static List<Map<String, dynamic>> getProtocolList() {
    List<Map<String, dynamic>> list = [];

    for (var i = 0; i < 15; i++) {
      list.add({
        'Id': i + 1,
        'Address': 'ул.Пограничника Гарькавого (от Петергофского шоссе до пр.Народного Ополчения), д.33',
        'Date': '2022-11-23T00:00:00+03:00',
      });
    }

    return list;
  }
}
