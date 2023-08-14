import 'package:flutter/material.dart';
import 'package:task_app/Page/name_page/name_storage.dart';

class NameNotifier with ChangeNotifier {
  final NameStorage _nameStorage;
  late String _name;
  bool _isNameSet = false;

  NameNotifier(this._nameStorage);

  String get name => _name;
  bool get isNameSet => _isNameSet;

  Future<void> init() async {
    _name = (await _nameStorage.getName())?? '';
    _isNameSet = _name.isNotEmpty;
    notifyListeners();
  }

  Future<void> setName(String name) async {
    await _nameStorage.storeName(name);
    _name = name;
    notifyListeners();
  }

  Future<void> editName(String newName) async {
    await setName(newName);
  }
}
