import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:managment/Screens/login.dart';
import 'package:managment/Screens/register.dart';
import 'package:managment/data/model/credentials.dart';
import 'package:managment/data/model/entry.dart';
import 'package:managment/data/savecred.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:managment/widgets/bottomnavigationbar.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  Hive.registerAdapter(EntryAdapter());
  Hive.registerAdapter(CredentialAdapter());
  await Hive.openBox<Add_data>('data');
  await Hive.openBox<Credential>('credBox');
  //await Hive.openBox<Map<String, String>>('credentialBox');
  await Firebase.initializeApp(); // Initialize HiveAdapter
  //runApp(const MyApp());

  Credential? use = await getCredentialFromStorage();
  Widget homeWidget = use != null ? Bottom() : MyLogin();

  Map<String, String>? cred;
  if (use?.name != null && use?.email != null) {
    cred = {'name': use!.name, 'email': use.email};
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserCredProvider(initialCred: cred),
      child: MyApp(homeWidget : homeWidget),
    ),
  );
}

Future<Credential?> getCredentialFromStorage() async {
  var credBox = Hive.box<Credential>('credBox');
  return credBox.get(1);
}

class MyApp extends StatelessWidget {
  
  final Widget homeWidget;

  const MyApp({Key? key, required this.homeWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeWidget,
      routes: {
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
      },
    );
  }
}
