import 'package:flutter/material.dart';

import '../providers/database_provider.dart';
import '../models/account.dart';

class Accounts extends ChangeNotifier {
  List<Account> accountList = [];

  Account getAccById(int id) {
    return accountList.firstWhere((acc) => acc.id == id);
  }

  List<Account> filterAccByType(String type) {
    return accountList.where((acc) => acc.accType == type).toList();
  }

  void setAccounts(List<Account> accounts) {
    this.accountList = accounts;
    notifyListeners();
  }

  void addAccount(Account account) {
    DatabaseProvider.db.insertAccount(account).then((storedAccount) {
      accountList.add(storedAccount);
    });
    notifyListeners();
  }

  void deleteAccount(int id) {
    DatabaseProvider.db.deleteAccount(id).then((_) {
      accountList.removeWhere((acc) => acc.id == id);
    });
    notifyListeners();
  }

  void updateAccount(Account account) {
    DatabaseProvider.db.updateAccount(account).then((_) {
      int index = accountList.indexWhere((acc) => acc.id == account.id);
      accountList[index] = account;
    });
    notifyListeners();
  }

  void updateBalance(int id, double amount, bool isMinus) {
    Account acc = accountList.firstWhere((acc) => acc.id == id);
    if (isMinus) {
      acc.balance = acc.balance - amount;
    } else {
      acc.balance = acc.balance + amount;
    }
    updateAccount(acc);
  }
}
