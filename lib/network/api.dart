import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:the_pilot_ticketing_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ThePilotApi {
  User? user;
  // final String url = 'http://192.168.1.8:3000/api/v1/';
  final String url = 'http://139.59.38.60/api/v1/';

  loginUser(String email, String password) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();

    token ??= "No Token";
    return http.post(Uri.parse('${url}users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {"email": email, "password": password, 'firebaseToken': token}));
  }

  Future<String> getTickets() async {
    var resp = await http.get(Uri.parse('${url}ticket/'), headers: {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${user?.token}'
    });

    if (resp.statusCode == 200) {
      return resp.body;
    } else {
      throw Exception('Failed to get tickets');
    }
  }

  Future<String> resolveTicket(String ticketId) async {
    var resp = await http.put(Uri.parse('${url}ticket/${ticketId}'), headers: {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${user?.token}'
    });

    if (resp.statusCode == 200) {
      return resp.body;
    } else {
      throw Exception('Failed to get tickets');
    }
  }

  Future<String> sendMessage(String ticketId, String msg, BuildContext context,
      {File? image}) async {
    // Create a multipart request if an image is provided
    if (image != null) {
      try {
        var request =
            http.MultipartRequest('POST', Uri.parse('${url}ticket/$ticketId'));
        request.fields.addAll({'message': msg});

        request.files.add(http.MultipartFile.fromBytes(
            "image", image.readAsBytesSync(),
            filename: "image." + image.path.split('.').last,
            contentType: MediaType("image", image.path.split('.').last)));

        request.headers.addAll({
          'authorization': 'Bearer ${user?.token}',
        });

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          return await response.stream.bytesToString();
        } else {
          throw Exception('Failed to send message with image');
        }
      } catch (e) {
        final snackBar = SnackBar(
          content: Text('Failed to send message with image. Error: $e'),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        throw Exception('Failed to send message with image');
      }
    } else {
      // Send a regular text message if no image is provided
      try {
        var resp = await http.post(
          Uri.parse('${url}ticket/$ticketId'),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer ${user?.token}',
          },
          body: jsonEncode({"message": msg}),
        );

        if (resp.statusCode == 200) {
          return resp.body;
        } else {
          throw Exception('Failed to send message');
        }
      } catch (e) {
        final snackBar = SnackBar(
          content: Text('Failed to send message. Please try again later.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        throw Exception('Failed to send message');
      }
    }
  }

  setUser(User data) {
    user = data;
  }
}
