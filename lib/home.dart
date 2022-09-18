import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Duration duration = const Duration();
  int hour = 0;
  int minute = 0;
  int second = 0;
  Duration remaining = const Duration();
  Timer? timer;
  bool isPlaying = false;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  void toggleIcon() => setState(() {
        isPlaying = !isPlaying;
        if (isPlaying) {
          controller.forward();
          startTimer();
        } else {
          controller.reverse();
          stopTimer();
        }
      });

  refresh() {
    setState(() {});
  }

  void startTimer() {
    remaining = Duration(seconds: hour * 3600 + minute * 60 + second);
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer() {
    // if (resets) {
    //   resets()
    // }
    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('EEE, d/M/y').format(now);
    if (isPlaying) {
      hour = remaining.inHours;
      minute = remaining.inMinutes.remainder(60);
      second = remaining.inSeconds.remainder(60);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildTimeCard(hour, 'h'),
                buildComma(),
                // const SizedBox(
                //   width: 8,
                // ),
                buildTimeCard(minute, 'm'),
                // const SizedBox(
                //   width: 8,
                // ),
                buildComma(),
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
                style: const TextStyle(
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 100, 32),
              child: IconButton(
                iconSize: 50,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: controller,
                  color: Colors.white,
                ),
                onPressed: () {
                  toggleIcon();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateDrag(DragUpdateDetails details, String label) {
    int divFactor = (label == "h") ? 8 : 4;

    int offset = (details.delta.dy / divFactor).round() * -1;
    switch (label) {
      case 'h':
        if (hour + offset >= 0 && hour + offset <= 60) hour += offset;
        break;
      case 'm':
        if (minute + offset >= 0 && minute + offset <= 60) minute += offset;
        break;
      case 's':
        if (second + offset >= 0 && second + offset <= 60) second += offset;
        break;
    }

    print("$label $offset $hour $minute $second");
    refresh();
  }

  Text buildComma() {
    return Text(
      ":",
      style: const TextStyle(
        fontSize: 150,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
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
          style: const TextStyle(
            fontSize: 150,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
