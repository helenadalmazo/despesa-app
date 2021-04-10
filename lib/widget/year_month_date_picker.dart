import 'package:despesa_app/formatter/date_format.dart';
import 'package:flutter/material.dart';

enum YearMonthDatePickerMode {
  year,
  month,
}

class YearMonth {
  int year;
  int month;
}

class YearMonthDatePicker extends StatefulWidget {

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialDate;

  const YearMonthDatePicker({
    Key key,
    @required this.firstDate,
    @required this.lastDate,
    @required this.initialDate
  }) : super(key: key);

  _YearMonthDatePickerState createState() => _YearMonthDatePickerState();
}

class _YearMonthDatePickerState extends State<YearMonthDatePicker> {

  DateTime _firstDate;
  DateTime _lastDate;

  int _year;
  int _month;

  YearMonthDatePickerMode _mode = YearMonthDatePickerMode.month;

  List<int> _years;
  List<int> _months;

  @override
  void initState() {
    super.initState();
    _firstDate = widget.firstDate;
    _lastDate = widget.lastDate;

    _year = widget.initialDate.year;
    _month = widget.initialDate.month;

    _years = [];
    for (var year = _firstDate.year; year <= _lastDate.year + 1; year++) {
      _years.add(year);
    }

    _months = [
      DateTime.january,
      DateTime.february,
      DateTime.march,
      DateTime.april,
      DateTime.may,
      DateTime.june,
      DateTime.july,
      DateTime.august,
      DateTime.september,
      DateTime.october,
      DateTime.november,
      DateTime.december,
    ];
  }

  void _cancel(BuildContext context) {
    Navigator.pop(context, null);
  }

  void _submit(BuildContext context) {
    DateTime dateTime = DateTime(_year, _month);
    Navigator.pop(context, dateTime);
  }

  void _changeToModeYear() {
    setState(() {
      _mode = YearMonthDatePickerMode.year;
    });
  }

  void _selectMonth(int month) {
    setState(() {
      _month = month;
    });
  }

  void _selectYear(int year) {
    setState(() {
      _year = year;
      _mode = YearMonthDatePickerMode.month;
    });
  }

  Widget _getHeader(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selecione uma data",
            style: TextStyle(
              color: Colors.white
            )
          ),
          SizedBox(
            height: 4
          ),
          Text(
            "${DateFormat.getMonthAbbreviation(_month)}/$_year",
            style: Theme.of(context).textTheme.headline6.merge(
              TextStyle(
                color: Colors.white
              )
            ),
          )
        ],
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    Widget yearButton;
    Widget body;

    if (_mode == YearMonthDatePickerMode.month) {
      yearButton = TextButton(
        onPressed: () => _changeToModeYear(),
        child: Text(
          _year.toString()
        ),
      );
      body = _getMonths(context);
    } else {
      yearButton = SizedBox(
        height: 16,
      );
      body = _getYears(context);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        children: [
          yearButton,
          body
        ],
      ),
    );
  }

  Widget _getMonths(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 4/2,
      ),
      itemCount: _months.length,
      itemBuilder: (context, index) {
        bool selected = _months[index] == _month;

        DateTime dateTime = DateTime(_year, _months[index]);
        bool enable = dateTime.isAfter(_lastDate) || dateTime.isBefore(_firstDate);

        return Container(
          padding: EdgeInsets.all(4),
          child: FlatButton(
            onPressed: enable ? null : () => _selectMonth(_months[index]),
            child: Text(
              DateFormat.getMonthAbbreviation(_months[index]),
              style: Theme.of(context).textTheme.subtitle1.merge(
                TextStyle(
                color: enable ? Colors.grey : selected ? Colors.white : null,
                )
              ),
            ),
            color: selected ? Theme.of(context).accentColor : null,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(32.0)
            ),
          ),
        );
      },
    );
  }

  Widget _getYears(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 4/2,
      ),
      itemCount: _years.length,
      itemBuilder: (context, index) {
        bool selected = _years[index] == _year;

        DateTime dateTime = DateTime(_years[index], _month);
        bool enable = dateTime.isAfter(_lastDate) || dateTime.isBefore(_firstDate);

        return Container(
          padding: EdgeInsets.all(4),
          child: FlatButton(
            onPressed: enable ? null : () => _selectYear(_years[index]),
            child: Text(
              _years[index].toString(),
              style: Theme.of(context).textTheme.subtitle1.merge(
                TextStyle(
                  color: enable ? Colors.grey : selected ? Colors.white : null,
                )
              ),
            ),
            color: selected ? Theme.of(context).accentColor : null,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(32),
            ),
          ),
        );
      },
    );
  }

  Widget _getButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => _cancel(context),
          child: Text(
            "CANCELAR"
          ),
        ),
        TextButton(
          onPressed: () => _submit(context),
          child: Text(
            "OK"
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
//      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getHeader(context),
          _getBody(context),
          _getButtons(context),
        ],
      ),
    );
  }
}