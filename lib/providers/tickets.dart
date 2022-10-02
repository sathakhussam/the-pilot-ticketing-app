import 'package:flutter/material.dart';

class Tickets extends ChangeNotifier {
  var resolvedTickets;
  var unresolvedTickets;
  var unresolved = true;

  setResolvedTickets(value) {
    resolvedTickets = value;
    notifyListeners();
  }

  setUnresolvedTickets(value) {
    unresolvedTickets = value;
    notifyListeners();
  }

  changeUnresolved(bool value) {
    unresolved = value;
    notifyListeners();
  }

  getUnresolved() => unresolved;
}
