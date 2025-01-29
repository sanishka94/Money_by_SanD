import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../models/transaction.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../widgets/txn_list_item.dart';

class DisplayTransactionsPage extends StatelessWidget {
  static const routeName = '/display-transaction';
  List<Account> accList = [];
  List<Category> catList = [];
  List<Transaction> txnList = [];
  Category cat;
  Account acc;

  DisplayTransactionsPage({this.acc, this.cat});

  @override
  Widget build(BuildContext context) {
    String title = 'Blank';
    Color color = Theme.of(context).primaryColor;
    if (acc != null) {
      title = acc.title;
      color = acc.accColor;
      txnList =
          Provider.of<Transactions>(context).getTransactionsByAccount(acc.id);
    } else if (cat != null) {
      title = cat.title;
      color = cat.catColor;
      txnList =
          Provider.of<Transactions>(context).getTransactionsByCategory(cat.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
      ),
      body: SafeArea(
        child: Container(
          child: (txnList.length <= 0)
              ? Center(child: Text('No Transactions Added'))
              : ListView(children: [
                  ...List<Widget>.generate(txnList.length, (i) {
                    return Card(
                      child: TxnListItem(txn: txnList[i]),
                      elevation: 1,
                    );
                  }).reversed,
                ]),
        ),
      ),
    );
  }
}
