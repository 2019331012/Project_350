import 'package:hive/hive.dart';

part 'credentials.g.dart';

@HiveType(typeId: 0)
class Credential {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String password;

  Credential(this.name, this.email, this.password);
}
