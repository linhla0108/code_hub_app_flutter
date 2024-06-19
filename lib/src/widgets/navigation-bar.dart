import 'dart:io';
import 'package:dans_productivity_app_flutter/src/screens/dashboard.dart';
import 'package:dans_productivity_app_flutter/src/screens/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dans_productivity_app_flutter/src/screens/history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/hide.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int currentSelectedScreen = 0;
  bool showBottomNavigationBar = true;
  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String uid = user!.uid;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', uid);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      showBottomNavigationBar = Provider.of<ScrollControllerProvider>(context)
          .showBottomNavigationBar;
    });

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: showBottomNavigationBar ? 74.0 : 0.0,
          margin: EdgeInsets.symmetric(
              horizontal: 16, vertical: Platform.isAndroid ? 10 : 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 30,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentSelectedScreen = index;
              });
            },
            backgroundColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            selectedIndex: currentSelectedScreen,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: SvgPicture.asset('assets/icons/home-rounded.svg'),
                icon: SvgPicture.asset('assets/icons/home.svg'),
                label: 'Home',
              ),
              NavigationDestination(
                selectedIcon: SvgPicture.asset('assets/icons/list-rounded.svg'),
                icon: SvgPicture.asset('assets/icons/list.svg'),
                label: 'History',
              ),
              NavigationDestination(
                selectedIcon:
                    SvgPicture.asset('assets/icons/settings-rounded.svg'),
                icon: SvgPicture.asset('assets/icons/settings.svg'),
                label: 'Setting',
              ),
            ],
          ),
        ),
      ),
      body: <Widget>[
        DashBoard(),
        HistoryScreen(),
        SettingScreen(),
      ][currentSelectedScreen],
    );
  }
}
