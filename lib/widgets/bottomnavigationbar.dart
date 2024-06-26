import 'package:flutter/material.dart';
import 'package:managment/Screens/add.dart';
import 'package:managment/Screens/home.dart';
import 'package:managment/Screens/search.dart';
import 'package:managment/Screens/statistics.dart';
import 'package:managment/Screens/profile.dart';

class Bottom extends StatefulWidget {

  //final Map<String, String> cred;

  const Bottom(/*{Key? key, required this.cred}*/{Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  late List<Widget> screens;
  int indexColor = 0;

  @override
  void initState() {
    super.initState();
    screens = [
      Home(),
      Statistics(),
      Search(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[indexColor],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Add_Screen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF603300),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: indexColor == 0 ? Color(0xFF603300) : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: indexColor == 1 ? Color(0xFF603300) : Colors.grey,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 2;
                  });
                },
                child: Icon(
                  Icons.search_outlined,
                  size: 30,
                  color: indexColor == 2 ? Color(0xFF603300) : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 3;
                  });
                },
                child: Icon(
                  Icons.person_outlined,
                  size: 30,
                  color: indexColor == 3 ? Color(0xFF603300) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
