import 'package:dans_productivity_app_flutter/src/screens/login.dart';
import 'package:dans_productivity_app_flutter/src/screens/wellcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Code Hub Demo',
        home: LoginPage());
  }
}
