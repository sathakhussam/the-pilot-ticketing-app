// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:the_pilot_ticketing_app/constants/colors.dart';
import 'package:the_pilot_ticketing_app/models/user.dart';
import 'package:the_pilot_ticketing_app/network/api.dart';
import 'package:the_pilot_ticketing_app/pages/home.page.dart';
import 'package:the_pilot_ticketing_app/providers/authorization.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var email = '';
  var password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "The Pilot",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryColorSwatch,
              fontSize: 24.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (!RegExp('[a-zA-Z._0-9]+@[a-zA-Z]+\.[a-zA-Z]+')
                      .hasMatch(value)) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
                onChanged: ((value) {
                  email = value;
                }),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (value.length < 8) {
                    return 'Please enter atleast 8 characters long';
                  }
                  return null;
                },
                onChanged: ((value) {
                  password = value;
                }),
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 32.0,
                  height: 48.0,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<Authorization>(context, listen: false)
                              .setLoading(true);
                          var api = ThePilotApi();
                          try {
                            var resp = await api.loginUser(email, password);
                            if (resp.statusCode != 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Password / Email is incorrect')),
                              );
                            } else {
                              var user = userFromJson(resp.body);
                              await Hive.box('setting')
                                  .put('user', userToJson(user));
                              Provider.of<Authorization>(context, listen: false)
                                  .setUser(user);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomePage()));
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                          Provider.of<Authorization>(context, listen: false)
                              .setLoading(false);
                        }
                      },
                      // child: Text('Login'),
                      child: Provider.of<Authorization>(context).loading
                          ? const SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3.0,
                              ),
                            )
                          : const Text('Login')))
            ],
          ),
        ),
      ),
    );
  }
}
