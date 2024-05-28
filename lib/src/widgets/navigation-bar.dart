import 'package:dans_productivity_app_flutter/src/screens/dashboard.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dans_productivity_app_flutter/src/screens/history.dart';
import 'package:dans_productivity_app_flutter/src/screens/login.dart';
import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int currentSelectedScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        // minimum: EdgeInsets.only(bottom: 20),
        child: Container(
          height: 74,
          margin: EdgeInsets.symmetric(horizontal: 16),
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
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              NavigationDestination(
                selectedIcon:
                    SvgPicture.asset('assets/icons/settings-rounded.svg'),
                icon: SvgPicture.asset('assets/icons/settings.svg'),
                label: 'Setting',
              ),
            ],
          ),
          //   ],
          // ),
        ),
      ),
      body: <Widget>[
        DashBoard(),
        HistoryScreen(),
        LoginScreen(),
      ][currentSelectedScreen],
    );
  }
}