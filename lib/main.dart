import 'package:dans_productivity_app_flutter/src/screens/create-edit-log.dart';
import 'package:dans_productivity_app_flutter/src/screens/history.dart';
import 'package:dans_productivity_app_flutter/src/widgets/navigation-bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  // Firebase.initializeApp();
  // // Firebase.initializeApp(options: FirebaseOptions());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        // home: HistoryScreen());
        home: NavigationBarWidget());
  }
}
