class RequisitesComponents {
  final String number;
  final String date;

  const RequisitesComponents({required this.number, required this.date});

  factory RequisitesComponents.fromJson(Map<String, dynamic> json) => RequisitesComponents(
        number: json['number'],
        date: json['date'],
      );

  Map toJson() => {
        'number': number,
        'date': date,
      };
}
