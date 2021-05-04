import 'package:flutter/material.dart';

import 'package:qr_scanner/widgets/list_tiles.dart';

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTiles(type: 'geo');
  }
}
