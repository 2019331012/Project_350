import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment/data/logout.dart';
import 'package:managment/data/savecred.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  late Map<String, String>? loggedInCred;

  @override
  void initState() {
    super.initState();
    final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
    loggedInCred = userCredProvider.cred;
  }

  Future<void> changePassword() async {
    String oldPassword = oldPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmNewPassword = confirmNewPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (newPassword != confirmNewPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New passwords do not match'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: oldPassword);
          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(newPassword);

          await Logout.logout(context); // Call the logout function

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password changed successfully'),
              duration: Duration(seconds: 2),
            ),
          );

          oldPasswordController.clear();
          newPasswordController.clear();
          confirmNewPasswordController.clear();
        } else {
          throw Exception('User not authenticated');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error changing password: $e'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Future<void> logout(BuildContext context) async {
  //   Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: Color(0xFF603300),
        iconTheme: IconThemeData(color: Colors.white), // Customizing app bar color
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(width: 2, color: Color(0xFF603300)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: oldPasswordController,
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                obscureText: true,
                cursorColor: Color(0xFF603300),
                style: TextStyle(color: Colors.black), // Text color for the input text
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(width: 2, color: Color(0xFF603300)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                obscureText: true,
                cursorColor: Color(0xFF603300),
                style: TextStyle(color: Colors.black), // Text color for the input text
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(width: 2, color: Color(0xFF603300)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: confirmNewPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                obscureText: true,
                cursorColor: Color(0xFF603300),
                style: TextStyle(color: Colors.black), // Text color for the input text
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                changePassword();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF603300), // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Change Password', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }
}
