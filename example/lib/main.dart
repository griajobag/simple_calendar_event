import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_calendar_event/simple_calendar_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Calendar Event Usage"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SimpleCalendarEvent(listEvent: [
        DateTime(2022,09,11),
        DateTime(2022,09,10),
        DateTime(2022,09,15),
        DateTime(2022,09,22),
      ],
        crossAxisSpacing: defaultTargetPlatform == TargetPlatform.android ?1:16,
        mainAxisSpacing:  defaultTargetPlatform == TargetPlatform.android ?1:16,
        onDateClicked: (date){
          if(kIsWeb){
            Fluttertoast.showToast(
                msg: date.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        },
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
