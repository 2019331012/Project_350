import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment/data/savecred.dart';
import 'package:provider/provider.dart';

class Logout {

  // Function to handle logout
  static Future<void> logout(BuildContext context) async {
    // Perform logout operation
    //await Hive.box('user_data').clear(); // Clear user data from Hive (if you are using Hive for storage)

    // Navigate to the login screen and clear the route stack
    await FirebaseAuth.instance.signOut();
    final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
    userCredProvider.setCred(null);
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

}
