import 'package:flutter/material.dart';

import '../providers/database_provider.dart';
import '../models/category.dart';

class Categories extends ChangeNotifier {
  List<Category> categoryList = [];

  Category getCatById(int id) {
    return categoryList.firstWhere((cat) => cat.id == id);
  }

  List<Category> filterCatByType(String type) {
    return categoryList.where((cat) => cat.catType == type).toList();
  }

  void setCategories(List<Category> categories) {
    this.categoryList = categories;
    notifyListeners();
  }

  void addCategory(Category category) {
    DatabaseProvider.db.insertCategory(category).then((storedCategory) {
      categoryList.add(storedCategory);
    });
    notifyListeners();
  }

  void deleteCategory(int id) {
    DatabaseProvider.db.deleteCategory(id).then((_) {
      categoryList.removeWhere((cat) => cat.id == id);
    });
    notifyListeners();
  }

  void updateCategory(Category category) {
    DatabaseProvider.db.updateCategory(category).then((_) {
      int index = categoryList.indexWhere((cat) => cat.id == category.id);
      categoryList[index] = category;
    });
    notifyListeners();
  }
}
