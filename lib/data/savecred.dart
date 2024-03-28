import 'package:flutter/material.dart';

class UserCredProvider extends ChangeNotifier {
  Map<String, String>? _cred;

  Map<String, String>? get cred => _cred;

  void setCred(Map<String, String>? cred) {
    _cred = cred;
    notifyListeners();
  }
}
