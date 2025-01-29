import 'package:flutter/material.dart';

import '../providers/database_provider.dart';
import '../models/transaction.dart';

class Transactions extends ChangeNotifier {
  List<Transaction> transactionList = [];

  void setTransactions(List<Transaction> transactions) {
    this.transactionList = transactions;
    notifyListeners();
  }

  void addTransaction(Transaction transaction) {
    DatabaseProvider.db
        .insertTransaction(transaction)
        .then((storedTransaction) {
      transactionList.add(storedTransaction);
    });
    notifyListeners();
  }

  void deleteTransaction(double id) {
    DatabaseProvider.db.deleteTransaction(id).then((_) {
      transactionList.removeWhere((txn) => txn.id == id);
    });
    notifyListeners();
  }

  void updateTransaction(Transaction transaction) {
    DatabaseProvider.db.updateTransaction(transaction).then((_) {
      int index = transactionList.indexWhere((txn) => txn.id == transaction.id);
      transactionList[index] = transaction;
    });
    notifyListeners();
  }

  double getAccountBalance(int accId) {
    double balance = 0;
    for (Transaction txn in transactionList) {
      if (txn.type == Transaction.TXNTYPES[2] && txn.toId == accId) {
        balance += txn.amount;
      }
      if (txn.fromId == accId) {
        if (txn.type == Transaction.TXNTYPES[1]) {
          balance += txn.amount;
        } else {
          balance -= txn.amount;
        }
      }
    }
    return balance;
  }

  double getCategoryBalance(int catId) {
    double balance = 0;
    for (Transaction txn in transactionList) {
      if (txn.toId == catId) {
        balance += txn.amount;
      }
    }
    return balance;
  }

  List<Transaction> getTransactionsByAccount(int accId) {
    return transactionList
        .where((txn) =>
            (txn.fromId == accId) ||
            (txn.toId == accId && txn.type == Transaction.TXNTYPES[2]))
        .toList();
  }

  List<Transaction> getTransactionsByCategory(int catId) {
    return transactionList
        .where(
            (txn) => txn.toId == catId && txn.type != Transaction.TXNTYPES[2])
        .toList();
  }

  List<Transaction> orderedList() {
    List<Transaction> sortedList = List<Transaction>.from(transactionList);
    sortedList.sort((a, b) => a.date.compareTo(b.date));
    return sortedList.reversed.toList();
  }

  List<Transaction> getTransactionsByDate(DateTime date) {
    return transactionList
        .where((txn) =>
            txn.date.year == date.year &&
            txn.date.month == date.month &&
            txn.date.day == date.day)
        .toList()
        .reversed
        .toList();
  }
}
