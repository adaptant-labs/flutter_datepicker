import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_datepicker_single/flutter_datepicker_single.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DatePicker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter DatePicker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DateTime now = DateTime.now();
  DateTime _selectedDate;
  FlutterDatePickerMode _mode;
  int _result;

  @override
  void initState() {
    super.initState();
    _result = 0;
    _selectedDate = now;
  }

  // Demonstrates the dialog flow and Y-M-D cascading using showDatePicker,
  // for comparison.
  Future<DateTime> selectDateWithDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime(0),
      lastDate: DateTime(9999),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: IntrinsicWidth(
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Selected Date - Day: " + _selectedDate.day.toString() +
                  ", Month: " + _selectedDate.month.toString() +
                  ", Year: " + _selectedDate.year.toString()),
              const SizedBox(height: 24.0),
              _mode != null ?
                Text("Selection Granularity: " + describeEnum(_mode),
                  style: TextStyle(color: Colors.red)) : Container(),
              _result != 0 ?
                Text("Selection Result: " + _result.toString(),
                  style: TextStyle(color: Colors.red)) : Container(),
              const SizedBox(height: 48.0),
              RaisedButton(
                color: Colors.blue,
                  child: const Text("Select date with showDatePicker",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    DateTime selected = await selectDateWithDatePicker(context);

                    if (selected != null) {
                      setState(() {
                        _selectedDate = selected;
                        _mode = null;
                        _result = 0;
                      });
                    }
                  }
              ),
              RaisedButton(
                  child: const Text("Select a year with YearPicker"),
                  onPressed: () async {
                    DateTime selected = await showYearPicker(
                        context: context,
                        initialDate: _selectedDate,
                    );

                    if (selected != null) {
                      setState(() {
                        _selectedDate = selected;
                        _mode = FlutterDatePickerMode.year;
                        _result = selected.year;
                      });
                    }
                  },
              ),
              RaisedButton(
                child: const Text("Select a month with MonthPicker"),
                onPressed: () async {
                  DateTime selected = await showMonthPicker(
                      context: context,
                      initialDate: _selectedDate,
                      title: Text(DateFormat.MMMM().format(_selectedDate) +
                          " " + _selectedDate.year.toString()),
                  );

                  if (selected != null) {
                    setState(() {
                      _selectedDate = selected;
                      _mode = FlutterDatePickerMode.month;
                      _result = selected.month;
                    });
                  }
                },
              ),
              RaisedButton(
                child: const Text("Select a day with DayPicker"),
                onPressed: () async {
                  DateTime selected = await showDayPicker(
                      context: context,
                      initialDate: _selectedDate,
                  );

                  if (selected != null) {
                    setState(() {
                      _selectedDate = selected;
                      _mode = FlutterDatePickerMode.day;
                      _result = selected.day;
                    });
                  }
                },
              ),
            ],
        ),
      ),
      ),
    );
  }
}
