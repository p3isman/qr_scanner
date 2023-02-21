import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../models/scan_model.dart';
import '../providers/scan_list_provider.dart';
import '../utils/utils.dart';

class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      highlightElevation: 0,
      child: Icon(Icons.qr_code_scanner),
      onPressed: () async {
        String scanResult = await FlutterBarcodeScanner.scanBarcode(
            '#3D8BEF', 'Cancel', false, ScanMode.QR);

        // If user cancels value of scan is -1

        if (scanResult == '-1') return;

        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);

        final ScanModel newScan = await scanListProvider.newScan(scanResult);

        launchURL(context, newScan);
      },
    );
  }
}
