import 'package:flutter/material.dart';

import 'account.dart';
import 'category.dart';
import 'transaction.dart';

class Analytics {
  List<Transaction> txnList;
  List<Account> accList;
  List<Category> catList;

  Analytics(
      {@required this.txnList, @required this.accList, @required this.catList});

  double expensesByCategory(int id) {
    double expenses = 0;
    for (Transaction txn in txnList.where((txn) => txn.toId == id)) {
      if (txn.type == Transaction.TXNTYPES[0]) {
        expenses += txn.amount;
      }
    }
    return expenses;
  }

  double incomeByCategory(int id) {
    double incomes = 0;
    for (Transaction txn in txnList.where((txn) => txn.toId == id)) {
      if (txn.type == Transaction.TXNTYPES[1]) {
        incomes += txn.amount;
      }
    }
    return incomes;
  }

  double get networth {
    double net = 0;

    for (Account acc
        in accList.where((acc) => acc.accType == Account.ACCTYPES[0])) {
      net += acc.balance + getAccountUpdates(acc.id);
    }
    return net;
  }

  double get netLiabilities {
    double net = 0;
    for (Account acc
        in accList.where((acc) => acc.accType == Account.ACCTYPES[1])) {
      net += getAccountUpdates(acc.id);
    }
    return net;
  }

  double expensesByAccount(int id) {
    double expenses = 0;
    for (Transaction txn
        in txnList.where((txn) => txn.fromId == id || txn.toId == id)) {
      if (txn.type == Transaction.TXNTYPES[0]) {
        expenses += txn.amount;
      } else if (txn.type == Transaction.TXNTYPES[2]) {
        expenses -= txn.amount;
      }
    }
    return expenses;
  }

  List<Transaction> dailyTransactions(DateTime date) {
    return txnList
        .where((txn) =>
            txn.date.year == date.year &&
            txn.date.month == date.month &&
            txn.date.day == date.day)
        .toList();
  }

  List<Transaction> monthlyTransactions(DateTime date) {
    return txnList
        .where(
            (txn) => txn.date.year == date.year && txn.date.month == date.month)
        .toList();
  }

  List<Transaction> monthlyTransactionsExpenses(DateTime date) {
    return txnList
        .where((txn) =>
            txn.date.year == date.year &&
            txn.date.month == date.month &&
            txn.type == Transaction.TXNTYPES[0])
        .toList();
  }

  List<Transaction> yearlyTransactions(DateTime date) {
    return txnList.where((txn) => txn.date.year == date.year).toList();
  }

  double expensesByDay(DateTime date) {
    double expenses = 0;
    for (Transaction txn in dailyTransactions(date)) {
      if (txn.type == Transaction.TXNTYPES[0]) {
        expenses += txn.amount;
      }
    }
    return expenses;
  }

  double expensesByMonth(DateTime date) {
    double expenses = 0;
    for (Transaction txn in monthlyTransactions(date)) {
      if (txn.type == Transaction.TXNTYPES[0]) {
        expenses += txn.amount;
      }
    }
    return expenses;
  }

  double expensesByYear(DateTime date) {
    double expenses = 0;
    for (Transaction txn in yearlyTransactions(date)) {
      if (txn.type == Transaction.TXNTYPES[0]) {
        expenses += txn.amount;
      }
    }
    return expenses;
  }

  double outTransfers(int id) {
    double transfers = 0;
    for (Transaction txn in txnList.where((txn) => txn.fromId == id)) {
      if (txn.type == Transaction.TXNTYPES[2]) {
        transfers += txn.amount;
      }
    }
    return transfers;
  }

  double inTransfers(int id) {
    double transfers = 0;
    for (Transaction txn in txnList.where((txn) => txn.toId == id)) {
      if (txn.type == Transaction.TXNTYPES[2]) {
        transfers += txn.amount;
      }
    }
    return transfers;
  }

  double getAccountUpdates(int accId) {
    double updates = 0;
    for (Transaction txn in txnList) {
      if (txn.type == Transaction.TXNTYPES[2]) {
        if (txn.toId == accId) {
          updates += txn.amount;
        } else if (txn.fromId == accId) {
          updates -= txn.amount;
        }
      } else if (txn.fromId == accId) {
        if (txn.type == Transaction.TXNTYPES[1]) {
          updates += txn.amount;
        } else if (txn.type == Transaction.TXNTYPES[0]) {
          updates -= txn.amount;
        }
      }
    }
    return updates;
  }

  // double getAccountBalances(int id) {
  //   double totExpenses = expensesByAccount(id);
  //   double inwards = inTransfers(id);
  //   double outwards = outTransfers(id);
  //   return accList.firstWhere((acc) => acc.id == id).balance -
  //       totExpenses +
  //       inwards -
  //       outwards;
  // }

  // double getCategoryBalances(int id) {
  //   return catList.firstWhere((cat) => cat.id == id).budget -
  //       expensesByCategory(id);
  // }
}
