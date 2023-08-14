import 'package:hive/hive.dart';

class NameStorage {
  static const String _boxName = 'nameBox';
  static const String _nameKey = 'name';

  Future<void> storeName(String name) async {
    final box = await Hive.openBox<String>(_boxName);
    await box.put(_nameKey, name);
  }

  Future<String?> getName() async {
    final box = await Hive.openBox<String>(_boxName);
    return box.get(_nameKey);
  }
}