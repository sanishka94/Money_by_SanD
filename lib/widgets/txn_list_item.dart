import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TxnListItem extends StatelessWidget {
  Transaction txn;

  TxnListItem({@required this.txn});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: txn.color,
      ),
      title: Text(txn.toTitle),
      subtitle: Text(txn.fromTitle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            txn.amount.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('${DateFormat.yMd().format(txn.date)}'),
        ],
      ),
    );
  }
}
