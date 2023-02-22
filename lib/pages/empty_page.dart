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
          child: Icon(Icons.qr_code, size: 200.0, color: Colors.teal),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
