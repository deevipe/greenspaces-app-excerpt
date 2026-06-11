import 'package:hive/hive.dart';

part 'action_type.g.dart';

@HiveType(typeId: 2)
class ActionType extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int elementTypeId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final List<int> parentIds;

  ActionType({required this.id, required this.title, required this.elementTypeId, required this.parentIds});
}
