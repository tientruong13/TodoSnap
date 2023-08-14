// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';

import 'package:task_app/widget/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  int color;

  @HiveField(4)
  int codePoint;

  @HiveField(5)
  int indexId;

  @HiveField(6)
  List<String> subTasks;

  TaskModel({
    String? id,
    List<String>? subTasks,
    required this.title,
    this.isCompleted = false,
    required this.color,
    required this.codePoint,
    required this.indexId,
  })  : this.id = id ?? Uuid().generateV4(),
        this.subTasks = subTasks ?? [];
  // assert(indexId != null, 'indexId must not be null');

  TaskModel copyWith({
    bool? isCompleted,
    String? title,
    int? codePoint,
    int? color,
    int? indexId,
    List<String>? subTasks,
  }) {
    return TaskModel(
      id: this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      title: title ?? this.title,
      color: color ?? this.color,
      codePoint: codePoint ?? this.codePoint,
      indexId: indexId ?? this.indexId,
      subTasks: subTasks ?? this.subTasks,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, indexId: $indexId)';
  }
}
