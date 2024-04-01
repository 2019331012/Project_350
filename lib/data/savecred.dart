import 'package:flutter/material.dart';

class UserCredProvider extends ChangeNotifier {
  Map<String, String>? _cred;

  Map<String, String>? get cred => _cred;

  UserCredProvider({Map<String, String>? initialCred}) {
    _cred = initialCred;
  }

  void setCred(Map<String, String>? newCred) {
    if (_cred != newCred) {
      _cred = newCred;
      notifyListeners();
    }
}


  // Destructor (dispose method) to clear credentials when the provider is disposed
  @override
  void dispose() {
    _cred = null; // Clear credentials
    super.dispose();
  }
}
