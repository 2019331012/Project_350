import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment/data/savecred.dart';
import 'package:provider/provider.dart';

//final Logger logger = Logger();


class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final TextEditingController newNameController = TextEditingController();

  late Map<String, String>? loggedInCred;

  @override
  void initState() {
    super.initState(); // Initialize HiveAdapter
    final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
    loggedInCred = userCredProvider.cred;
  }

  // Function to handle changing the name
  Future<void> changeName() async {
    String oldName = loggedInCred?['name'] ?? '';
    String newName = newNameController.text;

    // Add your validation logic here
    if (newName.isEmpty) {
      // Show error message if the new name field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a new name'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (newName == oldName) {
      // Show error message if the new name is the same as the old name
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The new name cannot be the same as the old name.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Perform name change logic here (e.g., call API or update database)
      // After successful name change, show success message

      //logger.d('LoggingCredentials: $loggedInCred');
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // Update the user's name in Firestore based on their UID
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid) // Assuming 'users' is the collection name
              .update({'name': newName});

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Name has been changed successfully'),
              duration: Duration(seconds: 2),
            ),
          );

          loggedInCred?['name'] = newName;
          final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
          userCredProvider.setCred(loggedInCred);
        } catch (e) {
          // Handle errors (e.g., network issues, Firestore write errors, etc.)
          print('Error updating name: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update name. Please try again later.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      // Clear the new name text field after successful name change
      newNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String oldName = loggedInCred?['name'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Name'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                'Current Name:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(oldName),
              enabled: false, // This makes the ListTile uneditable
            ),
            SizedBox(height: 16),
            TextField(
              controller: newNameController,
              decoration: InputDecoration(labelText: 'New Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: changeName,
              child: Text('Change Name'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    newNameController.dispose();
    super.dispose();
  }
}
