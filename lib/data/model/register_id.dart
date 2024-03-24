import 'package:hive/hive.dart';

class HiveAdapter {
  static late Box<String> passwordBox;

  static Future<void> initialize() async {
    await Hive.openBox<String>('passwordBox');
    passwordBox = Hive.box<String>('passwordBox');
  }

  static void savePassword(String password) {
    passwordBox.put('password', password);
  }

  static String? getPassword() {
    return passwordBox.get('password');
  }
}
