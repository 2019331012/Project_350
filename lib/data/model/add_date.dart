import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:managment/data/model/entry.dart';

part 'add_date.g.dart';

@HiveType(typeId: 1)
class Add_data extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String explain;
  @HiveField(2)
  Entry entries; // List to store multiple entries
  @HiveField(3)
  String IN;
  @HiveField(4)
  DateTime datetime;

  Add_data(this.IN, this.entries, this.datetime, this.explain, this.name);

  factory Add_data.fromMap(Map<String, dynamic> map) {
    // Convert List<dynamic> to List<Entry>
    // List<Entry> entries = (map['entries'] as List<dynamic>)
    //     .map((entry) => Entry.fromMap(entry))
    //     .toList();

    Entry entry = new Entry.fromMap(map['entries']);
    
    return Add_data(
      map['IN'] as String,
      entry,
      (map['datetime'] as Timestamp).toDate(),
      map['explain'] as String,
      map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // // Convert List<Entry> to List<Map<String, dynamic>>
    // List<Map<String, dynamic>> entryMaps =
    //     entries.map((entry) => entry.toMap()).toList();

    return {
      'name': name,
      'explain': explain,
      'entries': entries.toMap(), // Store entries as a list of maps
      'IN': IN,
      'datetime': Timestamp.fromDate(datetime), // Convert DateTime to Firestore Timestamp
    };
  }
}