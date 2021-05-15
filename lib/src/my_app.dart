import 'package:flutter/material.dart';

import 'screens/views/bottom_navigation.dart';

class MyApp extends StatelessWidget {
  static Map<int, Color> color = {
    50: Color(0xFFfdc029).withOpacity(.1),
    100: Color(0xFFfdc029).withOpacity(.2),
    200: Color(0xFFfdc029).withOpacity(.3),
    300: Color(0xFFfdc029).withOpacity(.4),
    400: Color(0xFFfdc029).withOpacity(.5),
    500: Color(0xFFfdc029).withOpacity(.6),
    600: Color(0xFFfdc029).withOpacity(.7),
    700: Color(0xFFfdc029).withOpacity(.8),
    800: Color(0xFFfdc029).withOpacity(.9),
    900: Color(0xFFfdc029).withOpacity(1),
  };

  final MaterialColor customColor = MaterialColor(0xFFfdc029, color);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoE INVIGILTORS ATTENDANCE',
      theme: ThemeData(
        primarySwatch: customColor,
      ),
      home: BottomNavigationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
