import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TESSSTT extends StatelessWidget {
  const TESSSTT({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 200,
                    height: 50,
                    color: Colors.blueAccent,
                    child: TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text("Logout"),
                    ),
                  ),
                ))),
      ),
    );
  }
}
