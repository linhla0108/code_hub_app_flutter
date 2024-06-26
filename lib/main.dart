import 'package:dans_productivity_app_flutter/src/utils/custom-snack-bar.dart';
import 'package:dans_productivity_app_flutter/src/widgets/navigation-bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'src/screens/login.dart';
import 'src/utils/hide.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => ScrollControllerProvider(),
    child: CodehubApp(),
  ));
}

class CodehubApp extends StatelessWidget {
  CodehubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Code Hub',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            CustomSnackBar(context, "Some thing went wrong!", true);
          } else if (snapshot.hasData) {
            return NavigationBarWidget();
          } else {
            return LoginScreen();
          }

          return CustomSnackBar(context, "Some thing went wrong!", true);
        },
      ),
    );
  }
}
