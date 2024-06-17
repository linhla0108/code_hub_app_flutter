import 'package:dans_productivity_app_flutter/src/screens/wellcome.dart';
import 'package:dans_productivity_app_flutter/src/utils/custom-snack-bar.dart';
import 'package:dans_productivity_app_flutter/src/widgets/button-login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style/custom-style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool revealPassword = false;
  bool hasValue = true;
  late bool? isFirstRun = null;

  final formKey = GlobalKey<FormState>();

  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  void checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstRun = prefs.getKeys().contains("firstRun");
    });
  }

  @override
  void initState() {
    checkFirstTime();
    super.initState();
  }

  void validateForm() {
    if (emailInputController.text.isEmpty ||
        passwordInputController.text.isEmpty) {
      setState(() {
        hasValue = false;
      });
    } else {
      signIn();
    }
  }

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
  Widget build(BuildContext context) {
    return isFirstRun == false
        ? WellcomeScreen()
        : isFirstRun == null
            ? Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: CircularProgressIndicator(),
                ))
            : Scaffold(
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
                              isFirstRun == false
                                  ? Container(
                                      height: 41,
                                      width: 41,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Color(0XFFE8ECF4), width: 1),
                                      ),
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        iconSize: 22,
                                        padding: EdgeInsets.only(right: 1),
                                        icon: Icon(
                                          fill: 1,
                                          color: Colors.black,
                                          Icons.arrow_back_ios_new_rounded,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: isFirstRun! ? 70 : 30,
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
                              SizedBox(height: 39),
                              ButtonLogin(
                                title: 'Login',
                                height: 56,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                position: AlignmentDirectional.topCenter,
                                onPress: () {
                                  validateForm();
                                },
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              );
  }
}
