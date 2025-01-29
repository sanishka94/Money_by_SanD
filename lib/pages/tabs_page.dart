import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../screens/budgets_screen.dart';
import '../screens/accounts_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/edit_transaction_screen.dart';

import '../models/transaction.dart';
import '../models/account.dart';
import '../models/category.dart';

import '../providers/transactions.dart';
import '../providers/accounts.dart';
import '../providers/categories.dart';
import '../providers/database_provider.dart';
import '../providers/settings.dart';

class TabsPage extends StatefulWidget {
  static const ruteName = '/tabs';
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  List<Transaction> txnList;
  List<Account> accList;
  List<Category> expCatList;
  List<Category> incCatList;

  int _selectedPageIndex = 0;
  List<Map<String, Object>> _screens = [
    {
      'screen': HomeScreen(),
      'title': 'Home',
      'icon': Icon(Icons.home),
    },
    {
      'screen': AccountsScreen(),
      'title': 'Accounts',
      'icon': Icon(Icons.account_balance),
    },
    {
      'screen': BudgetsScreen(),
      'title': 'Budget',
      'icon': Icon(Icons.pie_chart),
    },
    {
      'screen': AnalyticsScreen(),
      'title': 'Analytics',
      'icon': Icon(Icons.multiline_chart),
    },
  ];

  @override
  void initState() {
    // try {
    //   DatabaseProvider.db.getTransactions().then((txnList) =>
    //       Provider.of<Transactions>(context, listen: false)
    //           .setTransactions(txnList));
    //   DatabaseProvider.db.getAccounts().then((accList) =>
    //       Provider.of<Accounts>(context, listen: false).setAccounts(accList));
    //   DatabaseProvider.db.getCategories().then((catList) =>
    //       Provider.of<Categories>(context, listen: false)
    //           .setCategories(catList));
    //   DatabaseProvider.db.getSettings().then((setList) =>
    //       Provider.of<Settings>(context, listen: false).setSettings(setList));
    // } on Exception {}

    super.initState();
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    txnList = Provider.of<Transactions>(context).transactionList;
    accList = Provider.of<Accounts>(context).accountList;
    incCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[0]);
    expCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[1]);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_screens[_selectedPageIndex]['title']),
      // ),
      body: SafeArea(
        child: _screens[_selectedPageIndex]['screen'],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _selectScreen,
        currentIndex: _selectedPageIndex,
        items: List<BottomNavigationBarItem>.generate(_screens.length, (index) {
          return BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: _screens[index]['icon'],
            title: Text(_screens[index]['title']),
          );
        }),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     showModalBottomSheet<dynamic>(
      //       isScrollControlled: true,
      //       context: context,
      //       builder: (ctx) => EditTransactionScreen(
      //         accountList: accList,
      //         expCategoryList: expCatList,
      //         incCategoryList: incCatList,
      //       ),
      //     ).then((value) {
      //       setState(() {
      //         txnList = Provider.of<Transactions>(context, listen: false)
      //             .transactionList;
      //       });
      //     });
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
