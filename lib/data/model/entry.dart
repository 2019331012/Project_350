import 'package:hive/hive.dart';

class Entry {
  String unitName;
  double unitPrice;
  double quantity;
  double total;


  Entry(this.unitName, this.unitPrice, this.quantity, this.total);

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      map['unitName'] as String,
      map['unitPrice'] is int ? (map['unitPrice'] as int).toDouble() : map['unitPrice'] as double,
      map['quantity'] is int ? (map['quantity'] as int).toDouble() : map['quantity'] as double,
      map['total'] is int ? (map['total'] as int).toDouble() : map['total'] as double,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'unitName': unitName,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'total': total,
    };
  }
}


class EntryAdapter extends TypeAdapter<Entry> {
  @override
  final typeId = 2; // Use a unique positive integer as the typeId

  @override
  Entry read(BinaryReader reader) {
    return Entry(
      reader.readString(),
      reader.readDouble(),
      reader.readDouble(),
      reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Entry obj) {
    writer.writeString(obj.unitName);
    writer.writeDouble(obj.unitPrice);
    writer.writeDouble(obj.quantity);
    writer.writeDouble(obj.total);
  }
}

