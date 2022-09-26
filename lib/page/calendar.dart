import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'package:simplicity_clock/helpers/db.dart';
import 'package:simplicity_clock/model/event.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late List<Event> events = [];
  DateTime _selectedDay = DateTime.now();
  // Map<DateTime, List<dynamic>> _events = {};
  // List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();

    selectDate(_selectedDay);
  }

  void selectDate(DateTime selectedDay) async {
    print('RetrieveEventByDay $selectedDay');

    refreshCalendar(selectedDay);
  }

  Future refreshCalendar(DateTime selectedDay) async {
    // setState(() => isLoading = true);

    events = await CalendarDatabase.instance.readEventByDate(selectedDay);

    // print("$events.id, $this.event.duration");

    setState(() {});
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

  Padding eventTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 8, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "History",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("$events ${events.length}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(36, 8, 24, 8),
        child: Container(
          // color: Colors.orange,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: calendar()),
              Expanded(
                // color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    eventTitle(),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: events.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return createEventBar(
                            DateFormat('HH:mm')
                                .format(events[index].createdTime),
                            formatTime(events[index].duration));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  Container createEventBar(String createdTime, String duration) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.label,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  createdTime,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  duration,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget calendar() {
    return FractionallySizedBox(
      // widthFactor: 1,
      alignment: Alignment.topLeft,
      child: Container(
        // color: Colors.blue,
        // margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFEF5350)]),
            // const LinearGradient(colors: [Colors.pink, Colors.pink[200]]),

            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 24,
                  offset: new Offset(0.0, 5))
            ]),
        child: TableCalendar(
          // calendarFormat: CalendarFormat.twoWeeks,
          startingDayOfWeek: StartingDayOfWeek.monday,
          // daysOfWeekHeight: 10,
          // rowHeight: 10,
          shouldFillViewport: true,
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
            // cellMargin: EdgeInsets.all(0),
            // cellPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
            // defaultDecoration: const BoxDecoration(),
          ),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            print("$selectedDay $focusedDay");

            setState(() {
              _selectedDay = selectedDay;
              // _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
            selectDate(selectedDay);
          },
        ),
      ),
    );
  }
}
