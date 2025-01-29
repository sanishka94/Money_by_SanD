import 'package:flutter/material.dart';

import '../providers/database_provider.dart';

class Transaction {
  double id;
  String type;
  int fromId;
  String fromTitle;
  int toId;
  String toTitle;
  double amount;
  DateTime date;
  String notes;
  Color color;

  static const TXNTYPES = ['expense', 'income', 'transfer'];

  Transaction({
    @required this.id,
    @required this.type,
    @required this.fromId,
    @required this.fromTitle,
    @required this.toId,
    @required this.toTitle,
    @required this.amount,
    @required this.date,
    @required this.notes,
    @required this.color,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.TXN_ID: id,
      DatabaseProvider.TXN_TYPE: Transaction.TXNTYPES.indexOf(type),
      DatabaseProvider.TXN_FROM_ID: fromId,
      DatabaseProvider.TXN_FROM_TITLE: fromTitle,
      DatabaseProvider.TXN_TO_ID: toId,
      DatabaseProvider.TXN_TO_TITLE: toTitle,
      DatabaseProvider.TXN_AMOUNT: amount,
      DatabaseProvider.TXN_DATE: date.toIso8601String(),
      DatabaseProvider.TXN_NOTES: notes,
      DatabaseProvider.TXN_COLOR: DatabaseProvider.MYCOLORS.indexOf(color),
    };
    return map;
  }

  Transaction.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.TXN_ID];
    type = Transaction.TXNTYPES[map[DatabaseProvider.ACC_TYPE]];
    fromId = map[DatabaseProvider.TXN_FROM_ID];
    fromTitle = map[DatabaseProvider.TXN_FROM_TITLE];
    toId = map[DatabaseProvider.TXN_TO_ID];
    toTitle = map[DatabaseProvider.TXN_TO_TITLE];
    amount = map[DatabaseProvider.TXN_AMOUNT];
    date = DateTime.parse(map[DatabaseProvider.TXN_DATE]);
    notes = map[DatabaseProvider.TXN_NOTES];
    color = DatabaseProvider.MYCOLORS[map[DatabaseProvider.TXN_COLOR]];
  }

  @override
  String toString() {
    String strTransaction =
        'id: ${this.id}, type: ${this.type}, accountId: ${this.fromId}, '
        'account title: ${this.fromTitle}, to_cat/acc ID: ${this.toId}'
        'to_cat/acc title: ${this.toTitle}, \namount: ${this.amount}, '
        'date: ${this.date.toString()}, \nnotes: ${this.notes}'
        'color: ${this.color.toString()}';
    return strTransaction;
  }
}

// Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{
//       DatabaseProvider.TXN_ID: id,
//       DatabaseProvider.TXN_TYPE: Transaction.TXNTYPES.indexOf(type),
//       DatabaseProvider.TXN_ACCOUNT_ID: accountId,
//       DatabaseProvider.TXN_CATEGORY_ID: categoryId,
//       DatabaseProvider.TXN_SUBACCOUNT_ID: subAccountId,
//       DatabaseProvider.TXN_AMOUNT: amount,
//       DatabaseProvider.TXN_DATE: date.toIso8601String(),
//       DatabaseProvider.TXN_NOTES: notes,
//     };
//     return map;
//   }

//   Transaction.fromMap(Map<String, dynamic> map) {
//     id = map[DatabaseProvider.TXN_ID];
//     type = Transaction.TXNTYPES[map[DatabaseProvider.ACC_TYPE]];
//     accountId = map[DatabaseProvider.TXN_ACCOUNT_ID];
//     categoryId = map[DatabaseProvider.TXN_CATEGORY_ID];
//     subAccountId = map[DatabaseProvider.TXN_SUBACCOUNT_ID];
//     amount = map[DatabaseProvider.TXN_AMOUNT];
//     date = DateTime.parse(map[DatabaseProvider.TXN_DATE]);
//     notes = map[DatabaseProvider.TXN_NOTES];
//   }

//   @override
//   String toString() {
//     String strTransaction =
//         'id: ${this.id}, type: ${this.type}, accountId: ${this.accountId}, '
//         'categoryId: ${this.categoryId}, subAccountId: ${this.subAccountId}, '
//         '\namount: ${this.amount}, date: ${this.date.toString()}, '
//         '\nnotes: ${this.notes}';
//     return strTransaction;
//   }
