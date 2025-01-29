import 'package:Money/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings.dart';
import '../models/setting.dart';

class EditMonthlyBudget extends StatefulWidget {
  Setting nowBudget;

  EditMonthlyBudget(this.nowBudget);

  @override
  _EditMonthlyBudgetState createState() => _EditMonthlyBudgetState();
}

class _EditMonthlyBudgetState extends State<EditMonthlyBudget> {
  final formKeyB = GlobalKey<FormState>();
  int _year;
  int _month;
  int _id;
  int _yearIndex;
  int _monthIndex;
  List<int> _years;
  List<int> _months;
  double _value;
  Setting oldBudget;
  bool isInit = false;
  double _oldValue = 0;

  TextStyle labelStyle = TextStyle(fontSize: 18);
  TextStyle valueStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  Widget yearDropDownMenu() {
    return DropdownButton<int>(
      value: _yearIndex,
      onChanged: (index) {
        setState(() {
          _yearIndex = index;
          _year = _years[_yearIndex];
          oldBudget = Provider.of<Settings>(context, listen: false)
              .getSettById(createId(_year, _month));
          _oldValue = oldBudget == null ? 0 : oldBudget.value;
        });
      },
      items: List<int>.generate(_years.length, (i) => i)
          .map<DropdownMenuItem<int>>((index) => DropdownMenuItem(
                value: index,
                child: Text(
                  '${_years[index]}',
                  style: valueStyle,
                ),
              ))
          .toList(),
    );
  }

  Widget monthDropDownMenu() {
    return DropdownButton<int>(
      value: _monthIndex,
      onChanged: (index) {
        setState(() {
          _monthIndex = index;
          _month = _months[_monthIndex];
          oldBudget = Provider.of<Settings>(context, listen: false)
              .getSettById(createId(_year, _month));
          _oldValue = oldBudget == null ? 0 : oldBudget.value;
        });
      },
      items: List<int>.generate(_months.length, (i) => i)
          .map<DropdownMenuItem<int>>((index) => DropdownMenuItem(
                value: index,
                child: Text(
                  '${_months[index]}',
                  style: valueStyle,
                ),
              ))
          .toList(),
    );
  }

  void submit(int id, double val) {
    if (val <= 0) {
      return;
    }
    Setting sett = Setting(id: id, type: 'budget', value: val);
    Provider.of<Settings>(context, listen: false).addSetting(sett);
  }

  int createId(int year, int month) {
    int id =
        month < 10 ? int.parse('${year}0$month') : int.parse('$year$month');
    return id;
  }

  int getYear(int id) {
    return int.parse('$id'.substring(0, 4));
  }

  int getMonth(int id) {
    return int.parse('$id'.substring(4, 6));
  }

  @override
  void initState() {
    _id = widget.nowBudget.id;
    _year = getYear(_id);
    _month = getMonth(_id);
    _years = [_year - 2, _year - 1, _year, _year + 1];
    _months = List<int>.generate(12, (index) => index + 1);
    _yearIndex = _years.indexOf(_year);
    _monthIndex = _months.indexOf(_month);
    _value = widget.nowBudget.value;
    isInit = true;
    oldBudget = Provider.of<Settings>(context, listen: false)
        .getSettById(createId(_year, _month));
    _oldValue = oldBudget == null ? 0 : oldBudget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _id = createId(_year, _month);
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: formKeyB,
        child: Column(
          children: <Widget>[
            Text(
              'Select Year and Month',
              style: labelStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Year:   ',
                  style: labelStyle,
                ),
                yearDropDownMenu(),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Month:   ',
                  style: labelStyle,
                ),
                monthDropDownMenu(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text(
                  'Existing Budget',
                  style: labelStyle,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  '${_oldValue}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'New Budget',
              ),
              initialValue: '$_value',
              keyboardType: TextInputType.number,
              onSaved: (newValue) {
                setState(() {
                  _value = newValue.isEmpty ? _value : double.parse(newValue);
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // FlatButton(
                //   color: Theme.of(context).primaryColor,
                //   child: Text('Get budget'),
                //   onPressed: () {
                //     setState(() {
                //       formKeyB.currentState.save();
                //       oldBudget = Provider.of<Settings>(context, listen: false)
                //           .getSettById(createId(_year, _month));
                //       _oldValue = oldBudget == null ? 0 : oldBudget.value;
                //     });
                //   },
                // ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Set'),
                  onPressed: () {
                    setState(() {
                      formKeyB.currentState.save();
                    });
                    submit(_id, _value);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
