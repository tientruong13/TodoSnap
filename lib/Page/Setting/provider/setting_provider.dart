import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_app/Model/setting_model.dart';

class SettingProvider with ChangeNotifier {
  SettingsModel? _selectedDateFormat;

  SettingProvider() {
    // Set a default value for the date format
    _selectedDateFormat = SettingsModel(format: 'MMM d');
    // Load date format from Hive
    loadDateFormat();
  }

  SettingsModel? get selectedDateFormat => _selectedDateFormat;

  Future<void> loadDateFormat() async {
    final dateFormatBox = await Hive.openBox<SettingsModel>('dateFormats');
    if (dateFormatBox.isNotEmpty) {
      _selectedDateFormat = dateFormatBox.getAt(0);
    }
    notifyListeners();
  }

  Future<void> setDateFormat(String format) async {
    final dateFormatBox = await Hive.openBox<SettingsModel>('dateFormats');
    SettingsModel dateFormat = SettingsModel(format: format);
    if (dateFormatBox.isEmpty) {
      await dateFormatBox.add(dateFormat);
    } else {
      await dateFormatBox.putAt(0, dateFormat);
    }
    _selectedDateFormat = dateFormat;
    notifyListeners();
  }
}

// class SettingProvider with ChangeNotifier {
//   SettingsModel? _selectedDateFormat;

//   SettingsModel? get selectedDateFormat => _selectedDateFormat;

//   Future<void> loadDateFormat() async {
//     final dateFormatBox = await Hive.openBox<SettingsModel>('dateFormats');
//     if (dateFormatBox.isNotEmpty) {
//       _selectedDateFormat = dateFormatBox.getAt(0);
//     }
//     notifyListeners();
//   }

//   Future<void> setDateFormat(String format) async {
//     final dateFormatBox = await Hive.openBox<SettingsModel>('dateFormats');
//     SettingsModel dateFormat = SettingsModel(format: format);
//     if (dateFormatBox.isEmpty) {
//       await dateFormatBox.add(dateFormat);
//     } else {
//       await dateFormatBox.putAt(0, dateFormat);
//     }
//     _selectedDateFormat = dateFormat;
//     notifyListeners();
//   }
// }
