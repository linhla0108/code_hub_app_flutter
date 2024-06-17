import 'package:dans_productivity_app_flutter/src/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/button-login.dart';

class WellcomeScreen extends StatelessWidget {
  const WellcomeScreen({super.key});

  void recordedFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("firstRun", true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white70,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "Welcome to Dans Productivity App",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  "Lorem is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's simply dummy text of the printing and typesetting industry",
                                  style: TextStyle(fontSize: 15),
                                )),
                          ],
                        ),
                      ),
                      ButtonLogin(
                        height: 60,
                        title: "Login",
                        fontSize: 25,
                        onPress: () {
                          recordedFirstTime();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        fontWeight: FontWeight.bold,
                        position: AlignmentDirectional.center,
                      ),
                    ],
                  )),
            ),
          )),
    );
  }
}
