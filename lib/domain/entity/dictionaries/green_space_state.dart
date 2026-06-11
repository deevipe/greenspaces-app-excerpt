import 'package:hive/hive.dart';

part 'green_space_state.g.dart';

@HiveType(typeId: 4)
class GreenSpaceState extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final bool? isDefault;
  @HiveField(3)
  final List<int>? workCatIds;
  @HiveField(4)
  final List<int> elementTypeIds;

  GreenSpaceState({
    required this.id,
    required this.title,
    this.isDefault,
    this.workCatIds,
    required this.elementTypeIds,
  });
}
