import 'package:flutter/material.dart';

import '../providers/database_provider.dart';

class Category {
  int id;
  String title;
  String catType;
  // double budget;
  Color catColor;

  static const CATTYPES = ['incomes', 'expenses'];

  Category(
      {@required this.id,
      @required this.title,
      @required this.catType,
      // @required this.budget,
      @required this.catColor});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.CAT_TITLE: title,
      DatabaseProvider.CAT_TYPE: Category.CATTYPES.indexOf(catType),
      // DatabaseProvider.CAT_BUDGET: budget,
      DatabaseProvider.CAT_COLOR: DatabaseProvider.MYCOLORS.indexOf(catColor),
    };
    if (id != null) {
      map[DatabaseProvider.CAT_ID] = id;
    }
    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.CAT_ID];
    title = map[DatabaseProvider.CAT_TITLE];
    catType = Category.CATTYPES[map[DatabaseProvider.CAT_TYPE]];
    // budget = map[DatabaseProvider.CAT_BUDGET];
    catColor = DatabaseProvider.MYCOLORS[map[DatabaseProvider.CAT_COLOR]];
  }
}
