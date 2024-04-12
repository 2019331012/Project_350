import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:managment/data/model/add_date.dart';

class DateAction{

  static void deleteHistories(FirebaseFirestore firestore, User? user, List<Add_data> histories) {
    for (var history in histories) {
      firestore.collection('users')
        .doc(user?.uid)
        .collection('data')
        .doc(history.documentId).delete();
      history.delete(); // Delete each history item
    }
  }

  static List<DateTime> getUniqueDates(final Box<Add_data> box) {
    Set<DateTime> datesSet = Set();
    box.values.forEach((history) {
      datesSet.add(DateTime(
        history.datetime.year,
        history.datetime.month,
        history.datetime.day,
        history.datetime.hour,
        history.datetime.minute,
        history.datetime.second,
        history.datetime.millisecond,
        history.datetime.microsecond,
      ));
    });
    return datesSet.toList()..sort((a, b) => b.compareTo(a)); // Sorting in descending order
  }

  static List<Add_data> getHistoriesByDate(final Box<Add_data> box, DateTime date) {
    return box.values.where((history) =>
        history.datetime.year == date.year &&
        history.datetime.month == date.month &&
        history.datetime.day == date.day &&
        history.datetime.hour == date.hour &&
        history.datetime.minute == date.minute &&
        history.datetime.second == date.second &&
        history.datetime.millisecond == date.millisecond &&
        history.datetime.microsecond == date.microsecond).toList();
  }

}