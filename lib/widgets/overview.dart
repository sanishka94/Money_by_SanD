import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/analytics.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../models/transaction.dart';

import '../providers/transactions.dart';
import '../providers/accounts.dart';
import '../providers/categories.dart';
import '../providers/settings.dart';

class Overview extends StatelessWidget {
  Analytics _analytics;

  List<Transaction> txnList;
  List<Account> accList;
  List<Category> catList;
  List<Account> assAccList;
  List<Account> liaAccList;
  List<Category> expCatList;
  List<Category> incCatList;

  @override
  Widget build(BuildContext context) {
    txnList = Provider.of<Transactions>(context).transactionList;
    accList = Provider.of<Accounts>(context).accountList;
    catList = Provider.of<Categories>(context).categoryList;
    assAccList =
        Provider.of<Accounts>(context).filterAccByType(Account.ACCTYPES[0]);
    liaAccList =
        Provider.of<Accounts>(context).filterAccByType(Account.ACCTYPES[1]);
    incCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[0]);
    expCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[1]);

    _analytics =
        Analytics(txnList: txnList, accList: accList, catList: catList);
    double monthlyBudget =
        Provider.of<Settings>(context).getBudgetByDate(DateTime.now());
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.tealAccent[400], Colors.purpleAccent[400]])),
      child: Column(
        children: <Widget>[
          Text('Budget',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '${_analytics.expensesByMonth(DateTime.now())}',
                style: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(' | ',
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text(
                  '${(monthlyBudget - _analytics.expensesByMonth(DateTime.now())).toString()}',
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Activity',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  )),
              Text('Remaining',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  )),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: <Widget>[
          //     Text(
          //       '${_analytics.expensesByDay(DateTime.now())}',
          //       style: TextStyle(
          //           fontSize: 50,
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold),
          //     ),
          //     Text(' / ${dailyBudget.toStringAsFixed(0)}',
          //         style: TextStyle(fontSize: 20, color: Colors.white))
          //   ],
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          // Text('Today', style: TextStyle(fontSize: 15, color: Colors.white)),
        ],
      ),
    );
  }
}
