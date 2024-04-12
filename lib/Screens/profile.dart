import 'package:flutter/material.dart';
import 'package:managment/Screens/change_name.dart';
import 'package:managment/Screens/change_pass.dart';
// Make sure to import necessary dependencies
import 'package:managment/data/logout.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
        style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
        automaticallyImplyLeading: false,
        centerTitle: true, // Remove the back arrow
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Change Name'),
                    onTap: () {
                      // Navigate to the screen where user can change their name
                      // You can implement this navigation logic according to your app's navigation stack

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeName(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Password'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(),
                        ),
                      );
                      // Navigate to the screen where user can change their password
                      // You can implement this navigation logic according to your app's navigation stack
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Logout'),
                    onTap: () async {
                      // Call the logout function when "Logout" is tapped
                      await Logout.logout(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
