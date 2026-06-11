import 'package:hive_flutter/hive_flutter.dart';

part 'area_type.g.dart';

@HiveType(typeId: 11)
class AreaType extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String layerUrl;

  AreaType({required this.id, required this.title, required this.layerUrl});

  factory AreaType.fromJson(Map<String, dynamic> json) => AreaType(id: json['id'], title: json['title'], layerUrl: json['layerUrl']);

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'layerUrl': layerUrl};
}
