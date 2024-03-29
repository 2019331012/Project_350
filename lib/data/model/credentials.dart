import 'package:hive/hive.dart';

part 'credentials.g.dart';

@HiveType(typeId: 0)
class Credential {
  @HiveField(0)
  late String email;

  @HiveField(1)
  late String password;

  Credential(this.email, this.password);
}
