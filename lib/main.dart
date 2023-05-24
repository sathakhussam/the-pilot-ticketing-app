import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_pilot_ticketing_app/pages/chat.page.dart';
import 'package:the_pilot_ticketing_app/pages/home.page.dart';
import 'package:the_pilot_ticketing_app/pages/login.page.dart';
import 'package:the_pilot_ticketing_app/providers/authorization.dart';
import 'package:the_pilot_ticketing_app/providers/tickets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Navigator.pushReplacementNamed(context, Routes.HOME);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('setting');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => Tickets())),
        ChangeNotifierProvider(create: ((context) => Authorization())),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
          ),
          home: Hive.box('setting').get('user') == null
              ? const LoginPage()
              : HomePage()),
    );
  }
}
