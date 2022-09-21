import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();

  // CalendarController _calendarController = CalendarController();
  Map<DateTime, List<dynamic>> _events = {};
  // List<CalendarItem> _data = [];

  List<dynamic> _selectedEvents = [];
  // List<Widget> get _eventWidgets =>
  // _selectedEvents.map((e) => events(e)).toList();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void dispose() {
    // _calendarController.dispose();
    super.dispose();
  }

  // void _onDaySelected(DateTime day, List events) {
  //   setState(() {
  //     _selectedDay = day;
  //     _selectedEvents = events;
  //   });
  // }

  Widget calendar() {
    return FractionallySizedBox(
      widthFactor: 0.5,
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFEF5350)]),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 24,
                  offset: new Offset(0.0, 5))
            ]),
        child: TableCalendar(
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              color: Colors.white,
              // fontSize: 0,
            ),
            // leftChevronVisible: false,
            // rightChevronVisible: false,
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ),
          calendarStyle: const CalendarStyle(
            cellPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            todayTextStyle: TextStyle(
                color: Colors.redAccent,
                fontSize: 15,
                fontWeight: FontWeight.bold),
            selectedDecoration: BoxDecoration(
              color: Color(0xFFB71C1C),
              shape: BoxShape.circle,
            ),
            weekNumberTextStyle: TextStyle(color: Colors.white),
            defaultTextStyle: TextStyle(color: Colors.white),
            weekendTextStyle: TextStyle(color: Colors.white),
            outsideTextStyle: TextStyle(color: Colors.white60),
            withinRangeTextStyle: TextStyle(color: Colors.white),
            outsideDaysVisible: false,
          ),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              // _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
        ),
      ),
    );
  }

  Widget eventTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
      child: const Text(
        "Events",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 8, 0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: calendar()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eventTitle(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.red],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.label,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          const Text(
                            "Timer",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        'Office',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
