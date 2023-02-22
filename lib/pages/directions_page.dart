import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';
import '../widgets/list_tiles.dart';
import 'empty_page.dart';

class DirectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return scans.isEmpty
        ? EmptyPage(
            'This tab displays all the website URLs you\'ve scanned. Start by scanning a QR code to add one.')
        : ListTiles(type: 'http');
  }
}
