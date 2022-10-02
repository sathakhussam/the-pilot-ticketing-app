import 'dart:convert';

import 'package:the_pilot_ticketing_app/models/user.dart';
import 'package:http/http.dart' as http;

class ThePilotApi {
  User? user;
  final String url = 'http://192.168.43.109:3000/api/v1/';

  loginUser(String email, String password) {
    return http.post(Uri.parse('${url}users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }));
  }

  Future<String> getTickets() async {
    var resp = await http.get(Uri.parse('${url}ticket/'), headers: {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${user?.token}'
    });

    if (resp.statusCode == 200) {
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
