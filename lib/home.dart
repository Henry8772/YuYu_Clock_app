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
  int hour = 0;
  int minute = 0;
  int second = 0;
  Duration remaining = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      if (remaining.inSeconds == 0) {
        timer?.cancel();
      } else {
        remaining = Duration(seconds: remaining.inSeconds - 1);
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    remaining = Duration(seconds: hour * 3600 + minute * 60 + second);
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('EEE, d/M/y').format(now);
    hour = remaining.inHours;
    minute = remaining.inMinutes.remainder(60);
    second = remaining.inSeconds.remainder(60);
    // var hours = remaining.inHours;
    // var minutes = twoDigits(remaining.inMinutes.remainder(60));
    // var seconds = twoDigits(remaining.inSeconds.remainder(60));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildTimeCard(hour, 'h'),
                const SizedBox(
                  width: 8,
                ),
                buildTimeCard(minute, 'm'),
                const SizedBox(
                  width: 8,
                ),
                buildTimeCard(second, 's'),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(100, 32, 0, 0),
              child: Text(
                formattedTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 32, 100, 0),
              child: Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateDrag(DragUpdateDetails details, String label) {
    int offset = details.delta.dy.round() * -1;
    switch (label) {
      case 'h':
        if (hour + offset >= 0) hour += offset;
        break;
      case 'm':
        if (minute + offset >= 0) minute += offset;
        break;
      case 's':
        if (second + offset >= 0) second += offset;
        break;
    }
    print("$label $offset $hour $minute $second");
  }

  GestureDetector buildTimeCard(int time, String label) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        updateDrag(details, label);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          time.toString(),
          style: TextStyle(
            fontSize: 170,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
