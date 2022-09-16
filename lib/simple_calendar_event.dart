import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class SimpleCalendarEvent extends StatefulWidget {
  final List<DateTime> listEvent;
  final Function(DateTime?) onDateClicked;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double paddingBetweenDate;

  const SimpleCalendarEvent(
      {Key? key, required this.listEvent,
        required this.onDateClicked,
        this.crossAxisSpacing= 16,
        this.mainAxisSpacing= 16,
        this.paddingBetweenDate = 10
      })
      : super(key: key);
  @override
  State<SimpleCalendarEvent> createState() => _SimpleCalendarEventState();
}

class _SimpleCalendarEventState extends State<SimpleCalendarEvent> {
  late DateTime lastDayOfCurrentMonth;
  late DateTime lastDayOfPrevMonth;
  late List<String> days;
  late int numberOfLastMonthDate;
  List<DateTime> dateMonthChanges = [];
  List<DateTime> dateDisplayed = [];
  late String monthNameSelected;
  int monthSelected = DateTime.now().month;
  int yearSelected = DateTime.now().year;
  late String dateSelected;

  @override
  void initState() {
    lastDayOfCurrentMonth = DateTime(yearSelected, monthSelected + 1, 0);

    lastDayOfPrevMonth = DateTime(yearSelected, monthSelected - 1, 0);
    numberOfLastMonthDate = DateTime(yearSelected, monthSelected, 0).day;
    days = ["MIN", "SEN", "SEL", "RAB", "KAM", "JUM", "SAB"];
    monthNameSelected = DateFormat("MMM").format(DateTime.now());
    dateSelected = _stringDate(DateTime.now());
    _generatePrevMonthDateForCurrentMonth();
    _generateDisplayedDate();
    _generateNextMonthDateForCurrentMonth();

    super.initState();
  }

  String _stringDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }

  void _clearAllList() {
    setState(() {
      dateMonthChanges.clear();
      dateDisplayed.clear();
    });
  }

  void _generateDisplayedDate() {
    for (var i = 1; i <= lastDayOfCurrentMonth.day; i++) {
      dateDisplayed.add(
          DateTime(lastDayOfCurrentMonth.year, lastDayOfCurrentMonth.month, i));
    }
  }

  bool _isContainEvents(DateTime date) {
    bool isEvent = widget.listEvent
        .where((element) => _stringDate(element) == _stringDate(date))
        .isNotEmpty;
    return isEvent;
  }

  void _generateNextMonthDateForCurrentMonth() {
    List<DateTime> listDayNextMonthForCurrentMonth = [];
    for (int i = 0;
        i <
            7 -
                (_totalDisableDatePreviousMonth(
                        DateFormat("E").format(lastDayOfCurrentMonth)) +
                    1);
        i++) {
      listDayNextMonthForCurrentMonth
          .add(DateTime(yearSelected, monthSelected + 1, i + 1));
    }
    dateDisplayed.addAll(listDayNextMonthForCurrentMonth);
  }

  void _generatePrevMonthDateForCurrentMonth() {
    final dateName =
        DateFormat("E").format(DateTime(yearSelected, monthSelected, 1));
    List<DateTime> listDayLastMonthForCurrentMonth = [];
    for (int i = numberOfLastMonthDate;
        i > (numberOfLastMonthDate - _totalDisableDatePreviousMonth(dateName));
        i--) {
      final lastDayKemarin = DateTime(yearSelected, monthSelected - 1, i);
      listDayLastMonthForCurrentMonth.add(
        lastDayKemarin,
      );
    }

    dateDisplayed.addAll(listDayLastMonthForCurrentMonth.reversed);
  }

  int _totalDisableDatePreviousMonth(String day) {
    switch (day.toLowerCase()) {
      case "sun":
        return 0;
      case "mon":
        return 1;
      case "tue":
        return 2;
      case "wed":
        return 3;
      case "thu":
        return 4;
      case "fri":
        return 5;
      case "sat":
        return 6;
      default:
        return 0;
    }
  }

  void _goToPrevMonth() {
    setState(() {
      setState(() {
        _clearAllList();
        if (monthSelected == 1) {
          monthSelected = 12;
          yearSelected = yearSelected - 1;
        } else {
          monthSelected = monthSelected - 1;
        }

        lastDayOfCurrentMonth = DateTime(yearSelected, monthSelected + 1, 0);

        lastDayOfPrevMonth = DateTime(yearSelected, monthSelected - 1, 0);
        numberOfLastMonthDate = DateTime(yearSelected, monthSelected, 0).day;

        monthNameSelected =
            DateFormat("MMM").format(DateTime(yearSelected, monthSelected));
        _generatePrevMonthDateForCurrentMonth();
        _generateDisplayedDate();
        _generateNextMonthDateForCurrentMonth();
      });
    });
  }

  void _goToNextMonth() {
    setState(() {
      _clearAllList();
      if (monthSelected == 12) {
        monthSelected = 1;
        yearSelected = yearSelected + 1;
      } else {
        monthSelected = monthSelected + 1;
      }

      lastDayOfCurrentMonth = DateTime(yearSelected, monthSelected + 1, 0);

      lastDayOfPrevMonth = DateTime(yearSelected, monthSelected - 1, 0);
      numberOfLastMonthDate = DateTime(yearSelected, monthSelected, 0).day;

      monthNameSelected =
          DateFormat("MMM").format(DateTime(yearSelected, monthSelected));
      _generatePrevMonthDateForCurrentMonth();
      _generateDisplayedDate();
      _generateNextMonthDateForCurrentMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      _goToPrevMonth();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios_rounded, size: 15,),
                          Text("Prev".toUpperCase()),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "${monthNameSelected.toUpperCase()}, ${yearSelected.toString().toUpperCase()}",textAlign: TextAlign.center,),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _goToNextMonth();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Next".toUpperCase()),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 15,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StaggeredGrid.count(
              crossAxisCount: 7,
              children: List.generate(
                  days.length,
                  (index) => Center(
                          child: Text(
                        days[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ))), // add some space
            ),
            const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            AlignedGridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.mainAxisSpacing,
              itemCount: dateDisplayed.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => {
                  widget.onDateClicked(dateDisplayed[index]),
                  setState(() {
                    dateSelected = _stringDate(dateDisplayed[index]);
                    if (dateDisplayed[index].year == yearSelected) {
                      if (monthSelected > dateDisplayed[index].month) {
                        _goToPrevMonth();
                      } else if (monthSelected < dateDisplayed[index].month) {
                        _goToNextMonth();
                      }
                    } else {
                      yearSelected = dateDisplayed[index].year;
                      if (monthSelected == 12) {
                        _goToNextMonth();
                      } else if (monthSelected == 1) {
                        _goToPrevMonth();
                      } else {
                        if (monthSelected > dateDisplayed[index].month) {
                          _goToPrevMonth();
                        } else if (monthSelected < dateDisplayed[index].month) {
                          _goToNextMonth();
                        }
                      }
                    }
                  }),
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:  EdgeInsets.all(widget.paddingBetweenDate),
                  child: Column(
                    children: [
                      Text(
                        "${dateDisplayed[index].day}",
                        style: TextStyle(
                            fontWeight: _stringDate(dateDisplayed[index]) ==
                                    _stringDate(DateTime.now())
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: dateSelected ==
                                    _stringDate(dateDisplayed[index])
                                ? Colors.blue
                                : dateDisplayed[index].month == monthSelected
                                    ? Colors.black
                                    : Colors.grey),
                      ),
                      _isContainEvents(dateDisplayed[index])
                          ? const Icon(
                              Icons.circle,
                              size: 5,
                              color: Colors.blue,
                            )
                          : Container(
                              height: 5,
                            )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
