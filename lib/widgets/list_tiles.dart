import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/providers/db_provider.dart';

import '../pages/empty_page.dart';
import '../providers/scan_list_provider.dart';
import '../utils/utils.dart';

/// Body for Maps and Directions pages
class ListTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);
    final scans = scanListProvider.scans;

    return scans.isEmpty
        ? EmptyPage(
            'Here you will see all the QR codes that you\'ve scanned. Start by scanning a QR code to add one.')
        : ListView.builder(
            reverse: true,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 35.0),
            controller: ScrollController(),
            itemCount: scans.length,
            itemBuilder: (context, i) {
              return Dismissible(
                key: ValueKey(scans[i].id),
                background: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                confirmDismiss: (_) async {
                  return await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this scan?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (_) async {
                  await Provider.of<ScanListProvider>(context, listen: false)
                      .deleteScanById(scans[i].id!);
                },
                child: ListTile(
                  leading: _typeToIconMap[scans[i].type!],
                  title: Text(scans[i].value),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () => _getBehaviourFromType(context, scans[i]),
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: scans[i].value));
                  },
                ),
              );
            });
  }

  final Map<String, Icon> _typeToIconMap = {
    'http': Icon(Icons.public),
    'geo': Icon(Icons.location_on),
    'phone': Icon(Icons.phone),
    'email': Icon(Icons.email),
    'other': Icon(Icons.text_fields)
  };

  Function _getBehaviourFromType(BuildContext context, ScanModel scan) {
    switch (scan.type) {
      case 'http':
        return () => launchURL(context, scan);
      default:
        return () {};
    }
  }
}
