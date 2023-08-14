// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_app/widget/utils.dart';
import 'package:task_app/widget/uuid.dart';

part 'subtask_model.g.dart';

@HiveType(typeId: 2)
class SubTaskModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String detail;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  String parent;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  int? subTaskIndex;

  @HiveField(7)
  TimeOfDay? eventTime;

  @HiveField(8)
  DateTime? eventDate;

  @HiveField(9)
  int? notificationId;

  @HiveField(10)
  String? imagePath; // Make imagePath nullable

  @HiveField(11)
  List<String> imagePaths;

  @HiveField(12)
  NotificationType? notificationType;

  @HiveField(13)
  bool? isNotificationActive;

  SubTaskModel({
    String? id,
    required this.title,
    required this.detail,
    this.isCompleted = false,
    required this.parent,
    required this.date,
    this.subTaskIndex,
    this.isNotificationActive,
    this.notificationType,
    this.eventTime,
    this.eventDate,
    this.notificationId,
    this.imagePath, // imagePath can be null now
    required this.imagePaths,
  }) : this.id = id ?? Uuid().generateV4();

  // Add the copyWith method to the SubTaskModel class
  SubTaskModel copyWith({
    String? id,
    String? title,
    String? detail,
    bool? isCompleted,
    String? parent,
    DateTime? date,
    int? subTaskIndex,
    TimeOfDay? eventTime,
    DateTime? eventDate,
    int? notificationId,
    String? imagePath, // Add imagePath to copyWith
    List<String>? imagePaths,
  }) {
    return SubTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      isCompleted: isCompleted ?? this.isCompleted,
      parent: parent ?? this.parent,
      date: date ?? this.date,
      subTaskIndex: subTaskIndex ?? this.subTaskIndex,
      eventTime: eventTime ?? this.eventTime,
      eventDate: eventDate ?? this.eventDate,
      notificationId: notificationId ?? this.notificationId,
      imagePath: imagePath ??
          this.imagePath, // Assign imagePath in the copyWith method
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}
