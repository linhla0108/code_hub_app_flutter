import 'package:dans_productivity_app_flutter/src/screens/create-edit-log.dart';
import 'package:dans_productivity_app_flutter/src/widgets/navigation-bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Code Hub',
        home: CreateLogScreen(
          isCreateNew: false,
          historyId: 1,
        ));
    // home: NavigationBarWidget());
  }
}
