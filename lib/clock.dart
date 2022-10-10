import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplicity_clock/helpers/db.dart';

import 'model/event.dart';

class Clock extends StatefulWidget {
  String clockType;
  Clock({Key? key, required this.clockType}) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  // late int storedDuration;
  late DateTime timerStartTime;
  bool isStartTimeStored = false;
  late SharedPreferences sharedPreferences;

  Duration passedDuration = const Duration();
  Duration setDuration = const Duration();
  Duration remainDuration = const Duration();
  int shownHour = 0;
  int shownMin = 0;
  int shownSec = 0;
  Timer? timer;
  bool isPlaying = false;
  String clockType = 'Countdown';

  @override
  void initState() {
    super.initState();
    timerStartTime = DateTime.now();
    clockType = widget.clockType;

    if (clockType == 'Countdown') {
      shownHour = 2;
    }

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    initPersist();
  }

  Future<void> initPersist() async {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      final storedRemain = sharedPreferences.getInt('remainDuration') ?? 0;
      if (storedRemain != 0) {
        remainDuration = Duration(seconds: storedRemain);
      }

      final storedPassed = sharedPreferences.getInt('passedDuration') ?? 0;
      if (storedPassed != 0) {
        passedDuration = Duration(seconds: storedPassed);
      }

      final storedCoutdown = sharedPreferences.getInt('setDuration') ?? 0;
      if (storedCoutdown != 0) {
        setDuration = Duration(seconds: storedCoutdown);
      }

      String startTime = sharedPreferences.getString('timerStartTime') ?? "";
      print(startTime);
      if (startTime != "") {
        isStartTimeStored = true;
        timerStartTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime);
      }

      updateShownTime();
      setState(() {});

      print("Load data");
      print("remain : {$storedRemain}");
      print("duration : {$storedPassed}");
      print("setCountdown : {$storedCoutdown}");
      print("timerStartTime : {$timerStartTime}");
    });
  }

  Future<void> setPersist(
    int remainDuration,
    int passedDuration,
    int setDuration,
    String timerStartTime,
  ) async {
    await sharedPreferences.setInt('remainDuration', remainDuration);
    await sharedPreferences.setInt('passedDuration', passedDuration);
    await sharedPreferences.setInt('setDuration', setDuration);
    await sharedPreferences.setString('timerStartTime', timerStartTime);

    if (timerStartTime == "") {
      isStartTimeStored = false;
    }

    print("Store data");
    print("remain : {$remainDuration}");
    print("duration : {$passedDuration}");
    print("setCountdown : {$setDuration}");
    print("timerStartTime : {$timerStartTime}");
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void addTime() {
    setState(() {
      if (clockType == "Countdown" && remainDuration.inSeconds == 0) {
        timer?.cancel();
        completeTimer();
      } else {
        remainDuration = Duration(seconds: remainDuration.inSeconds - 1);
        passedDuration = Duration(seconds: passedDuration.inSeconds + 1);
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
    if (!isStartTimeStored) {
      timerStartTime = DateTime.now();
      isStartTimeStored = true;
      print("Timer start time : {$timerStartTime}");
    }

    remainDuration =
        Duration(seconds: shownHour * 3600 + shownMin * 60 + shownSec);
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer() {
    setState(() {
      timer?.cancel();
    });
    setPersist(
        remainDuration.inSeconds,
        passedDuration.inSeconds,
        setDuration.inSeconds,
        DateFormat("yyyy-MM-dd HH:mm:ss").format(timerStartTime));
  }

  void resetTimer() {
    if (isPlaying) {
      toggleIcon();
      stopTimer();
    }
    shownHour = 0;
    shownMin = 0;
    shownSec = 0;

    passedDuration = Duration(seconds: 0);
    setDuration = Duration(seconds: 0);
    remainDuration = Duration(seconds: 0);

    setPersist(0, 0, 0, "");

    setState(() => passedDuration = const Duration());
  }

  void completeTimer() {
    toggleIcon();
    addEvent(passedDuration.inSeconds);

    passedDuration = const Duration(seconds: 0);
    setDuration = Duration(seconds: 0);
    remainDuration = Duration(seconds: 0);

    setPersist(0, 0, 0, "");
  }

  Future addEvent(int setDuration) async {
    print("Add event to database");
    print("$setDuration + $timerStartTime");
    final note = Event(
      duration: setDuration,
      createdDate: timerStartTime,
      createdTime: timerStartTime,
    );

    await CalendarDatabase.instance.insertEvent(note);
  }

  void updateShownTime() {
    shownHour = remainDuration.inHours;
    shownMin = remainDuration.inMinutes.remainder(60);
    shownSec = remainDuration.inSeconds.remainder(60);
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('EEE, d/M/y').format(now);
    // print("$isPlaying $clockType $duration.inSeconds ");
    if (isPlaying && clockType == 'Countdown') {
      updateShownTime();
    } else if (isPlaying && clockType == 'Timer') {
      updateShownTime();
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
                buildTimeCard(shownMin, 'm'),
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
                icon: const Icon(
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

  int previosDistance = 0;

  void updateDrag(DragUpdateDetails details, String label) {
    if (clockType != 'Countdown') return;
    int slideDistance = details.delta.dy.round();
    int multiplyFactor = (slideDistance >= 0) ? -1 : 1;
    int slideThreshold = 10;
    // print("multiplyFactor: {$multiplyFactor}");
    int offset = slideDistance.abs() + previosDistance;
    // print("offset: {$offset}");
    int moved = (offset / slideThreshold).round();
    // print("moved: {$moved}");
    previosDistance = offset - (moved * slideThreshold);
    // print("previosDistance: {$previosDistance}");

    moved *= multiplyFactor;
    switch (label) {
      case 'h':
        if (shownHour + moved >= 0 && shownHour + moved < 60) {
          shownHour += moved;
        }
        break;
      case 'm':
        if (shownMin + moved >= 0 && shownMin + moved < 60) {
          shownMin += moved;
        }
        break;
      case 's':
        if (shownSec + moved >= 0 && shownSec + moved < 60) {
          shownSec += moved;
        }
        break;
    }

    refresh();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  Text buildComma() {
    return const Text(
      ":",
      style: TextStyle(
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
          twoDigits(time),
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
