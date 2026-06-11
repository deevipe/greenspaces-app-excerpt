import 'package:hive/hive.dart';

part 'select_entity.g.dart';

@HiveType(typeId: 6)
class SelectObject extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;

  SelectObject({required this.id, required this.title});

  factory SelectObject.fromJson(Map<String, dynamic> json) => SelectObject(id: json['id'], title: json['title']);

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}
