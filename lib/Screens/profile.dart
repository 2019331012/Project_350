import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Make sure to import necessary dependencies

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the screen where user can change their name
                // You can implement this navigation logic according to your app's navigation stack
              },
              child: Text('Change Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the screen where user can change their password
                // You can implement this navigation logic according to your app's navigation stack
              },
              child: Text('Change Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Perform logout operation
                // For example, you can clear user data and navigate to login screen
                await Hive.box('user_data').clear(); // Clear user data from Hive (if you are using Hive for storage)
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // Navigate to login screen and clear the route stack
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
