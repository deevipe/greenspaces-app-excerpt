import 'package:hive/hive.dart';

part 'element_type.g.dart';

@HiveType(typeId: 3)
class ElementType extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final List<int> workCatIds;

  ElementType({
    required this.id,
    required this.title,
    required this.workCatIds,
  });
}
