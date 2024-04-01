import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:managment/data/model/credentials.dart';
import 'package:managment/data/savecred.dart';
import 'package:provider/provider.dart';
import 'package:managment/widgets/bottomnavigationbar.dart';

//final Logger logger = Logger();

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool isChecked = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final credBox = Hive.box<Credential>('credBox');
  final box = Hive.box<Add_data>('data');

  @override
  void initState() {
    super.initState();
    getdata2();
  }

  void getdata2(){
    
    //logger.d('Just making sure getdata2 is being called properly');
    final x = credBox.get(0);
    String? savedEmail = x?.email;
    String? savedPassword = x?.password;
    if (savedEmail != null && savedPassword != null) {
      email.text = savedEmail;
      password.text = savedPassword;
      isChecked = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: email,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: password,
                            style: TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Remember Me",
                                style: TextStyle(color: Colors.black),
                              ),
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState((){
                                    isChecked = value ?? false;

                                    if(isChecked){
                                      credBox.put(0, Credential('Guest', email.text.trim(), password.text));
                                      //logger.d('email and password in credbox if statement. ${credBox.keys.toList()} and ${credBox.values.toList()}');
                                    } else{
                                      credBox.delete(0);
                                      //logger.d('email and password in credbox else statement. ${credBox.keys.toList()} and ${credBox.values.toList()}');
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xFF603300),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    login();
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'register');
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xFF603300),
                                    fontSize: 18,
                                  ),
                                ),
                                style: ButtonStyle(),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Add forgot password logic here
                                },
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xFF603300),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );

      if (userCredential.user != null) {
        // Login successful, navigate to home screen
        
        getData();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return Bottom();
          }),
        );
      } else {
        // Handle error or show error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Invalid email or password'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle error or show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again later.\n $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Get the user's document from Firestore based on their UID
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Assuming 'users' is the collection name
            .get();

        if (documentSnapshot.exists) {
          // The document exists, retrieve the data
          Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;
          
          String userName = userData['name']; // Access the 'name' field

          final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
          userCredProvider.setCred({'name': userName, 'email': user.email ?? ''/*email.text.trim()*/});

          credBox.put(1, Credential(userName, email.text.trim(), password.text));

          CollectionReference dataCollectionRef = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('data');

          QuerySnapshot dataCollectionSnapshot = await dataCollectionRef.get();

          dataCollectionSnapshot.docs.forEach((dataDoc) {
            Map<String, dynamic> map = {...dataDoc.data() as Map<String, dynamic>,...{'id': dataDoc.id}};
            box.add(Add_data.fromMap(map));
          });
          // Print or use the retrieved data as needed
          print('User Name: $userName');
          dataCollectionSnapshot.docs.forEach((dataDoc) =>
              print('Data Collection Snapshot is ${dataDoc.data()}')
          );

        } else {
          print('User document does not exist');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('User is not signed in');
    }
  }

}
