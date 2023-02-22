import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';
import '../providers/ui_provider.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/scan_button.dart';
import 'directions_page.dart';
import 'maps_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CustomAppBar(),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSize {
  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return AppBar(
      title: Text('QR Scanner'),
      actions: [
        scans.isEmpty
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.white),
                onPressed: () => _onDeletePressed(context),
              ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget get child => child;

  _onDeletePressed(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete all items?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                    onPressed: () async {
                      await Provider.of<ScanListProvider>(context,
                              listen: false)
                          .deleteAllScans();
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete'))
              ]);
        });
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
            return SizedBox();
          }
        });
  }

  Future<Widget> _getScanListProvider(
      int currentIndex, ScanListProvider scanListProvider) async {
    switch (currentIndex) {
      case 0:
        await scanListProvider.loadScansByType('http');
        return DirectionsPage();

      case 1:
        await scanListProvider.loadScansByType('geo');
        return MapsPage();

      default:
        return DirectionsPage();
    }
  }
}
