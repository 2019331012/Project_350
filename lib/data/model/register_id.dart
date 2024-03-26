import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class HiveAdapter {
  static late Box<Map<String, String>> credentialsBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox<Map<String, String>>('credentialsBox');
    credentialsBox = Hive.box<Map<String, String>>('credentialsBox');
  }

  static void saveCredentials(String name, String email, String password) {
    final credentials = {'name': name, 'email': email, 'password': password};
    credentialsBox.put(email, credentials);
  }

  static Map<String, String>? getCredentials(String email) {
    try {
      final dynamic credentials = credentialsBox.get(email);
      logger.d('Credentials for $email: $credentials');
      if (credentials != null && credentials is Map<String, dynamic>) {
        return credentials.cast<String, String>();
      }
    } catch (e) {
      logger.e('Error retrieving credentials: $e');
    }
    return null;
  }


  static String getName(String email) {
    final Map<String, String>? userData =  getCredentials(email);
    return userData != null && userData.containsKey('name') ? userData['name'] ?? '' : '';
  }
  
  static String? getPassword(String email) {
    final Map<String, String>? userData = getCredentials(email);
    return userData != null && userData.containsKey('password') ? userData['password'] ?? '' : '';
  }
  
  static String? getEmail(String email) {
    return credentialsBox.containsKey(email) ? email : null;
  }

  static bool changePassword(String email, String oldPassword, String newPassword) {
    final Map<String, String>? userData = getCredentials(email);
    if (userData != null) {
      if(userData['password'] != oldPassword){
        return false;
      }
      userData['password'] = newPassword;
      credentialsBox.put(email, userData);
      return true;
    }
    return false;
  }

}
