import 'package:flutter/material.dart';
import 'gifyPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gify',
      home: GifyPage(),
    );
  }
}
