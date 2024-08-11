import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/map_page.dart';
import 'providers/scan_list_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set multiple providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => new ScanListProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QR Scanner',
          initialRoute: 'home',
          routes: {
            'home': (context) => HomePage(),
            'map': (context) => MapPage(),
          },
          theme: ThemeData(
            primarySwatch: Colors.teal,
          )),
    );
  }
}
