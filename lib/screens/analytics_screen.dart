import 'package:charts_flutter/flutter.dart' as chf;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../models/analytics.dart';
import '../models/transaction.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../providers/transactions.dart';
import '../providers/accounts.dart';
import '../providers/categories.dart';

class DayExpense {
  int day;
  double amount;

  DayExpense(this.day, this.amount);
}

class AnalyticsScreen extends StatefulWidget {
  static const routeName = '/analytics';

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<Transaction> txnList = [];

  List<Category> catList = [];

  List<Account> accList = [];

  Analytics analytics = Analytics(accList: [], catList: [], txnList: []);

  List<Category> incCatList = [];
  List<Category> expCatList = [];
  List<DayExpense> days = [];

  Map<int, double> dailyExpensesMap = {};

  List<charts.Series<Category, dynamic>> seriesExpCat;
  List<charts.Series<Category, dynamic>> seriesIncCat;

  List<charts.Series<DayExpense, num>> seriesDay;
  Color labelColor = Colors.grey[600];
  Color valueColor = Colors.black;
  MediaQueryData queryData;

  void startCode(BuildContext ctx) {
    seriesExpCat = [
      charts.Series(
        id: 'Expenses Distribution',
        data: expCatList,
        domainFn: (Category cat, _) => cat.title,
        measureFn: (Category cat, _) => analytics.expensesByCategory(cat.id),
        colorFn: (Category cat, _) =>
            charts.ColorUtil.fromDartColor(cat.catColor),
        labelAccessorFn: (Category cat, _) => cat.title,
      )
    ];

    seriesIncCat = [
      charts.Series(
        id: 'Income Distribution',
        data: incCatList,
        domainFn: (Category cat, _) => cat.title,
        measureFn: (Category cat, _) => analytics.incomeByCategory(cat.id),
        colorFn: (Category cat, _) =>
            charts.ColorUtil.fromDartColor(cat.catColor),
        labelAccessorFn: (Category cat, _) => cat.title,
      )
    ];

    for (Transaction txn
        in analytics.monthlyTransactionsExpenses(DateTime.now())) {
      if (dailyExpensesMap[txn.date.day] == null) {
        dailyExpensesMap[txn.date.day] = txn.amount;
      } else {
        dailyExpensesMap[txn.date.day] += txn.amount;
      }
    }
    int x = 1;
    List<int> sortedDays = dailyExpensesMap.keys.toList();
    sortedDays.sort((a, b) => a.compareTo(b));
    int lastDay = sortedDays[sortedDays.length - 1];
    while (x <= lastDay) {
      if (dailyExpensesMap[x] == null) {
        days.add(DayExpense(x, 0));
      } else {
        days.add(DayExpense(x, dailyExpensesMap[x]));
      }
      x += 1;
    }

    seriesDay = [
      charts.Series(
        id: 'Expenses Daily',
        data: days,
        domainFn: (DayExpense day, _) => day.day,
        measureFn: (DayExpense day, _) => day.amount,
        labelAccessorFn: (DayExpense day, _) => day.day.toString(),
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Theme.of(ctx).primaryColor),
      )
    ];
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    txnList = Provider.of<Transactions>(context).orderedList();
    accList = Provider.of<Accounts>(context).accountList;
    catList = Provider.of<Categories>(context).categoryList;
    analytics = Analytics(accList: accList, catList: catList, txnList: txnList);
    double screenWidth = queryData.size.width;

    incCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[0]);
    expCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[1]);

    if (txnList.length > 0) {
      startCode(context);
    }

    return Container(
        child: txnList.length <= 0
            ? Center(
                child: Text('No Transactions added yet'),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 130,
                            width: (screenWidth / 2) - 20,
                            decoration: myBoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Net Worth',
                                    style: TextStyle(
                                        color: labelColor, fontSize: 20)),
                                Container(
                                  child: Text(
                                    analytics.networth.toString(),
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: valueColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 130,
                            width: (screenWidth / 2) - 20,
                            decoration: myBoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Net Liabilities',
                                    style: TextStyle(
                                        color: labelColor, fontSize: 20)),
                                Container(
                                  child: Text(
                                    analytics.netLiabilities.toString(),
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: valueColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: myBoxDecoration(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: 350,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Expenses by Category',
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 250,
                            child: charts.PieChart(
                              seriesExpCat,
                              defaultRenderer: charts.ArcRendererConfig(
                                  arcWidth: 40,
                                  arcRendererDecorators: [
                                    charts.ArcLabelDecorator(
                                      labelPosition:
                                          chf.ArcLabelPosition.outside,
                                      outsideLabelStyleSpec:
                                          charts.TextStyleSpec(
                                        fontSize: 20,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: myBoxDecoration(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Column(
                        children: <Widget>[
                          Text('Daily Expenses',
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 20,
                              )),
                          Container(
                            height: 250,
                            child: charts.LineChart(
                              seriesDay,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: myBoxDecoration(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: 350,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Income by Category',
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 250,
                            child: charts.PieChart(
                              seriesIncCat,
                              defaultRenderer: charts.ArcRendererConfig(
                                  arcWidth: 40,
                                  arcRendererDecorators: [
                                    charts.ArcLabelDecorator(
                                      labelPosition:
                                          chf.ArcLabelPosition.outside,
                                      outsideLabelStyleSpec:
                                          charts.TextStyleSpec(
                                        fontSize: 20,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ));
  }
}
