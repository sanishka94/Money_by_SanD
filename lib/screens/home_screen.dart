import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/database_provider.dart';
import '../widgets/overview.dart';
import '../models/transaction.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../providers/accounts.dart';
import '../providers/categories.dart';
import '../providers/transactions.dart';
import '../widgets/txn_list_item.dart';
import '../screens/edit_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  MediaQueryData queryData;

  List<Transaction> txnList;

  List<Account> accList;

  List<Category> expCatList;

  List<Category> incCatList;

  double spaceAvailable;

  List<double> spaceAllocation;

  bool isFiltered;

  Future<void> _refreshTransactions(BuildContext context) async {
    await DatabaseProvider.db.getTransactions().then((txnList) =>
        Provider.of<Transactions>(context, listen: false)
            .setTransactions(txnList));
    txnList = Provider.of<Transactions>(context, listen: false).orderedList();
  }

  @override
  Widget build(BuildContext context) {
    txnList = Provider.of<Transactions>(context).orderedList();
    accList = Provider.of<Accounts>(context).accountList;
    expCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[1]);
    incCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[0]);

    queryData = MediaQuery.of(context);
    spaceAvailable = queryData.size.height - 85 - queryData.padding.top;
    spaceAllocation = [0.25, 0.68, 0.07];

    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: spaceAvailable * spaceAllocation[0],
              child: Overview(),
            ),
            Container(
              height: spaceAvailable * spaceAllocation[1],
              child: Consumer<Transactions>(
                child: Center(
                  child: Text('No Transactions added'),
                ),
                builder: (c, txn, ch) => txnList.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: txnList.length,
                        itemBuilder: (_, i) => GestureDetector(
                          child: TxnListItem(
                            txn: txnList[i],
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                child: SimpleDialog(
                                  title: Text('Edit Transaction'),
                                  children: <Widget>[
                                    EditTransactionScreen(
                                      accountList: accList,
                                      expCategoryList: expCatList,
                                      incCategoryList: incCatList,
                                      editTransaction: txnList[i],
                                    )
                                  ],
                                )).then((value) {
                              _refreshTransactions(context);
                            });
                          },
                        ),
                      ),
              ),
            ),
            Container(
              height: spaceAvailable * spaceAllocation[2],
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showModalBottomSheet<dynamic>(
                    isScrollControlled: true,
                    context: context,
                    builder: (ctx) => EditTransactionScreen(
                      accountList: accList,
                      expCategoryList: expCatList,
                      incCategoryList: incCatList,
                    ),
                  ).then((value) {
                    _refreshTransactions(context);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
