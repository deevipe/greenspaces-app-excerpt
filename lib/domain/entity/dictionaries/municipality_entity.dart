import 'package:hive/hive.dart';

part 'municipality_entity.g.dart';

@HiveType(typeId: 10)
class Municipality {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int districtId;
  @HiveField(3)
  final String oktmo;

  Municipality({
    required this.id,
    required this.districtId,
    required this.title,
    required this.oktmo,
  });

  factory Municipality.fromJson(Map<String, dynamic> json) => Municipality(
        id: json['id'],
        districtId: json['districId'],
        title: json['title'],
        oktmo: json['oktmo'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'districtId': districtId,
        'oktmo': oktmo,
      };
}
