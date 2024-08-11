import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';
import '../widgets/list_tiles.dart';
import '../widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CustomAppBar(),
      body: _HomePageBody(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        IconButton(
          onPressed: () => _onFilterPressed(context),
          icon: Icon(Icons.filter_alt),
        ),
        scans.isEmpty
            ? SizedBox()
            : IconButton(
                onPressed: () => _onDeletePressed(context),
                icon: Icon(Icons.delete_forever, color: Colors.white),
              ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget get child => child;

  void _onFilterPressed(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Filter by type'),
              content: Column(
                  children: [CheckboxListTile(value: value, onChanged: () {})]),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          });
        });
  }

  void _onDeletePressed(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete all scans?'),
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
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    return FutureBuilder(
        future: scanListProvider.loadScans(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListTiles();
          } else {
            return SizedBox();
          }
        });
  }
}
