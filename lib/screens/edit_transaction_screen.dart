import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/transactions.dart';

import '../models/transaction.dart';
import '../models/account.dart';
import '../models/category.dart';

class EditTransactionScreen extends StatefulWidget {
  static const routeName = 'edit-transaction';
  Transaction editTransaction;
  List<Account> accountList;
  List<Category> expCategoryList;
  List<Category> incCategoryList;

  EditTransactionScreen(
      {@required this.accountList,
      @required this.expCategoryList,
      @required this.incCategoryList,
      this.editTransaction});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final formKey = GlobalKey<FormState>();
  Transaction newTransaction;
  bool _txnAllowed = false;
  List<Account> accList;
  int _mainAccIndex;
  int _subAccIndex;
  int _catIndex;
  List<Category> expCatList;
  List<Category> incCatList;
  int _selectedTypeIndex;
  DateTime _selectedDate;

  Widget toggleSwitch() {
    return Container(
      child: Row(
        children: <Widget>[
          ChoiceChip(
            label: Icon(Icons.remove),
            elevation: 1,
            backgroundColor: Colors.white,
            selectedColor: Colors.red[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            selected: _selectedTypeIndex == 0,
            onSelected: (bool sel) {
              setState(() {
                _selectedTypeIndex = sel ? 0 : _selectedTypeIndex;
                _catIndex = 0;
              });
            },
          ),
          ChoiceChip(
              label: Icon(Icons.add),
              elevation: 1,
              backgroundColor: Colors.white,
              selectedColor: Colors.green[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              selected: _selectedTypeIndex == 1,
              onSelected: (bool sel) {
                setState(() {
                  _selectedTypeIndex = sel ? 1 : _selectedTypeIndex;
                  _catIndex = 0;
                });
              }),
          ChoiceChip(
              label: Icon(Icons.compare_arrows),
              elevation: 1,
              backgroundColor: Colors.white,
              selectedColor: Colors.yellow[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              selected: _selectedTypeIndex == 2,
              onSelected: (bool sel) {
                setState(() {
                  _selectedTypeIndex = sel ? 2 : _selectedTypeIndex;
                  _catIndex = 0;
                });
              }),
        ],
      ),
    );
  }

  Widget accDropDownMenu(List<Account> list, bool isMain) {
    return DropdownButton<int>(
      value: isMain ? _mainAccIndex : _subAccIndex,
      onChanged: (index) {
        setState(() {
          isMain ? _mainAccIndex = index : _subAccIndex = index;
        });
      },
      items: List<int>.generate(list.length, (i) => i)
          .map<DropdownMenuItem<int>>((index) => DropdownMenuItem(
                value: index,
                child: Text(list[index].title),
              ))
          .toList(),
    );
  }

  Widget catDropDownMenu(List<Category> list) {
    return DropdownButton<int>(
      value: _catIndex,
      onChanged: (index) {
        setState(() {
          _catIndex = index;
        });
      },
      items: List<int>.generate(list.length, (i) => i)
          .map<DropdownMenuItem<int>>((index) => DropdownMenuItem(
                value: index,
                child: Text(list[index].title),
              ))
          .toList(),
    );
  }

  void presentDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDatePickerMode: DatePickerMode.year,
            initialDate: widget.editTransaction == null
                ? DateTime.now()
                : widget.editTransaction.date,
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return;
    }
    newTransaction.type = Transaction.TXNTYPES[_selectedTypeIndex];
    newTransaction.fromId = accList[_mainAccIndex].id;
    newTransaction.fromTitle = accList[_mainAccIndex].title;
    if (_selectedTypeIndex == 0) {
      newTransaction.toId = expCatList[_catIndex].id;
      newTransaction.toTitle = expCatList[_catIndex].title;
      newTransaction.color = expCatList[_catIndex].catColor;
    } else if (_selectedTypeIndex == 1) {
      newTransaction.toId = incCatList[_catIndex].id;
      newTransaction.toTitle = incCatList[_catIndex].title;
      newTransaction.color = incCatList[_catIndex].catColor;
    } else if (_selectedTypeIndex == 2) {
      newTransaction.toId = accList[_subAccIndex].id;
      newTransaction.toTitle = accList[_subAccIndex].title;
      newTransaction.color = Colors.grey;
    }
    newTransaction.date = _selectedDate;

    if (widget.editTransaction == null) {
      newTransaction.id =
          double.parse('${DateTime.now().millisecondsSinceEpoch}');
      Provider.of<Transactions>(context, listen: false)
          .addTransaction(newTransaction);
    } else {
      newTransaction.id = widget.editTransaction.id;
      Provider.of<Transactions>(context, listen: false)
          .updateTransaction(newTransaction);
    }
    Navigator.of(formKey.currentContext).pop();
  }

  void _delete() {
    Provider.of<Transactions>(context, listen: false)
        .deleteTransaction(widget.editTransaction.id);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    accList = widget.accountList;
    expCatList = widget.expCategoryList;
    incCatList = widget.incCategoryList;
    _mainAccIndex = 0;
    _subAccIndex = 1;
    _catIndex = 0;
    if (widget.editTransaction == null) {
      _selectedTypeIndex = 0;
      _selectedDate = DateTime.now();
    } else {
      _selectedTypeIndex = Transaction.TXNTYPES
          .indexWhere((str) => str == widget.editTransaction.type);
      _selectedDate = widget.editTransaction.date;
      _mainAccIndex =
          accList.indexWhere((acc) => acc.id == widget.editTransaction.fromId);
      if (widget.editTransaction.type == Transaction.TXNTYPES[0]) {
        _catIndex = expCatList
            .indexWhere((cat) => cat.id == widget.editTransaction.toId);
      } else if (widget.editTransaction.type == Transaction.TXNTYPES[1]) {
        _catIndex = incCatList
            .indexWhere((cat) => cat.id == widget.editTransaction.toId);
      } else if (widget.editTransaction.type == Transaction.TXNTYPES[2]) {
        _subAccIndex =
            accList.indexWhere((acc) => acc.id == widget.editTransaction.toId);
      }
    }
    newTransaction = Transaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 18;
    _txnAllowed = (accList.length >= 2 &&
            expCatList.length >= 1 &&
            incCatList.length >= 1)
        ? true
        : false;
    return (!_txnAllowed)
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 200,
            child: Center(
              child: Text(
                  'Atleast 2 accounts and one category each for expense and income is required'),
            ),
          )
        : Container(
            padding: EdgeInsets.all(30),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          toggleSwitch(),
                          Container(
                            height: 50,
                            width: 70,
                            margin: const EdgeInsets.all(14.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 20),
                              initialValue: widget.editTransaction == null
                                  ? ''
                                  : '${widget.editTransaction.amount}',
                              validator: (amount) {
                                if (amount.isEmpty) {
                                  return 'An amount is required';
                                }
                                return null;
                              },
                              onSaved: (amount) =>
                                  newTransaction.amount = double.parse(amount),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Account',
                            style: TextStyle(fontSize: _labelFontSize),
                          ),
                          accDropDownMenu(accList, true),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    _selectedTypeIndex <= 1
                        ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Category',
                                    style: TextStyle(fontSize: _labelFontSize)),
                                _selectedTypeIndex == 0
                                    ? catDropDownMenu(expCatList)
                                    : catDropDownMenu(incCatList),
                              ],
                            ),
                          )
                        : Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Secondary Account',
                                    style: TextStyle(fontSize: _labelFontSize)),
                                accDropDownMenu(accList, false),
                              ],
                            ),
                          ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${DateFormat.yMd().format(_selectedDate)}',
                              style: TextStyle(fontSize: _labelFontSize)),
                          Theme(
                            data: ThemeData(
                              primaryColor: Colors.purple[600],
                              accentColor: Colors.green,
                              backgroundColor: Colors.red,
                              bannerTheme: MaterialBannerThemeData(
                                  backgroundColor: Colors.yellow),
                              cardColor: Colors.orange,
                              dialogBackgroundColor: Colors.red,
                              splashColor: Colors.grey,
                              highlightColor: Colors.black,
                            ),
                            child: FlatButton(
                              child: Text('Choose date'),
                              onPressed: () => showDatePicker(
                                      context: context,
                                      initialDate:
                                          widget.editTransaction == null
                                              ? DateTime.now()
                                              : widget.editTransaction.date,
                                      firstDate: DateTime(2019),
                                      lastDate: DateTime.now())
                                  .then((date) {
                                if (date == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedDate = date;
                                });
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Notes',
                            labelStyle: TextStyle(fontSize: _labelFontSize)),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        initialValue: widget.editTransaction == null
                            ? ''
                            : '${widget.editTransaction.notes}',
                        onSaved: (notes) => newTransaction.notes = notes,
                      ),
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
                          child: widget.editTransaction == null
                              ? Container(
                                  child: Text('Add'),
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                )
                              : Container(
                                  child: Text('Update'),
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                ),
                          onPressed: () {
                            if (_selectedTypeIndex == 2) {
                              if (_mainAccIndex == _subAccIndex) {
                                showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    title: Text(
                                        "\'Account\' cannot be the same as \'Secondary Account\'"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
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
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          )
                                        ],
                                      ));
                                }
                              }
                            } else {
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
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        )
                                      ],
                                    ));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    widget.editTransaction == null
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
                                title: Text('Delete Transaction?'),
                                content: Text(
                                    'Are you sure you want to delete this transaction?'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('No'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
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
                                                      Navigator.of(context)
                                                          .pop(),
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
            ));
  }
}
