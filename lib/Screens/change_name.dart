import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment/data/savecred.dart';
import 'package:provider/provider.dart';

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
    super.initState();
    final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
    loggedInCred = userCredProvider.cred;
  }

  Future<void> changeName() async {
    String oldName = loggedInCred?['name'] ?? '';
    String newName = newNameController.text;

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a new name'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (newName == oldName) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The new name cannot be the same as the old name.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'name': newName});

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
          print('Error updating name: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update name. Please try again later.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      newNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String oldName = loggedInCred?['name'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Name',
          style: TextStyle(color: Colors.white), // Setting title color to white
        ),
        backgroundColor: Color(0xFF603300), // Customizing app bar color
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
              enabled: false,
            ),
            SizedBox(height: 16),
            TextField(
              controller: newNameController,
              decoration: InputDecoration(
                labelText: 'New Name',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 2, color: Color(0xFF603300)),
                ),
              ),
              cursorColor: Color(0xFF603300),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: changeName,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF603300), // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Change Name', style: TextStyle(color: Colors.white)),
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
