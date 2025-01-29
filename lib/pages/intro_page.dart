import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './tabs_page.dart';
import '../providers/transactions.dart';
import '../providers/accounts.dart';
import '../providers/categories.dart';
import '../providers/database_provider.dart';
import '../providers/settings.dart';
import '../widgets/logo.dart';

class IntroPage extends StatefulWidget {
  static const routeName = '/intro';

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool noError = true;

  Future<void> loadData(BuildContext ctx) async {
    DatabaseProvider.db.getTransactions().then((txnList) =>
        Provider.of<Transactions>(ctx, listen: false).setTransactions(txnList));
    DatabaseProvider.db.getAccounts().then((accList) =>
        Provider.of<Accounts>(ctx, listen: false).setAccounts(accList));
    DatabaseProvider.db.getCategories().then((catList) =>
        Provider.of<Categories>(ctx, listen: false).setCategories(catList));
    DatabaseProvider.db.getSettings().then((setList) =>
        Provider.of<Settings>(ctx, listen: false).setSettings(setList));
    // throw Error;
  }

  Future<void> _loadSession(BuildContext ctx) async {
    try {
      await loadData(ctx);
    } catch (e) {
      noError = false;
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('A small problem'),
            content: Text(
                'Unable to load your data at the moment, please try again'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => SystemNavigator.pop(),
              )
            ],
          ));
    }
    if (noError) {
      await Future.delayed(Duration(seconds: 2));
    }
  }

  Future<void> _loadSessions(BuildContext ctx) async {
    await loadData(ctx).catchError((e) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('A small problem'),
            content: Text(
                'Unable to load your data at the moment, please try again'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => SystemNavigator.pop(),
              )
            ],
          ));
    }).then((value) {
      Future.delayed(Duration(seconds: 2));
    });
  }

  void startApp() {
    Navigator.of(context).pushReplacementNamed(TabsPage.ruteName);
  }

  @override
  void initState() {
    _loadSession(context).then((value) {
      if (noError) {
        startApp();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.tealAccent[400], Colors.purpleAccent[400]])),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Money',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Sanishka D. Jayasena',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Logo(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
