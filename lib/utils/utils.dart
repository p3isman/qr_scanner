import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/scan_model.dart';

/// Launches a URL in browser
void launchURL(BuildContext context, ScanModel scan) async {
  final url = Uri.parse(scan.value);

  if (scan.type == 'http') {
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not launch $url';
  } else {
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}
