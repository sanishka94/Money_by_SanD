import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/database_provider.dart';
import '../providers/categories.dart';
import '../models/category.dart';
import '../screens/edit_category_screen.dart';
import '../providers/transactions.dart';
import '../screens/display_transactions_page.dart';
import '../providers/settings.dart';
import '../models/setting.dart';
import '../widgets/monthly_budget.dart';

class BudgetsScreen extends StatelessWidget {
  static const routeName = '/budgets';
  List<Category> expCatList;
  List<Category> incCatList;
  List<Category> setList;
  Setting sett;

  Future<void> _refreshCategories(BuildContext context) async {
    await DatabaseProvider.db.getCategories().then((catList) =>
        Provider.of<Categories>(context, listen: false).setCategories(catList));
    incCatList = Provider.of<Categories>(context, listen: false)
        .filterCatByType(Category.CATTYPES[0]);

    expCatList = Provider.of<Categories>(context, listen: false)
        .filterCatByType(Category.CATTYPES[1]);
  }

  ListTile catListTile(Category catData, BuildContext ctx) {
    double balanceUpdates =
        Provider.of<Transactions>(ctx).getCategoryBalance(catData.id);
    return ListTile(
      title: Text(catData.title),
      leading: CircleAvatar(
        backgroundColor: catData.catColor,
      ),
      trailing: Container(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              '$balanceUpdates',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold),
            ),
            // Text(' / ${catData.budget}'),
          ],
        ),
      ),
      onLongPress: () {
        showDialog(
            context: ctx,
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text('Edit Category'),
              children: <Widget>[EditCategoryScreen(catData)],
            )).then((_) => _refreshCategories(ctx));
      },
      onTap: () => Navigator.of(ctx).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => DisplayTransactionsPage(cat: catData))),
    );
  }

  @override
  Widget build(BuildContext context) {
    double budget = 0;
    final id = ModalRoute.of(context).settings.arguments;
    List<Category> incCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[0]);
    List<Category> expCatList =
        Provider.of<Categories>(context).filterCatByType(Category.CATTYPES[1]);
    String strSettId = '${DateTime.now().year}${DateTime.now().month}';
    int settId = int.parse(strSettId);
    sett = Provider.of<Settings>(context).getSettById(settId);
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          MonthlyBudget(),
          Expanded(
            child: (incCatList.length <= 0 && expCatList.length <= 0)
                ? Center(child: Text('Please add Categories'))
                : ListView(
                    children: [
                      ListTile(
                        title: Text(expCatList.length <= 0 ? '' : 'Expenses'),
                      ),
                      ...List<Widget>.generate(expCatList.length, (i) {
                        return catListTile(expCatList[i], context);
                      }),
                      ListTile(
                        title: Text(incCatList.length <= 0 ? '' : 'Incomes'),
                      ),
                      ...List<Widget>.generate(incCatList.length, (i) {
                        return catListTile(incCatList[i], context);
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
              child: Text('Add New Category'),
              onPressed: () {
                showDialog(
                    context: context,
                    child: SimpleDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text('Add Category'),
                      children: <Widget>[EditCategoryScreen()],
                    )).then((_) => _refreshCategories(context));
              },
            ),
          ),
        ],
      ),
    );
  }
}
