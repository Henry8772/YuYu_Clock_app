import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late Event event;
  bool isLoading = false;
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

    selectDate(_selectedDay);
  }

  void selectDate(DateTime selectedDay) {
    print('RetrieveEventByDay $selectedDay');
    refreshCalendar(selectedDay);
  }

  Future refreshCalendar(DateTime selectedDay) async {
    setState(() => isLoading = true);

    this.event = await CalendarDatabase.instance.readEventByDate(selectedDay);

    setState(() => isLoading = false);
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
      widthFactor: 1,
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          // color: Colors.orange,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: calendar()),
              Expanded(
                child: Container(
                  // color: Colors.blue,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      eventTitle(),
                      createEventBar(),
                      createEventBar(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container createEventBar() {
    return Container(
      padding: EdgeInsets.all(8),
      // color: Colors.red,
      // width: 300,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: const BoxDecoration(
            // color: Colors.white,
            // gradient: LinearGradient(
            //   colors: [Colors.purple, Colors.red],
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            // ),
            // borderRadius: BorderRadius.all(Radius.circular(20))
            ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(
                  Icons.label,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Timer",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Duration',
                  style: TextStyle(color: Colors.white),
                ),
                // SizedBox(
                //   height: 4,
                // ),
                Text(
                  '1:00:00',
                  style: TextStyle(
                    color: Colors.white,
                    // fontSize: 20,
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
}
