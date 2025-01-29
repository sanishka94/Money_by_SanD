import 'package:flutter/material.dart';

import '../providers/database_provider.dart';
import '../models/setting.dart';

class Settings extends ChangeNotifier {
  List<Setting> settingList = [];

  int createId(int year, int month) {
    int id =
        month < 10 ? int.parse('${year}0$month') : int.parse('$year$month');
    return id;
  }

  Setting getSettById(int id) {
    return settingList.firstWhere(
      (sett) => sett.id == id,
      orElse: () => null,
    );
  }

  double getBudgetByDate(DateTime date) {
    Setting sett = getSettById(createId(date.year, date.month));
    if (sett == null) {
      return 0;
    } else {
      return sett.value;
    }
  }

  List<Setting> filterAccByType(String type) {
    return settingList.where((sett) => sett.type == type).toList();
  }

  void setSettings(List<Setting> settings) {
    this.settingList = settings;
    notifyListeners();
  }

  void addSetting(Setting setting) {
    DatabaseProvider.db.insertSetting(setting).then((storedSetting) {
      settingList.add(storedSetting);
    });
    notifyListeners();
  }

  void deleteSetting(int id) {
    DatabaseProvider.db.deleteSetting(id).then((_) {
      settingList.removeWhere((sett) => sett.id == id);
    });
    notifyListeners();
  }

  void updateSetting(Setting setting) {
    DatabaseProvider.db.updateSetting(setting).then((_) {
      int index = settingList.indexWhere((sett) => sett.id == setting.id);
      settingList[index] = setting;
    });
    notifyListeners();
  }

  // void updateBalance(int id, double amount, bool isMinus) {
  //   Setting sett = settingList.firstWhere((sett) => sett.id == id);
  //   if (isMinus) {
  //     sett.value = sett.value - amount;
  //   } else {
  //     sett.value = sett.value + amount;
  //   }
  //   updateSetting(sett);
  // }
}
