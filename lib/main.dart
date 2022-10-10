import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:simplicity_clock/page/calendar.dart';
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
    WidgetsFlutterBinding.ensureInitialized();
    hideNavBar();
    return MaterialApp(
      title: 'Flutter Demo',
      home: Boarding(),
      debugShowCheckedModeBanner: false,
    );
  }
}

Future hideNavBar() async =>
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
