import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Add_Screen extends StatefulWidget {
  const Add_Screen({super.key});

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}

class _Add_ScreenState extends State<Add_Screen> {
  final box = Hive.box<Add_data>('data');
  DateTime date = new DateTime.now();
  String? selctedItem;
  String? selctedItemi;
  final TextEditingController expalin_C = TextEditingController();
  FocusNode ex = FocusNode();
  final TextEditingController amount_c = TextEditingController();
  FocusNode amount_ = FocusNode();
  final List<String> _item = [
    'food',
    "Transfer",
    "Transportation",
    "Education"
  ];
  final List<String> _itemei = [
    'Income',
    "Expand",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ex.addListener(() {
      setState(() {});
    });
    amount_.addListener(() {
      setState(() {});
    });
    selctedItemi = _itemei[0];
  }

  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade100,
    body: SafeArea(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          background_container(context),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 100), // Adjust this padding as needed
              child: main_container(),
            ),
          ),
        ],
      ),
    ),
  );
}


  Container main_container() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: 600,
      width: 340,
      child: Column(
        children: [
          SizedBox(height: 50),
          How(),
          SizedBox(height: 30),
          name(),
          SizedBox(height: 30),
          amount(),
          SizedBox(height: 30),
          explain(),
          SizedBox(height: 30),
          date_time(),
          Spacer(),
          save(),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  // Container main_container() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       color: Colors.white,
  //     ),
  //     height: 200, // Reduced height for the row layout
  //     width: 340,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align columns evenly
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           flex: 3, // Flex for Amount widget
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               amount(),
  //               SizedBox(height: 10), // Adjust spacing as needed
  //               date_time(),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           flex: 4, // Flex for Explain widget
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               explain(),
  //               SizedBox(height: 10), // Adjust spacing as needed
  //               save(),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }


  GestureDetector save() {
    return GestureDetector(
      onTap: () async {
        var add = Add_data(
            selctedItemi!, amount_c.text, date, expalin_C.text, selctedItem!);
        box.add(add);
        User? user = FirebaseAuth.instance.currentUser;

        if(user != null){
          try{
            await FirebaseFirestore.instance.collection('users')
            .doc(user.uid)
            .collection('data')
            .add(add.toMap());
        
          }catch (e) {
            print('Error fetching user data: $e');
          }
        }
    
        Navigator.of(context).pop();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:  Color(0xFF603300),
        ),
        width: 120,
        height: 50,
        child: Text(
          'Save',
          style: TextStyle(
            fontFamily: 'f',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget date_time() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Color(0xffC5C5C5))),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100));
          if (newDate == Null) return;
          setState(() {
            date = newDate!;
          });
        },
        child: Text(
          'Date : ${date.year} / ${date.day} / ${date.month}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Padding How() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 0,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                selctedItemi = _itemei[0];
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selctedItemi == _itemei[0] ? Colors.green : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(_itemei[0]),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selctedItemi = _itemei[1];
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selctedItemi == _itemei[1] ? Colors.red : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(_itemei[1]),
          ),
        ],
      ),
    ),
  );
}

  Padding amount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: TextInputType.number,
        focusNode: amount_,
        controller: amount_c,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'amount',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color:  Color(0xFF603300))),
        ),
      ),
    );
  }


  Padding explain() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        focusNode: ex,
        controller: expalin_C,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'explain',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Color(0xFF603300))),
        ),
      ),
    );
  }

  Padding name() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: Color(0xffC5C5C5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: selctedItem,
            onChanged: ((value) {
              setState(() {
                selctedItem = value!;
              });
            }),
            items: [
              ..._item.map((e) => DropdownMenuItem(
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        child: Image.asset('images/${e}.png'),
                      ),
                      SizedBox(width: 10),
                      Text(
                        e,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
                value: e,
              )).toList(),
              DropdownMenuItem(
                value: 'custom',
                child: Row(
                  children: [
                    Image.asset('images/custom.png', width: 40), // Add the custom icon here
                    SizedBox(width: 10),
                    Text('Custom'),
                  ],
                ),
              ),
            ],
            selectedItemBuilder: (BuildContext context) => [
              ..._item.map((e) => Row(
                children: [
                  Container(
                    width: 42,
                    child: Image.asset('images/${e}.png'),
                  ),
                  SizedBox(width: 5),
                  Text(e)
                ],
              )).toList(),
              Row(
                children: [
                  Image.asset('images/custom.png', width: 42), // Add the custom icon here
                  SizedBox(width: 5),
                  Text('Custom')
                ],
              ),
            ],
            hint: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Category',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            underline: Container(),
          ),
          if (selctedItem == 'custom') ...[
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Custom Category',
                labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 2, color: Color(0xFF603300)),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}



  Column background_container(BuildContext context) {
    return Column(
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
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Text(
                      'Adding',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Icon(
                      Icons.attach_file_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
