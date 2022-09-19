import 'package:flutter/material.dart';
import 'package:simplicity_clock/clock.dart';
import 'package:wakelock/wakelock.dart';
import 'package:simplicity_clock/page/page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      title: 'Flutter Demo',
      home: Boarding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
