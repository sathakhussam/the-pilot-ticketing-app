import 'dart:convert';

import 'package:the_pilot_ticketing_app/models/user.dart';
import 'package:http/http.dart' as http;

class ThePilotApi {
  User? user;
  final String url = 'http://139.59.38.60/api/v1/';

  loginUser(String email, String password) {
    return http.post(Uri.parse('${url}users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {"email": email, "password": password, 'firebaseToken': 'hi'}));
  }

  Future<String> getTickets() async {
    var resp = await http.get(Uri.parse('${url}ticket/'), headers: {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${user?.token}'
    });

    if (resp.statusCode == 200) {
      print(resp.body);
      return resp.body;
    } else {
      print(resp.body);
      throw Exception('Failed to get tickets');
    }
  }

  Future<String> resolveTicket(String ticketId) async {
    var resp = await http.put(Uri.parse('${url}ticket/${ticketId}'), headers: {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${user?.token}'
    });

    if (resp.statusCode == 200) {
      print(resp.body);
      return resp.body;
    } else {
      print(resp.body);
      throw Exception('Failed to get tickets');
    }
  }

  Future<String> sendMessage(String ticketId, String msg) async {
    var resp = await http.post(Uri.parse('${url}ticket/${ticketId}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${user?.token}'
        },
        body: jsonEncode({"message": msg}));

    if (resp.statusCode == 200) {
      print(resp.body);
      return resp.body;
    } else {
      print(resp.body);
      throw Exception('Failed to get tickets');
    }
  }

  setUser(User data) {
    user = data;
  }
}
