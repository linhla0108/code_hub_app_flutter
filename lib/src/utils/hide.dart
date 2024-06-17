import 'package:flutter/material.dart';

class ScrollControllerProvider with ChangeNotifier {
  ScrollController scrollController = ScrollController();
  bool showBottomNavigationBar = true;

  ScrollControllerProvider() {
    scrollController.addListener(() {
      notifyListeners();
    });
  }

  void setShowBottomNavigationBar(bool value) {
    showBottomNavigationBar = value;
    notifyListeners();
  }
}
