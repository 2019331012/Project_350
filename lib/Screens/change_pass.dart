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
    super.initState(); // Initialize HiveAdapter
    final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
    loggedInCred = userCredProvider.cred;
  }


  // Function to handle changing the password

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
          // Re-authenticate the user to ensure the old password is correct
          AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: oldPassword);
          await user.reauthenticateWithCredential(credential);

          // Change the user's password
          await user.updatePassword(newPassword);

          // Logout after password change
          await Logout.logout(context);
          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password changed successfully'),
              duration: Duration(seconds: 2),
            ),
          );

          // Clear text fields after successful password change
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

  // Future<void> changePassword() async {
  //   String oldPassword = oldPasswordController.text.trim();
  //   String newPassword = newPasswordController.text.trim();
  //   String confirmNewPassword = confirmNewPasswordController.text.trim();

  //   // Add your validation logic here
  //   if (oldPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) {
  //     // Show error message if any field is empty
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Please fill in all fields'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   } else if (newPassword != confirmNewPassword) {
  //     // Show error message if new passwords do not match
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('New passwords do not match'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   } else {
  //     // Perform password change logic here (e.g., call API or update database)
  //     // After successful password change, show success message

  //     logger.d('LogginCredentials is $loggedInCred');
  //     bool x = HiveAdapter.changePassword(loggedInCred?['email'] ?? '', oldPassword, newPassword);

  //     if(!x){
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Old password do not match'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     } else{

  //       await logout(context);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Password changed successfully'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     }

      
  //     // Clear text fields after successful password change
  //     oldPasswordController.clear();
  //     newPasswordController.clear();
  //     confirmNewPasswordController.clear();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: InputDecoration(labelText: 'Old Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmNewPasswordController,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                changePassword();
              },
              child: Text('Change Password'),
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
  
  Future<void> logout(BuildContext context) async {
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }
}
