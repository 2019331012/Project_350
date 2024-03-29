import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'add_date.g.dart';

@HiveType(typeId: 1)
class Add_data extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String explain;
  @HiveField(2)
  String amount;
  @HiveField(3)
  String IN;
  @HiveField(4)
  DateTime datetime;
  Add_data(this.IN, this.amount, this.datetime, this.explain, this.name);

  factory Add_data.fromMap(Map<String, dynamic> map) {
  return Add_data(
    map['IN'] as String,
    map['amount'] as String,
    (map['datetime'] as Timestamp).toDate(),
    map['explain'] as String,
    map['name'] as String,
  );
}


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'explain': explain,
      'amount': amount,
      'IN': IN,
      'datetime': Timestamp.fromDate(datetime), // Convert DateTime to Firestore Timestamp
    };  
  }
  
}