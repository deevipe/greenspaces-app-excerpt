import 'package:hive/hive.dart';

part 'user_entity.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? surname;

  @HiveField(3)
  final String? lastName;

  @HiveField(4)
  final String token;

  @HiveField(5)
  final String department;

  User({required this.id, required this.token, required this.department, this.name, this.surname, this.lastName});

  factory User.initial() => User(id: 0, token: '', department: '');
}
