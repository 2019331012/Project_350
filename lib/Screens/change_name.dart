import 'package:flutter/material.dart';
import 'package:managment/data/model/register_id.dart';
import 'package:managment/savecred.dart';
import 'package:provider/provider.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final TextEditingController oldNameController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();

  late Map<String, String>? loggedInCred;

  @override
  void initState() {
    super.initState();
    HiveAdapter.initialize(); // Initialize HiveAdapter
    final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
    loggedInCred = userCredProvider.cred;
    oldNameController.text = loggedInCred?['name'] ?? '';
  }


  // Function to handle changing the password
  void changeName() {
    String oldName = oldNameController.text;
    String newName = newNameController.text;
    
    // Add your validation logic here
    if (oldName.isEmpty || newName.isEmpty) {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (newName == oldName) {
      // Show error message if new passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The Names are the same.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Perform password change logic here (e.g., call API or update database)
      // After successful password change, show success message

      logger.d('LogginCredentials is $loggedInCred');
      HiveAdapter.changeName(context, loggedInCred?['email'] ?? '', oldName, newName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name has changed successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      
      // Clear text fields after successful password change
      //oldNameController.clear();
      newNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Name'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: oldNameController,
              decoration: InputDecoration(labelText: 'Old Name'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: newNameController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
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
    oldNameController.dispose();
    newNameController.dispose();
    super.dispose();
  }
}
