import 'package:get_it/get_it.dart';
import 'package:task_app/Page/Setting/theme/services/storage/hive_storage_service.dart';
import 'package:task_app/Page/Setting/theme/services/storage/storage_service.dart';

final getIt = GetIt.instance;

void setUpServiceLocator() {
  getIt.registerSingleton<StorageService>(HiveStorageService());
}
