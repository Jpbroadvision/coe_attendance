import 'package:flutter/material.dart';

import 'locator.dart';
import 'src/my_app.dart';

void main() {
  // setup getIt service locator
  setupLocator();
  runApp(MyApp());
}
