import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_scanner/widgets/navigation_bar.dart';
import 'package:qr_scanner/widgets/scan_button.dart';

import 'package:qr_scanner/pages/directions_page.dart';
import 'package:qr_scanner/pages/maps_page.dart';

import 'package:qr_scanner/providers/ui_provider.dart';
import 'package:qr_scanner/providers/scan_list_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              Provider.of<ScanListProvider>(context, listen: false)
                  .deleteAllScans();
            },
          ),
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: NavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get current tab
    final uiProvider = Provider.of<UiProvider>(context);

    final currentIndex = uiProvider.selectedMenuOpt;

    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    // Tab management
    switch (currentIndex) {
      case 0:
        scanListProvider.loadScansByType('geo');
        return MapsPage();

      case 1:
        scanListProvider.loadScansByType('http');
        return DirectionsPage();

      default:
        return MapsPage();
    }
  }
}
