import 'package:hive/hive.dart';
import 'package:managment/data/model/add_date.dart';

double totals = 0;

final box = Hive.box<Add_data>('data');

double total() {
  var history2 = box.values.toList();
  List a = [0.0, 0.0];
  for (var i = 0; i < history2.length; i++) {
    a.add(history2[i].IN == 'Income'
        ? history2[i].entries.total
        : history2[i].entries.total * -1);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

double calculateTotalAmount(List<Add_data> histories) {
  // double totalAmount = 0.0;
  // for (var history in histories) {
  //   totalAmount += history.entries.total;
  // }
  // return totalAmount;

  List a = [0.0, 0.0];
  for (var i = 0; i < histories.length; i++) {
    a.add(histories[i].IN == 'Income'
        ? histories[i].entries.total
        : histories[i].entries.total * -1);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

double income() {
  var history2 = box.values.toList();
  List a = [0.0, 0.0];
  for (var i = 0; i < history2.length; i++) {
    a.add(history2[i].IN == 'Income' ? history2[i].entries.total : 0);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

double expenses() {
  var history2 = box.values.toList();
  List a = [0.0, 0.0];
  for (var i = 0; i < history2.length; i++) {
    a.add(history2[i].IN == 'Income' ? 0 : history2[i].entries.total * -1);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

List<Add_data> today() {
  List<Add_data> a = [];
  var history2 = box.values.toList();
  DateTime date = new DateTime.now();
  for (var i = 0; i < history2.length; i++) {
    if (history2[i].datetime.day == date.day) {
      a.add(history2[i]);
    }
  }
  return a;
}

List<Add_data> week() {
  List<Add_data> a = [];
  DateTime date = new DateTime.now();
  var history2 = box.values.toList();
  for (var i = 0; i < history2.length; i++) {
    if (date.day - 7 <= history2[i].datetime.day &&
        history2[i].datetime.day <= date.day) {
      a.add(history2[i]);
    }
  }
  return a;
}

List<Add_data> month() {
  List<Add_data> a = [];
  var history2 = box.values.toList();
  DateTime date = new DateTime.now();
  for (var i = 0; i < history2.length; i++) {
    if (history2[i].datetime.month == date.month) {
      a.add(history2[i]);
    }
  }
  return a;
}

List<Add_data> year() {
  List<Add_data> a = [];
  var history2 = box.values.toList();
  DateTime date = new DateTime.now();
  for (var i = 0; i < history2.length; i++) {
    if (history2[i].datetime.year == date.year) {
      a.add(history2[i]);
    }
  }
  return a;
}

double total_chart(List<Add_data> history2) {
  List a = [0.0, 0.0];

  for (var i = 0; i < history2.length; i++) {
    a.add(history2[i].IN == 'Income'
        ? history2[i].entries.total
        : history2[i].entries.total * -1);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

List time(List<Add_data> history2, bool hour) {
  List<Add_data> a = [];
  List total = [];
  int counter = 0;
  for (var c = 0; c < history2.length; c++) {
    for (var i = c; i < history2.length; i++) {
      if (hour) {
        if (history2[i].datetime.hour == history2[c].datetime.hour) {
          a.add(history2[i]);
          counter = i;
        }
      } else {
        if (history2[i].datetime.day == history2[c].datetime.day) {
          a.add(history2[i]);
          counter = i;
        }
      }
    }
    total.add(total_chart(a));
    a.clear();
    c = counter;
  }
  print(total);
  return total;
}
