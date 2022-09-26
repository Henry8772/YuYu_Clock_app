import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:simplicity_clock/helpers/db.dart';

import 'model/event.dart';

class Clock extends StatefulWidget {
  String clockType;
  Clock({Key? key, required this.clockType}) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> with SingleTickerProviderStateMixin {
  Duration duration = const Duration();
  int shownHour = 0;
  int shownMin = 0;
  int shownSec = 1;
  Duration setCountdown = const Duration();
  Duration remaining = const Duration();
  Timer? timer;
  bool isPlaying = false;
  late AnimationController controller;
  String clockType = 'Countdown';
  late int storedDuration;
  late DateTime createdDateTime;

  @override
  void initState() {
    super.initState();
    clockType = widget.clockType;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      if (clockType == "Countdown" && remaining.inSeconds == 0) {
        timer?.cancel();
        completeTimer();
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
    remaining = Duration(seconds: shownHour * 3600 + shownMin * 60 + shownSec);
    setCountdown = remaining;
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    print("$duration.inSeconds");
  }

  void stopTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  void resetTimer() {
    if (isPlaying) {
      toggleIcon();
      stopTimer();
    }
    shownHour = 0;
    shownMin = 0;
    shownSec = 0;

    setState(() => duration = const Duration());
  }

  void completeTimer() {
    storedDuration = setCountdown.inSeconds;
    createdDateTime = DateTime.now();
    print("$storedDuration + $createdDateTime");
    addEvent();
  }

  Future addEvent() async {
    final note = Event(
      duration: storedDuration,
      createdDate: createdDateTime,
      createdTime: createdDateTime,
    );

    await CalendarDatabase.instance.insertEvent(note);
  }

  @override
  Widget build(BuildContext context) {
    // String twoDigits(int n) => n.toString().padLeft(2, '0');
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('EEE, d/M/y').format(now);
    // print("$isPlaying $clockType $duration.inSeconds ");
    if (isPlaying && clockType == 'Countdown') {
      shownHour = remaining.inHours;
      shownMin = remaining.inMinutes.remainder(60);
      shownSec = remaining.inSeconds.remainder(60);
    } else if (isPlaying && clockType == 'Timer') {
      shownHour = duration.inHours;
      shownMin = duration.inMinutes.remainder(60);
      shownSec = duration.inSeconds.remainder(60);
      // print("Is playing and in timer $shownHour $shownMin $shownSec");
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildTimeCard(shownHour, 'h'),
                buildComma(),
                // const SizedBox(
                //   width: 8,
                // ),
                buildTimeCard(shownMin, 'm'),
                // const SizedBox(
                //   width: 8,
                // ),
                buildComma(),
                buildTimeCard(shownSec, 's'),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(100, 32, 0, 0),
              child: Text(
                "$clockType $formattedTime",
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(100, 0, 0, 32),
              child: IconButton(
                iconSize: 50,
                icon: Icon(
                  Icons.restart_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  resetTimer();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateDrag(DragUpdateDetails details, String label) {
    if (clockType != 'Countdown') return;
    // int divFactor = (label == "h") ? 8 : 4;
    int divFactor = 2;
    int offset = (details.delta.dy / divFactor).round() * -1;
    switch (label) {
      case 'h':
        if (shownHour + offset >= 0 && shownHour + offset <= 60) {
          shownHour += offset;
        }
        break;
      case 'm':
        if (shownMin + offset >= 0 && shownMin + offset <= 60) {
          shownMin += offset;
        }
        break;
      case 's':
        if (shownSec + offset >= 0 && shownSec + offset <= 60) {
          shownSec += offset;
        }
        break;
    }

    print("$label $offset $shownHour $shownMin $shownSec");
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
