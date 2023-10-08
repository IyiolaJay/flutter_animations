import 'package:animator/spinner.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Spinner(),
    );
  }
}

