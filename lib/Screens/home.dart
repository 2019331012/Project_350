import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:managment/data/dateAction.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:managment/data/utlity.dart';
import 'package:managment/data/savecred.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;



class Home extends StatefulWidget {
  
  //final Map<String, String> cred;
  
  const Home(/*{Key? key, required this.cred}*/{Key? key}) : super(key: key);


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  var history;
  final box = Hive.box<Add_data>('data');
  void clearData() {
    box.clear();
  }
  final List<String> day = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];

  late Map<String, String>? loggedInCred;

  @override
  void initState() {
    super.initState();
    // final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
    // loggedInCred = userCredProvider.cred;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, value, child) {

                List<DateTime> uniqueDates = DateAction.getUniqueDates(box); // Function to get unique dates from history

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: 340, child: _head()),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions History',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'See all',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        // (context, index) {
                        //   int reversedIndex = box.length - 1 - index;
                        //   history = box.values.toList()[reversedIndex];
                        //   return getList(history, reversedIndex);
                        // },
                        // childCount: box.length,
                        (context, index) {
                          DateTime currentDate = uniqueDates[index];
                          List<Add_data> histories = DateAction.getHistoriesByDate(box, currentDate); // Function to get histories by date
                          return getHistoryGroup(currentDate, histories);
                        },
                        childCount: uniqueDates.length,
                      ),
                    )
                  ],
                );
              }
          )
      ),
    );
  }

  Widget getHistoryGroup(DateTime date, List<Add_data> histories) {

    double total = calculateTotalAmount(histories);

    return Dismissible(
      key: Key(date.toString()), // Use date as the key for Dismissible
      onDismissed: (direction) {
        DateAction.deleteHistories(firestore, user, histories); // Function to delete histories
      },
      child: ExpansionTile(
        // title: Text(
        //   '${day[date.weekday - 1]}  ${date.year}-${date.day}-${date.month}',
        //   style: TextStyle(fontWeight: FontWeight.w600),
        // ),
        leading: Icon(Icons.arrow_drop_down), // Add a down-arrow icon
        title: Text(
          '${day[date.weekday - 1]}  ${date.year}-${date.day}-${date.month}',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Contains a List of entries of that time.',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          '${total.abs()}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            color: /*history.IN == 'Income'*/ total>0 ? Colors.green : Colors.red,
          ),
        ),
        children: histories.map((history) => getList(history)).toList(),
      ),
    );
  }



  Widget getList(Add_data history) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          firestore.collection('users')
            .doc(user?.uid)
            .collection('data')
            .doc(history.documentId).delete();
          history.delete();
        },
        child: get(history));
  }
  Future<bool> _imageExists(String imagePath) async {
  try {
    // Check if the image file exists
    await rootBundle.load(imagePath);
    return true;
  } catch (error) {
    return false;
  }
  }

  ListTile get(Add_data history) {
    String imagePath = 'images/${history.name}.png';
    
    // Check if the image exists, if not, use the default image
    _imageExists(imagePath).then((exists) {
      if (!exists) {
        imagePath = 'images\custom.png';
      }
    });

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(imagePath, height: 40),
      ),
      title: Text(
        history.name,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${day[history.datetime.weekday - 1]}  ${history.datetime.year}-${history.datetime.day}-${history.datetime.month}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        '${history.entries.total}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: history.IN == 'Income' ? Colors.green : Colors.red,
        ),
      ),
    );
  }


  Widget _head() {
    
    return FutureBuilder<Map<String, String>?>(
      future: _getLoggedInCred(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting
        }

        // Check if loggedInCred is not null, otherwise use a default name
        String name = snapshot.data?['name'] ?? 'Guest';

        
        
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Color(0xFF603300),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Positioned(
                      //   top: 35,
                      //   left: 300,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(7),
                      //     child: Container(
                      //       height: 100,
                      //       width: 40,
                      //       color: Color.fromRGBO(250, 250, 250, 0.1),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Day',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 224, 223, 223),
                              ),
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 140,
              left: MediaQuery.of(context).size.width / 2 - 140,
              child: Container(
                height: 170,
                width: 280,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 6),
                      blurRadius: 12,
                      spreadRadius: 6,
                    ),
                  ],
                  color: Color(0xFF361500),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text(
                            '\$ ${total()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor: Color(0xFF603300),
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Income',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 216, 216, 216),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor:  Color(0xFF603300),
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Expenses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 216, 216, 216),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$ ${income()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '\$ ${expenses()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }


  Future<Map<String, String>?> _getLoggedInCred() async {
    final userCredProvider = Provider.of<UserCredProvider>(context, listen: false);
    return userCredProvider.cred;
  }
}
