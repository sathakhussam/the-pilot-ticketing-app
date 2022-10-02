import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:the_pilot_ticketing_app/constants/colors.dart';
import 'package:the_pilot_ticketing_app/pages/login.page.dart';
import 'package:the_pilot_ticketing_app/providers/authorization.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "The Pilot",
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: primaryColorSwatch,
            fontSize: 24.0),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () async {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
            Provider.of<Authorization>(context, listen: false).setUser(null);
            await Hive.box('setting').put('user', null);
          },
          splashRadius: 24.0,
          icon: const Icon(
            Icons.logout,
            color: primaryColorSwatch,
          ),
        )
      ],
    );
  }
}
