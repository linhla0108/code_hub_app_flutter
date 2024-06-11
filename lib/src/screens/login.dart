import 'package:dans_productivity_app_flutter/src/utils/custom-snack-bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../main.dart';
import '../style/custom-style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool revealPassword = false;
  final hasValue = true;
  final formKey = GlobalKey<FormState>();

  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailInputController.text.trim(),
        password: passwordInputController.text.trim(),
      )
          .then(
        (value) {
          Navigator.pop(context);
          print(value);
          CustomSnackBar(context, "Wellcome back develop!", false);
        },
      ).catchError(
        (error) {
          Navigator.pop(context);
          CustomSnackBar(context, "Login Failed!", true);
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    passwordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
              padding: EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Container(
                        width: 250,
                        child: Text(
                          "Welcome back! Glad to see you, Again!",
                          style: TextStyle(
                              color: Color(0XFF1E232C),
                              fontSize: 28,
                              fontWeight: FontWeight.w800),
                        )),
                    SizedBox(height: 30),
                    Container(
                      height: 56,
                      decoration: CustomStyle().StyleBoxShadowLogin,
                      child: TextFormField(
                        controller: emailInputController,
                        decoration: CustomStyle()
                            .StyleInputLogin(false, hasValue, null),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 56,
                      decoration: CustomStyle().StyleBoxShadowLogin,
                      child: TextFormField(
                        controller: passwordInputController,
                        obscureText: !revealPassword,
                        decoration: CustomStyle().StyleInputLogin(
                            true,
                            hasValue,
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  revealPassword = !revealPassword;
                                });
                                print(revealPassword);
                              },
                              child: Transform.scale(
                                scale: 0.6,
                                child: SvgPicture.asset(revealPassword
                                    ? 'assets/icons/eye-close.svg'
                                    : 'assets/icons/eye-open.svg'),
                              ),
                            )),
                      ),
                    ),
                    Container(
                      color: Colors.blue,
                      child: TextButton(
                        onPressed: () {
                          signIn();
                          print("Login");
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Color(0XFF1E232C),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
