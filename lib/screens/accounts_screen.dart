import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/database_provider.dart';
import '../providers/accounts.dart';
import '../models/account.dart';
import '../screens/edit_account_screen.dart';
import '../providers/transactions.dart';
import '../screens/display_transactions_page.dart';

class AccountsScreen extends StatelessWidget {
  static const routeName = '/accounts';
  List<Account> assAccList;
  List<Account> liaAccList;

  Future<void> _refreshAccounts(BuildContext context) async {
    await DatabaseProvider.db.getAccounts().then((accList) =>
        Provider.of<Accounts>(context, listen: false).setAccounts(accList));
    assAccList = Provider.of<Accounts>(context, listen: false)
        .filterAccByType(Account.ACCTYPES[0]);
    liaAccList = Provider.of<Accounts>(context, listen: false)
        .filterAccByType(Account.ACCTYPES[1]);
  }

  ListTile accListTile(Account accData, BuildContext ctx) {
    double balanceUpdates =
        Provider.of<Transactions>(ctx).getAccountBalance(accData.id);
    return ListTile(
      title: Text(accData.title),
      trailing: Text(
        '${(accData.balance + balanceUpdates).toStringAsFixed(2)}',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      leading: CircleAvatar(
        backgroundColor: accData.accColor,
      ),
      onLongPress: () {
        showDialog(
            context: ctx,
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text('Edit Account'),
              children: <Widget>[EditAccountScreen(accData)],
            )).then((_) => _refreshAccounts(ctx));
      },
      onTap: () => Navigator.of(ctx).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => DisplayTransactionsPage(acc: accData))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    List<Account> assAccList =
        Provider.of<Accounts>(context).filterAccByType(Account.ACCTYPES[0]);
    List<Account> liaAccList =
        Provider.of<Accounts>(context).filterAccByType(Account.ACCTYPES[1]);

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: (assAccList.length <= 0 && liaAccList.length <= 0)
                ? Center(child: Text('Please add Accounts'))
                : ListView(
                    children: [
                      assAccList.length <= 0
                          ? null
                          : ListTile(
                              title:
                                  Text(assAccList.length <= 0 ? '' : 'Assets'),
                            ),
                      ...List<Widget>.generate(assAccList.length, (i) {
                        return accListTile(assAccList[i], context);
                      }),
                      ListTile(
                        title:
                            Text(liaAccList.length <= 0 ? '' : 'Liabilities'),
                      ),
                      ...List<Widget>.generate(liaAccList.length, (i) {
                        return accListTile(liaAccList[i], context);
                      }),
                    ],
                  ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.grey,
              child: Text('Add New Account'),
              onPressed: () {
                showDialog(
                    context: context,
                    child: SimpleDialog(
                      title: Text('Add Account'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      children: <Widget>[EditAccountScreen()],
                    )).then((_) => _refreshAccounts(context));
              },
            ),
          ),
        ],
      ),
    );
  }
}
