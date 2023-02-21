import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String message;

  EmptyPage(this.message);

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
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
