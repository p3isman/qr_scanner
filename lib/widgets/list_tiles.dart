import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';
import '../utils/utils.dart';

/// Body for Maps and Directions pages
class ListTiles extends StatelessWidget {
  final String type;

  ListTiles({required this.type});

  @override
  Widget build(BuildContext context) {
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);
    final scans = scanListProvider.scans;

    final controller = ScrollController();

    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 35.0),
        controller: controller,
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
              leading: this.type == 'http'
                  ? const Icon(Icons.link)
                  : const Icon(Icons.location_on),
              title: Text(scans[i].value),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                launchURL(context, scans[i]);
              },
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: scans[i].value));
              },
            ),
          );
        });
  }
}
