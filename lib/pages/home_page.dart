import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';
import '../providers/ui_provider.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/scan_button.dart';
import 'directions_page.dart';
import 'empty_page.dart';
import 'maps_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
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
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    return FutureBuilder(
        future: _getScanListProvider(currentIndex, scanListProvider),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data as Widget;
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<Widget> _getScanListProvider(
      int currentIndex, ScanListProvider scanListProvider) async {
    switch (currentIndex) {
      case 0:
        await scanListProvider.loadScansByType('http');
        if (scanListProvider.scans.isEmpty)
          return EmptyPage(
              'This tab displays all the website URLs you\'ve scanned. Start by scanning a QR code to add one.');
        else
          return DirectionsPage();

      case 1:
        await scanListProvider.loadScansByType('geo');
        if (scanListProvider.scans.isEmpty)
          return EmptyPage(
              'This tab displays all the location URLs you\'ve scanned. Start by scanning a QR code to add one.');
        else
          return MapsPage();

      default:
        return DirectionsPage();
    }
  }
}
