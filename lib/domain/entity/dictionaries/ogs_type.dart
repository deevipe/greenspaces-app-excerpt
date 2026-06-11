import 'package:hive/hive.dart';

part 'ogs_type.g.dart';

@HiveType(typeId: 5)
class OgsType extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int elementTypeId;

  OgsType({
    required this.id,
    required this.title,
    required this.elementTypeId,
  });
}
