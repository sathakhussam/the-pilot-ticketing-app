import 'package:flutter/material.dart';
import 'package:the_pilot_ticketing_app/models/user.dart';

class Authorization extends ChangeNotifier {
  User? user;
  var loading = false;

  setUser(value) {
    user = value;
    notifyListeners();
  }

  setLoading(value) {
    loading = value;
    notifyListeners();
  }

  getUser() => user;
  getLoading() => loading;
}
