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
  List<Entry> entries = [Entry('', 0.0, 0.0, 0.0)];
  late List<Add_data> filteredEntries;
  
  int activeEntryIndex = -1; // New variable to track the active entry widget

  @override
  void initState() {
    super.initState();
selectedItemi = types[0];
filteredEntries = box.values.toSet().toList();
Set<String> seenUnitNames = Set(); // Create a set to track seen unit names
filteredEntries = filteredEntries.fold(<Add_data>[], (List<Add_data> accumulator, Add_data current) {
  if (!seenUnitNames.contains(current.entries.unitName)) {
    seenUnitNames.add(current.entries.unitName);
    accumulator.add(current);
  }
  return accumulator;
});
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
      resizeToAvoidBottomInset: false,
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
      height: calculateContainerHeight() + 400,
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
    //TextEditingController unitNameController = TextEditingController(text: entries[entryIndex].unitName);
    //TextEditingController descriptionController = TextEditingController(text: entries[entryIndex].description); // New controller
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                keyboardType: TextInputType.text,
                //controller: unitNameController,
                onChanged: (value) {
                  setState(() {
                    // Update the entry at the specified index with the new value
                    entries[entryIndex].unitName = value;
                    
                    // Update filteredEntries based on the new value
                    filteredEntries = box.values.where((entry) =>
                        entry.entries.unitName.toLowerCase().contains(value.toLowerCase())).toList();
                  });
                  // setState(() {
                  //   if (value.length > 1) {
                  //     // Shift the first character of the input to the end of the string
                  //     String modifiedValue = value.substring(1) + value[0];
                      
                  //     // Update the TextEditingController with the modified value
                  //     unitNameController.value = TextEditingValue(
                  //       text: modifiedValue,
                  //       selection: TextSelection.collapsed(offset: modifiedValue.length),
                  //     );
                      
                  //     // Update the entry at the specified index with the modified text
                  //     entries[entryIndex].unitName = modifiedValue;

                  //     // Update filteredEntries based on the modified text
                  //     filteredEntries = box.values.where((entry) =>
                  //         entry.entries.unitName.toLowerCase().contains(modifiedValue.toLowerCase())).toList();
                  //   } else {
                  //     // Update the TextEditingController with the value
                  //     unitNameController.text = value;
                      
                  //     // Update the entry at the specified index with the value
                  //     entries[entryIndex].unitName = value;

                  //     // Update filteredEntries based on the value
                  //     filteredEntries = box.values.where((entry) =>
                  //         entry.entries.unitName.toLowerCase().contains(value.toLowerCase())).toList();
                  //   }
                  // });
                },
                decoration: InputDecoration(
                  labelText: 'Unit Name',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 2, color: Color(0xFF603300))
                  ),
                ),
                cursorColor: Color(0xFF603300),
                style: TextStyle(color: Colors.black),
              ),

              // TextField(
              //   keyboardType: TextInputType.text,
              //   controller: unitNameController,
              //   onChanged: (value) {
              //   setState(() {
              //       if (value.length > 1) {
              //   // Shift the first character of the input to the end of the string
              //   String modifiedValue = value.substring(1) + value[0];
                
              //   // Update the TextEditingController with the modified value
              //   unitNameController.text = modifiedValue;
                
              //   // Set the cursor position to the end of the modified value
              //   unitNameController.selection = TextSelection.fromPosition(
              //       TextPosition(offset: modifiedValue.length)
              //   );
                
              //   // Update the entry at the specified index with the modified text
              //   entries[entryIndex].unitName = modifiedValue;

              //   // Update filteredEntries based on the modified text
              //   filteredEntries = box.values.where((entry) =>
              //       entry.entries.unitName.toLowerCase().contains(modifiedValue.toLowerCase())).toList();
              //   } else {
              //       //activeEntryIndex = entryIndex; // Update active entry index
              //       filteredEntries = box.values.where((entry) =>
              //         entry.entries.unitName.toLowerCase().contains(value.toLowerCase())).toList();
              //       entries[entryIndex].unitName = value;
              //   }
              //     });
              //     //entries[entryIndex].unitName = value;
              //     //unitNameController.selection = TextSelection.fromPosition(TextPosition(offset: unitNameController.text.length));
              //   },
              //   decoration: InputDecoration(
              //     labelText: 'Unit Name',
              //     labelStyle: TextStyle(color: Colors.black),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xFF603300))),
              //   ),
              //   cursorColor: Color(0xFF603300),
              //   style: TextStyle(color: Colors.black),
              // ),
            ],
          ),
        ),
        //if (activeEntryIndex == entryIndex && filteredEntries.isNotEmpty)
          SizedBox(height: 10),
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(15),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredEntries.length,
              itemBuilder: (context, index) {
                if (index > 0 && filteredEntries[index].entries.unitName == filteredEntries[index - 1].entries.unitName) {
                  return SizedBox.shrink();
                } else {
                  return ListTile(
                    title: Text(filteredEntries[index].entries.unitName),
                    onTap: () {
                      setState(() {
                        entries[entryIndex].unitName = filteredEntries[index].entries.unitName;
                        explainController.text = filteredEntries[index].entries.unitName;
                        explainController.selection = TextSelection.fromPosition(TextPosition(offset: explainController.text.length));
                        filteredEntries.clear();
                      });
                    },
                  );
                }
              },
            ),
          ),
        // SizedBox(height: 10),
        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(15),
        //     color: Colors.white,
        //   ),
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   child: TextField(
        //     keyboardType: TextInputType.text,
        //     controller: descriptionController,
        //     onChanged: (value) {
        //       setState(() {
        //         entries[entryIndex].description = value;;
        //       });
        //     },
        //     decoration: InputDecoration(
        //       labelText: 'Description',
        //       labelStyle: TextStyle(color: Colors.black),
        //       enabledBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
        //       focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xFF603300))),
        //     ),
        //     cursorColor: Color(0xFF603300),
        //     style: TextStyle(color: Colors.black),
        //   ),
        // ),
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
            ),
            cursorColor: Color(0xFF603300),
            style: TextStyle(color: Colors.black),
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
            ),
            cursorColor: Color(0xFF603300),
            style: TextStyle(color: Colors.black),
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
            'Unit Amount: ${totalAmount.toStringAsFixed(2)}',
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
    double totalAmount = calculateTotalAmount();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFF603300),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'f',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            if (entries.any((entry) => entry.unitName.isEmpty) || selectedItem == null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Missing Information"),
                    content: Text("Please make sure all the fields are filled."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            } else {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                try {
                  for (var entryIndex = 0; entryIndex < entries.length; entryIndex++) {
                    var add = Add_data(selectedItemi!, entries[entryIndex], date, explainController.text, selectedItem!, '');
                    DocumentReference docRef = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('data').add(add.toMap());
                    add.setDocumentId(docRef.id);
                    box.add(add);
                  }
                } catch (e) {
                  print('Error uploading user data: $e');
                }
              }
              Navigator.of(context).pop();
            }
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
            items: ['Childcare', 'Clothing', 'Debt', 'Education', 'Entertainment', 'Food', 'Gifts and Donations', 'Groceries', 'Healthcare', 'Hobbies', 'Household Supplies', 'Housing', 'Insurance', 'Personal Care', 'Pets', 'Professional Development', 'Savings', 'Subscriptions', 'Transportation', 'Travel', 'Utilities', 'Work-Related', 'Transfer', 'Miscellaneous']
                .map((category) {
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
