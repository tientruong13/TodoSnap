import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'setting_model.g.dart';

@HiveType(typeId: 3)
class SettingsModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  late String format;

  SettingsModel({this.id, required this.format});
}
