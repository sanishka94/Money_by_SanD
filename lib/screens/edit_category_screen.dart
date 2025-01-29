import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../providers/database_provider.dart';
import '../models/category.dart';
import '../providers/categories.dart';
import '../models/transaction.dart';
import '../providers/transactions.dart';

class EditCategoryScreen extends StatefulWidget {
  static const routeName = 'edit-category';
  Category editCategory;

  EditCategoryScreen([this.editCategory]);
  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final formKey = GlobalKey<FormState>();
  Color _selectedColor;
  String _selectedType;
  Category newCategory;
  List<Transaction> txnList = [];

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (widget.editCategory == null) {
        Provider.of<Categories>(context, listen: false)
            .addCategory(newCategory);
      } else {
        newCategory.id = widget.editCategory.id;
        Provider.of<Categories>(context, listen: false)
            .updateCategory(newCategory);
      }

      Navigator.of(formKey.currentContext).pop();
    }
  }

  void _delete() {
    Provider.of<Categories>(context, listen: false)
        .deleteCategory(widget.editCategory.id);
    txnList = Provider.of<Transactions>(context, listen: false).transactionList;
    if (txnList != null) {
      for (Transaction txn
          in txnList.where((txn) => txn.toId == widget.editCategory.id)) {
        Provider.of<Transactions>(context, listen: false)
            .deleteTransaction(txn.id);
      }
    }
    Navigator.of(context).pop();
  }

  ChoiceChip twoChoicesCat(String title, String str1, String str2) {
    return ChoiceChip(
      labelPadding: EdgeInsets.symmetric(horizontal: 25),
      backgroundColor: Colors.white,
      selectedColor: Theme.of(context).primaryColor,
      label: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _selectedType == str1
                ? Colors.white
                : Theme.of(context).primaryColor),
      ),
      selected: _selectedType == str1,
      onSelected: (bool sel) {
        setState(() {
          _selectedType = sel ? str1 : str2;
          newCategory.catType = _selectedType;
        });
      },
    );
  }

  @override
  void initState() {
    if (widget.editCategory != null) {
      _selectedColor = widget.editCategory.catColor;
      _selectedType = widget.editCategory.catType;
    } else {
      _selectedColor = DatabaseProvider.MYCOLORS[0];
      _selectedType = Category.CATTYPES[1];
    }
    newCategory =
        new Category(catType: _selectedType, catColor: _selectedColor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                twoChoicesCat(
                    'Expenses', Category.CATTYPES[1], Category.CATTYPES[0]),
                twoChoicesCat(
                    'Incomes', Category.CATTYPES[0], Category.CATTYPES[1]),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              initialValue:
                  widget.editCategory == null ? '' : widget.editCategory.title,
              validator: (title) {
                if (title.isEmpty) {
                  return 'Title required';
                }
                return null;
              },
              onSaved: (title) => newCategory.title = title,
            ),
            // TextFormField(
            //   decoration: InputDecoration(labelText: 'Budget'),
            //   keyboardType: TextInputType.number,
            //   initialValue: widget.editCategory == null
            //       ? ''
            //       : '${widget.editCategory.budget}',
            //   onSaved: (budget) => newCategory.budget =
            //       budget.isEmpty ? 0 : double.parse(budget),
            // ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ActionChip(
                  labelPadding: EdgeInsets.symmetric(horizontal: 50),
                  backgroundColor: _selectedColor,
                  label: Text(
                    'Color',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    child: AlertDialog(
                      content: MaterialColorPicker(
                        shrinkWrap: true,
                        allowShades: false,
                        colors: DatabaseProvider.MYCOLORS,
                        selectedColor: _selectedColor,
                        onMainColorChange: (selectedColor) {
                          setState(() {
                            _selectedColor = selectedColor;
                            newCategory.catColor = _selectedColor;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textColor: Colors.white,
                  child: widget.editCategory == null
                      ? Text('Add')
                      : Text('Update'),
                  onPressed: () {
                    try {
                      _submit();
                    } on Exception {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text('A small problem'),
                            content: Text(
                                'Unable to save at the moment, please try again'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          ));
                    }
                  },
                ),
              ],
            ),
            widget.editCategory == null
                ? SizedBox(
                    height: 1,
                  )
                : FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text('Delete Category?'),
                        content: Text(
                            'All Transactions associated with this category will be deleted,'
                            ' do you still want to continue?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              try {
                                _delete();
                              } on Exception {
                                showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: Text('A small problem'),
                                      content: Text(
                                          'Unable to delete at the moment, please try again'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Ok'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        )
                                      ],
                                    ));
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
