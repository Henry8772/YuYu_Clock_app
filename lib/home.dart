import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Duration duration = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void addTime(){
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
  }

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm:ss').format(now);

    return Scaffold(
      backgroundColor: Colors.black,
      body:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildTime(time: minutes),
            const SizedBox(width: 8,),
            buildTime(),
          ],
        ),
    );
  }

  void updateDrag(){

  }


  GestureDetector buildTime(){
    return GestureDetector(
      onVerticalDragStart: (details) {
        print('VerticalDragStart: $details');
      },
      onVerticalDragUpdate: (details) {
        updateDrag();
        print('VerticalDragUpdate: $details');
      },
      onVerticalDragEnd: (details) {
        print('VerticalDragEnd: $details');
      },
      child: Text('${duration.inSeconds}',
        style: TextStyle(
          fontSize: 170,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
    );
  }
}
