import 'package:flutter/material.dart';

import '../providers/database_provider.dart';

class Setting {
  int id;
  String type;
  double value;

  Setting({
    @required this.id,
    @required this.type,
    @required this.value,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.SET_ID: id,
      DatabaseProvider.SET_TYPE: type,
      DatabaseProvider.SET_VALUE: value,
    };
    return map;
  }

  Setting.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.SET_ID];
    type = map[DatabaseProvider.SET_TYPE];
    value = map[DatabaseProvider.SET_VALUE];
  }
}
