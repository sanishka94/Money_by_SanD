import 'package:flutter/material.dart';

import '../providers/database_provider.dart';

class Account {
  int id;
  String title;
  String accType;
  double balance;
  Color accColor;

  static const ACCTYPES = ['asset', 'liability'];

  Account(
      {@required this.id,
      @required this.title,
      @required this.accType,
      @required this.balance,
      @required this.accColor});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.ACC_TITLE: title,
      DatabaseProvider.ACC_TYPE: Account.ACCTYPES.indexOf(accType),
      DatabaseProvider.ACC_BALANCE: balance,
      DatabaseProvider.ACC_COLOR: DatabaseProvider.MYCOLORS.indexOf(accColor),
    };
    if (id != null) {
      map[DatabaseProvider.ACC_ID] = id;
    }
    return map;
  }

  Account.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.ACC_ID];
    title = map[DatabaseProvider.ACC_TITLE];
    accType = Account.ACCTYPES[map[DatabaseProvider.ACC_TYPE]];
    balance = map[DatabaseProvider.ACC_BALANCE];
    accColor = DatabaseProvider.MYCOLORS[map[DatabaseProvider.ACC_COLOR]];
  }
}
