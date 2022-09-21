import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:simplicity_clock/clock.dart';
import 'package:simplicity_clock/page/calendar.dart';

class Boarding extends StatefulWidget {
  const Boarding({super.key});

  @override
  State<Boarding> createState() => _SliderState();
}

class _SliderState extends State<Boarding> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        showNextButton: false,
        showDoneButton: false,
        globalBackgroundColor: Colors.black,
        rawPages: [
          Calendar(),
          Clock(
            clockType: 'Countdown',
          ),
          Clock(
            clockType: 'Timer',
          ),
        ],
        dotsDecorator: getDotDecoration(),
        onDone: () {},
        done: Text(""));
  }

  DotsDecorator getDotDecoration() => DotsDecorator(
      color: Color(0xFFBDBDBD),
      size: Size(10, 10),
      activeSize: Size(22, 10),
      activeColor: Colors.white,
      activeShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)));
}
