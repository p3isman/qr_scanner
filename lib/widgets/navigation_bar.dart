import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ui_provider.dart';

class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    return BottomNavigationBar(
      elevation: 20,
      onTap: (i) {
        uiProvider.selectedMenuOpt = i;
      },
      currentIndex: uiProvider.selectedMenuOpt,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: 'Websites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Locations',
        ),
      ],
    );
  }
}
