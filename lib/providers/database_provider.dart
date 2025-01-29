import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/transaction.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../models/setting.dart';

class DatabaseProvider {
  static const String TABLE_TRANSACTIONS = 'transactions';
  static const String TXN_ID = 'id';
  static const String TXN_TYPE = 'type';
  static const String TXN_FROM_ID = 'fromId';
  static const String TXN_FROM_TITLE = 'fromTitle';
  static const String TXN_TO_ID = 'toId';
  static const String TXN_TO_TITLE = 'toTitle';
  static const String TXN_AMOUNT = 'amount';
  static const String TXN_DATE = 'date';
  static const String TXN_NOTES = 'notes';
  static const String TXN_COLOR = 'color';

  static const String TABLE_ACCOUNTS = 'accounts';
  static const String ACC_ID = 'id';
  static const String ACC_TITLE = 'title';
  static const String ACC_TYPE = 'type';
  static const String ACC_BALANCE = 'balance';
  static const String ACC_COLOR = 'color';

  static const String TABLE_CATEGORIES = 'categories';
  static const String CAT_ID = 'id';
  static const String CAT_TITLE = 'title';
  static const String CAT_TYPE = 'type';
  // static const String CAT_BUDGET = 'budget';
  static const String CAT_COLOR = 'color';

  static const String TABLE_SETTINGS = 'setts';
  static const String SET_ID = 'id';
  static const String SET_TYPE = 'type';
  static const String SET_VALUE = 'amount';

  static const MYCOLORS = [
    Colors.yellow,
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.brown,
    Colors.green,
    Colors.grey,
    Colors.cyan,
    Colors.pink,
    Colors.orange
  ];

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  sql.Database _database;

  Future<sql.Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();

    return _database;
  }

  Future<sql.Database> createDatabase() async {
    String dbPath = await sql.getDatabasesPath();

    return await sql.openDatabase(join(dbPath, 'money.db'), version: 2,
        onCreate: (sql.Database database, int version) async {
      await database.execute('CREATE TABLE $TABLE_TRANSACTIONS ('
          '$TXN_ID REAL PRIMARY KEY, $TXN_TYPE INTEGER, $TXN_FROM_ID INTEGER,'
          '$TXN_FROM_TITLE TEXT, $TXN_TO_ID INTEGER, $TXN_TO_TITLE TEXT,'
          '$TXN_AMOUNT REAL, $TXN_DATE TEXT, $TXN_NOTES TEXT,'
          '$TXN_COLOR INTEGER)');
      await database.execute('CREATE TABLE $TABLE_ACCOUNTS ('
          '$ACC_ID INTEGER PRIMARY KEY, $ACC_TITLE TEXT, $ACC_TYPE INTEGER,'
          '$ACC_BALANCE REAL, $ACC_COLOR INTEGER)');
      await database.execute('CREATE TABLE $TABLE_CATEGORIES ('
          '$CAT_ID INTEGER PRIMARY KEY, $CAT_TITLE TEXT, $CAT_TYPE INTEGER,'
          '$CAT_COLOR INTEGER)');
      await database.execute('CREATE TABLE $TABLE_SETTINGS ('
          '$SET_ID INTEGER PRIMARY KEY, $SET_TYPE TEXT, $SET_VALUE REAL)');
    });
  }

// --- Start --- Transactions --- Start --- //
  Future<List<Transaction>> getTransactions() async {
    final db = await database;

    var transactions = await db.query(
      TABLE_TRANSACTIONS,
      columns: [
        TXN_ID,
        TXN_TYPE,
        TXN_FROM_ID,
        TXN_FROM_TITLE,
        TXN_TO_ID,
        TXN_TO_TITLE,
        TXN_AMOUNT,
        TXN_DATE,
        TXN_NOTES,
        TXN_COLOR,
      ],
    );
    List<Transaction> transactionList = List<Transaction>();

    transactions.forEach((currentTransaction) {
      Transaction transaction = Transaction.fromMap(currentTransaction);
      transactionList.add(transaction);
    });
    return transactionList;
  }

  Future<Transaction> insertTransaction(Transaction transaction) async {
    final db = await database;
    int res = await db.insert(TABLE_TRANSACTIONS, transaction.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return transaction;
  }

  Future<int> deleteTransaction(double id) async {
    final db = await database;
    return await db
        .delete(TABLE_TRANSACTIONS, where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateTransaction(Transaction transaction) async {
    final db = await database;

    return await db.update(TABLE_TRANSACTIONS, transaction.toMap(),
        where: "id = ?",
        whereArgs: [transaction.id],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
// ---- End ---- Transactions --- End --- //

// --- Start --- Accounts --- Start --- //
  Future<List<Account>> getAccounts() async {
    final db = await database;

    var accounts = await db.query(
      TABLE_ACCOUNTS,
      columns: [ACC_ID, ACC_TITLE, ACC_TYPE, ACC_BALANCE, ACC_COLOR],
    );
    List<Account> accountList = List<Account>();

    accounts.forEach((currentAccount) {
      Account account = Account.fromMap(currentAccount);
      accountList.add(account);
    });
    return accountList;
  }

  Future<Account> insertAccount(Account account) async {
    final db = await database;
    account.id = await db.insert(TABLE_ACCOUNTS, account.toMap());
    return account;
  }

  Future<int> deleteAccount(int id) async {
    final db = await database;

    return await db.delete(TABLE_ACCOUNTS, where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateAccount(Account account) async {
    final db = await database;

    return await db.update(TABLE_ACCOUNTS, account.toMap(),
        where: "id = ?",
        whereArgs: [account.id],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
// ---- End ---- Accounts --- End --- //

// --- Start --- Category --- Start --- //
  Future<List<Category>> getCategories() async {
    final db = await database;

    var categories = await db.query(
      TABLE_CATEGORIES,
      columns: [CAT_ID, CAT_TITLE, CAT_TYPE, CAT_COLOR],
    );
    List<Category> categoryList = List<Category>();

    categories.forEach((currentCategory) {
      Category category = Category.fromMap(currentCategory);
      categoryList.add(category);
    });
    return categoryList;
  }

  Future<Category> insertCategory(Category category) async {
    final db = await database;
    category.id = await db.insert(TABLE_CATEGORIES, category.toMap());
    return category;
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;

    return await db.delete(TABLE_CATEGORIES, where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;

    return await db.update(
      TABLE_CATEGORIES,
      category.toMap(),
      where: "id = ?",
      whereArgs: [category.id],
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }
// --- End --- Category --- End --- //

// --- Start --- Settings --- Start --- //
  Future<List<Setting>> getSettings() async {
    final db = await database;

    var settings = await db.query(
      TABLE_SETTINGS,
      columns: [SET_ID, SET_TYPE, SET_VALUE],
    );
    List<Setting> settingList = List<Setting>();

    settings.forEach((currentSetting) {
      Setting setting = Setting.fromMap(currentSetting);
      settingList.add(setting);
    });
    return settingList;
  }

  Future<Setting> insertSetting(Setting sett) async {
    final db = await database;
    int res = await db.insert(TABLE_SETTINGS, sett.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return sett;
  }

  Future<int> deleteSetting(int id) async {
    final db = await database;

    return await db.delete(TABLE_SETTINGS, where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateSetting(Setting setting) async {
    final db = await database;

    return await db.update(TABLE_SETTINGS, setting.toMap(),
        where: "id = ?",
        whereArgs: [setting.id],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
// ---- End ---- Settings --- End --- //
}
