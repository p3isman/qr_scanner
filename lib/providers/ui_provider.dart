import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  int _selectedMenuOpt = 0;

  // Getter uses {}
  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  // Setter acts like a function
  set selectedMenuOpt(int i) {
    _selectedMenuOpt = i;

    // Triggers changes to widgets that are listening to this
    notifyListeners();
  }
}
