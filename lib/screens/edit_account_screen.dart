import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../providers/database_provider.dart';
import '../models/account.dart';
import '../providers/accounts.dart';
import '../models/transaction.dart';
import '../providers/transactions.dart';

class EditAccountScreen extends StatefulWidget {
  static const routeName = 'edit-account';
  Account editAccount;

  EditAccountScreen([this.editAccount]);
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final formKey = GlobalKey<FormState>();
  Color _selectedColor;
  String _selectedType;
  Account newAccount;
  List<Transaction> txnList = [];

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (widget.editAccount == null) {
        Provider.of<Accounts>(context, listen: false).addAccount(newAccount);
      } else {
        newAccount.id = widget.editAccount.id;
        Provider.of<Accounts>(context, listen: false).updateAccount(newAccount);
      }

      Navigator.of(formKey.currentContext).pop();
    }
  }

  void _delete() {
    Provider.of<Accounts>(context, listen: false)
        .deleteAccount(widget.editAccount.id);
    txnList = Provider.of<Transactions>(context, listen: false).transactionList;
    if (txnList != null) {
      for (Transaction txn in txnList.where((txn) =>
          txn.fromId == widget.editAccount.id ||
          txn.toId == widget.editAccount.id)) {
        Provider.of<Transactions>(context, listen: false)
            .deleteTransaction(txn.id);
      }
    }
    Navigator.of(context).pop();
  }

  ChoiceChip twoChoicesAcc(String title, String str1, String str2) {
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
          newAccount.accType = _selectedType;
        });
      },
    );
  }

  @override
  void initState() {
    if (widget.editAccount != null) {
      _selectedColor = widget.editAccount.accColor;
      _selectedType = widget.editAccount.accType;
    } else {
      _selectedColor = DatabaseProvider.MYCOLORS[0];
      _selectedType = Account.ACCTYPES[0];
    }
    newAccount = new Account(accType: _selectedType, accColor: _selectedColor);
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
                twoChoicesAcc(
                    'Asset', Account.ACCTYPES[0], Account.ACCTYPES[1]),
                twoChoicesAcc(
                    'Liability', Account.ACCTYPES[1], Account.ACCTYPES[0])
              ],
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              initialValue:
                  widget.editAccount == null ? '' : widget.editAccount.title,
              validator: (title) {
                if (title.isEmpty) {
                  return 'Title required';
                }
                return null;
              },
              onSaved: (title) => newAccount.title = title,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Balance'),
              initialValue: widget.editAccount == null
                  ? ''
                  : '${widget.editAccount.balance}',
              keyboardType: TextInputType.number,
              onSaved: (balance) => newAccount.balance =
                  balance.isEmpty ? 0 : double.parse(balance),
            ),
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
                            newAccount.accColor = _selectedColor;
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: widget.editAccount == null
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
                    }),
              ],
            ),
            widget.editAccount == null
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
                          title: Text('Delete Account?'),
                          content: Text(
                              'All Transactions associated with this account will be deleted,'
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
                        )),
                  ),
          ],
        ),
      ),
    );
  }
}
