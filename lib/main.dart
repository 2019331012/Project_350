import 'package:flutter/material.dart';
import 'package:managment/Screens/home.dart';
import 'package:managment/Screens/login.dart';
import 'package:managment/Screens/register.dart';
import 'package:managment/Screens/statistics.dart';
import 'package:managment/data/model/register_id.dart';
import 'package:managment/savecred.dart';
import 'package:managment/widgets/bottomnavigationbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<Add_data>('data');
  await HiveAdapter.initialize(); // Initialize HiveAdapter
  //runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserCredProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyLogin(),
      routes: {
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
      },
    );
  }
}
