
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_app/Page/Setting/theme/services/storage/storage_service.dart';

class HiveStorageService implements StorageService {
  late Box hiveBox;

  Future<void> openBox([String boxName = 'FLUTTER_THEME_SWITCHER']) async {
    hiveBox = await Hive.openBox(boxName);
  }

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await openBox();
  }

  @override
  dynamic get(String key) {
    return hiveBox.get(key);
  }

  @override
  void set(String key, dynamic value) {
    hiveBox.put(key, value);
  }
}
