import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Icon(
            Icons.qr_code,
            size: 200.0,
          ),
        ),
        Text('Scan your first QR.'),
      ],
    );
  }
}
