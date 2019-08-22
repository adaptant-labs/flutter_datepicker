import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Type of date picker for [FlutterDatePicker] to use.
///
/// This is primarily used as an internal mechanism for the various accessors
/// ([showYearPicker], [showMonthPicker], [showDayPicker]) to signal their
/// required picker type, but is exposed to support direct instantiation of
/// [FlutterDatePicker], where desired.
enum FlutterDatePickerMode {
  /// Show a date picker for choosing a day.
  day,

  /// Show a date picker for choosing a month.
  month,

  /// Show a date picker for choosing a year.
  year,
}

/// Select a year by calling the [YearPicker] class directly.
Future<DateTime> showYearPicker({
  @required BuildContext context,
  @required DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
  Widget title,
  EdgeInsetsGeometry titlePadding,
}) async {
  assert(context != null);
  assert(initialDate != null);

  return await showDialog(
    context: context,
    builder: (context) => FlutterDatePicker(
      mode: FlutterDatePickerMode.year,
      selectedDate: initialDate,
      firstDate: firstDate ?? DateTime(0),
      lastDate: lastDate ?? DateTime(9999),
      title: title,
      titlePadding: titlePadding,
    ),
  );
}

/// Select a month by calling the [MonthPicker] class directly.
Future<DateTime> showMonthPicker({
  @required BuildContext context,
  @required DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
  Widget title,
  EdgeInsetsGeometry titlePadding,
}) async {
  assert(context != null);
  assert(initialDate != null);

  return await showDialog(
    context: context,
    builder: (context) => FlutterDatePicker(
      mode: FlutterDatePickerMode.month,
      selectedDate: initialDate,
      firstDate: firstDate ?? DateTime(0),
      lastDate: lastDate ?? DateTime(9999),
      title: title,
      titlePadding: titlePadding,
    ),
  );
}

/// Select a day by calling the [DayPicker] class directly.
Future<DateTime> showDayPicker({
  @required BuildContext context,
  @required DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
  Widget title,
  EdgeInsetsGeometry titlePadding,
}) async {
  assert(context != null);
  assert(initialDate != null);

  return await showDialog(
    context: context,
    builder: (context) => FlutterDatePicker(
      mode: FlutterDatePickerMode.day,
      selectedDate: initialDate,
      firstDate: firstDate ?? DateTime(0),
      lastDate: lastDate ?? DateTime(9999),
      title: title,
      titlePadding: titlePadding,
    ),
  );
}

/// A non-cascading [SimpleDialog] view of a [FlutterDatePickerMode] picker.
///
/// In general this class does not need to be used directly, and should
/// be primarily accessed through the [showYearPicker], [showMonthPicker]
/// and [showDayPicker] convenience wrappers.
class FlutterDatePicker extends StatefulWidget {
  final FlutterDatePickerMode mode;
  final EdgeInsetsGeometry titlePadding;
  final Widget title;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;

  FlutterDatePicker(
      {Key key,
      @required this.mode,
      this.title,
      this.titlePadding,
      @required this.selectedDate,
      @required this.firstDate,
      @required this.lastDate})
      : assert(!firstDate.isAfter(lastDate)),
        assert(
            selectedDate.isAfter(firstDate) && selectedDate.isBefore(lastDate)),
        super(key: key);

  @override
  _FlutterDatePickerState createState() => _FlutterDatePickerState();
}

class _FlutterDatePickerState extends State<FlutterDatePicker> {
  final GlobalKey _pickerKey = GlobalKey();
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  Widget _defaultPickerHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Text("Select a " + describeEnum(widget.mode),
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Colors.white)),
        color: Theme.of(context).primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        titlePadding: widget.titlePadding ?? widget.title == null
            ? EdgeInsets.all(0)
            : EdgeInsets.all(20.0),
        title: widget.title ?? _defaultPickerHeader(context),
        children: <Widget>[
          Container(
            height: 300,
            width: double.maxFinite,
            child: widget.mode == FlutterDatePickerMode.year
                ? YearPicker(
                    key: _pickerKey,
                    firstDate: widget.firstDate,
                    selectedDate: _selectedDate,
                    lastDate: widget.lastDate,
                    onChanged: (DateTime selected) {
                      setState(() {
                        _selectedDate = selected;
                      });
                    },
                  )
                : widget.mode == FlutterDatePickerMode.month
                    ? MonthPicker(
                        key: _pickerKey,
                        firstDate: widget.firstDate,
                        selectedDate: _selectedDate,
                        lastDate: widget.lastDate,
                        onChanged: (DateTime selected) {
                          setState(() {
                            _selectedDate = selected;
                          });
                        },
                      )
                    : DayPicker(
                        key: _pickerKey,
                        displayedMonth: widget.selectedDate,
                        firstDate: widget.firstDate,
                        selectedDate: _selectedDate,
                        currentDate: DateTime.now(),
                        lastDate: widget.lastDate,
                        onChanged: (DateTime selected) {
                          setState(() {
                            _selectedDate = selected;
                          });
                        },
                      ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold)),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedDate);
                },
                child: Text('OK',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ]);
  }
}
