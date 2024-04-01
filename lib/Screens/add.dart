import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:managment/data/model/entry.dart';

class Add_Screen extends StatefulWidget {
  const Add_Screen({Key? key}) : super(key: key);

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}

class _Add_ScreenState extends State<Add_Screen> {
  final box = Hive.box<Add_data>('data');
  DateTime date = DateTime.now();
  String? selectedItem;
  String? selectedItemi;
  final TextEditingController explainController = TextEditingController();
  final List<String> types = ['Income', 'Expense'];
  List<Entry> entries = [Entry('', 0.0, 0.0, 0.0)]; // Initial entry

  @override
  void initState() {
    super.initState();
    selectedItemi = types[0];
  }

  double calculateContainerHeight() {
    double entryWidgetHeight = 300.0;

    double totalHeight = (entries.length * entryWidgetHeight) + 250.0;
    return totalHeight;
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    for (var entry in entries) {
      totalAmount += entry.unitPrice * entry.quantity;
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            backgroundContainer(context),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: mainContainer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: calculateContainerHeight() + 300,
      width: 500,
      child: Column(
        children: [
          SizedBox(height: 50),
          how(),
          SizedBox(height: 30),
          for (var entryIndex = 0; entryIndex < entries.length; entryIndex++)
            entryWidget(entryIndex),
          addEntryButton(),
          SizedBox(height: 30),
          dateTime(),
          Spacer(),
          save(),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget entryWidget(int entryIndex) {
    double totalAmount = entries[entryIndex].unitPrice * entries[entryIndex].quantity;
    entries[entryIndex].total = totalAmount;

    return Column(
      children: [
        Text('Entry ${entryIndex + 1}'),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            keyboardType: TextInputType.text,
            onChanged: (value) {
              //double parsedValue = double.tryParse(value) ?? 0;
              entries[entryIndex].unitName = value;
            },
            decoration: InputDecoration(
              labelText: 'Unit Name',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xFF603300))),
              // Text color for the label
            ),
            cursorColor: Color(0xFF603300),
            style: TextStyle(color: Colors.black), // Text color for the input text
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                entries[entryIndex].unitPrice = double.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(
              labelText: 'Unit Price',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xFF603300))),
              // Text color for the label
            ),
            cursorColor: Color(0xFF603300),
            style: TextStyle(color: Colors.black), // Text color for the input text
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                entries[entryIndex].quantity = double.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(
              labelText: 'Quantity',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xFF603300))),
              // Text color for the label
            ),
            cursorColor: Color(0xFF603300),
            style: TextStyle(color: Colors.black), // Text color for the input text
          ),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFF603300),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Unit Amount: ${totalAmount.toStringAsFixed(2)}', // Assuming you want to display totalAmount with 2 decimal places
            style: TextStyle(
              fontFamily: 'f',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget addEntryButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          entries.add(Entry('', 0.0, 0.0, 0.0));
        });
      },
      child: Text('Add Entry'),
    );
  }

  Widget save() {
    double totalAmount = calculateTotalAmount(); // Calculate total amount

    return Column(
      children: [
        // Display total amount

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFF603300),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Total Amount: \$${totalAmount.toStringAsFixed(2)}', // Assuming you want to display totalAmount with 2 decimal places
            style: TextStyle(
              fontFamily: 'f',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
        SizedBox(height: 10), // Add spacing
        GestureDetector(
          onTap: () async {
            // Your existing save logic
            for (var entryIndex = 0; entryIndex < entries.length; entryIndex++) {
              var add = Add_data(selectedItemi!, entries[entryIndex], date, explainController.text, selectedItem!);
              box.add(add);
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                try {
                  await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('data').add(add.toMap());
                } catch (e) {
                  print('Error uploading user data: $e');
                }
              }
            }
            Navigator.of(context).pop();
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF603300),
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
        ),
      ],
    );
  }

  Widget dateTime() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: Color(0xffC5C5C5)),
      ),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (newDate != null) {
            setState(() {
              date = newDate;
            });
          }
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

  Widget how() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedItemi = types[0];
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedItemi == types[0] ? Colors.green : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(types[0]),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedItemi = types[1];
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedItemi == types[1] ? Colors.red : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(types[1]),
              ),
            ],
          ),
          SizedBox(height: 20),
          DropdownButton<String>(
            value: selectedItem,
            onChanged: (value) {
              setState(() {
                selectedItem = value;
              });
            },
            // Dropdown items for categories
            // Add logic to handle custom category if needed
            // category code is not working you can add it later
            items: ['Food', 'Transfer', 'Transportation', 'Education'].map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            hint: Text('Select Category'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget backgroundContainer(BuildContext context) {
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
                        color: Colors.white,
                      ),
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
