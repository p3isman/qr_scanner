import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/providers/scan_list_provider.dart';
import 'package:qr_scanner/utils/utils.dart';

/// Body for Maps and Directions pages
class ListTiles extends StatelessWidget {
  final String type;

  ListTiles({required this.type});

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    final controller = ScrollController();

    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 35.0),
        controller: controller,
        itemCount: scans.length,
        itemBuilder: (context, i) {
          return Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (_) {
              Provider.of<ScanListProvider>(context, listen: false)
                  .deleteScanById(scans[i].id!);
            },
            child: ListTile(
              leading: this.type == 'http'
                  ? const Icon(Icons.home)
                  : const Icon(Icons.map),
              title: Text(scans[i].value),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                launchURL(context, scans[i]);
              },
            ),
          );
        });
  }
}
