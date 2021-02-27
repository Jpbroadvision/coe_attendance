import 'package:flutter/material.dart';
import 'package:coe_attendance/components/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CoE INVIGILTORS ATTENDANCE',
        home: Home(),
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          accentColor: Color(0xff014E50),
          primaryColorDark: Color(0x3C4146),

          // Define the default font family.
          fontFamily: 'Georgia',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 62.0, fontWeight: FontWeight.bold),
            headline3: TextStyle(fontSize: 52.0, fontWeight: FontWeight.bold),
            headline4: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
            headline5: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),

            // headline6: TextStyle(fontSize: 26.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ));
  }
}
