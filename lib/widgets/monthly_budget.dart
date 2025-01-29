import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/edit_monthly_budget.dart';
import '../providers/settings.dart';
import '../models/setting.dart';
import '../providers/database_provider.dart';

class MonthlyBudget extends StatefulWidget {
  @override
  _MonthlyBudgetState createState() => _MonthlyBudgetState();
}

class _MonthlyBudgetState extends State<MonthlyBudget> {
  Setting budget;
  int id;
  double value;
  List<Setting> settList = [];

  int createId(int year, int month) {
    int id =
        month < 10 ? int.parse('${year}0$month') : int.parse('$year$month');
    return id;
  }

  Future<void> _refreshSettings(BuildContext context) async {
    await DatabaseProvider.db.getSettings().then((setList) =>
        Provider.of<Settings>(context, listen: false).setSettings(setList));
  }

  @override
  void initState() {
    id = createId(DateTime.now().year, DateTime.now().month);
    budget = Provider.of<Settings>(context, listen: false).getSettById(id);
    value = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    budget = Provider.of<Settings>(context).getSettById(id);
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'This Months Budget: ${budget == null ? 0 : budget.value}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          FlatButton(
            child: Text('Set Budget'),
            onPressed: () => showDialog(
                context: context,
                child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Text('Set Budget'),
                  children: <Widget>[
                    EditMonthlyBudget(
                        Setting(id: id, type: 'budget', value: value))
                  ],
                )).then((value) {
              setState(() {
                budget = Provider.of<Settings>(context, listen: false)
                    .getSettById(id);
                value = budget == null ? value : budget.value;
              });
            }).then((value) => _refreshSettings(context)),
          ),
        ],
      ),
    );
  }
}
