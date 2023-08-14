import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Page/subtask_page/image/pick_options.dart';
import 'package:task_app/Provider/task_data_provider.dart';
import 'package:task_app/notification/notification_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_app/widget/utils.dart';

class SubTaskDataProvider extends ChangeNotifier {
  List<SubTaskModel> _subTaskList = [];

  List<SubTaskModel> get getSubTaskList => _subTaskList;

  SubTaskDataProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      var subBox = await Hive.openBox<SubTaskModel>('subTask');
      _subTaskList = subBox.values.toList();
      _subTaskList.forEach((subTask) {
        print('Loaded subtask with image path: ${subTask.imagePath}');
      });
    } catch (error) {
      print('Error opening Hive box: $error');
    } finally {
      notifyListeners();
    }
  }

  void addSubTask(SubTaskModel subTask) async {
    print('Adding subtask with image path: ${subTask.imagePath}');
    var subBox = await Hive.openBox<SubTaskModel>('subTask');
    await subBox.add(subTask);
    _subTaskList = subBox.values.toList();
    updateAppWidget();
    notifyListeners();
  }

  Future<void> deleteSubTask(SubTaskModel subTask) async {
    var subBox = await Hive.openBox<SubTaskModel>('subTask');
    SubTaskModel toDeleteSubTask =
        _subTaskList.firstWhere((it) => it.id == subTask.id);
    int toDeleteItemIndex = _subTaskList.indexOf(toDeleteSubTask);
    if (toDeleteItemIndex >= 0) {
      await subBox.deleteAt(toDeleteItemIndex);
      _subTaskList = subBox.values.toList();
      updateAppWidget();
      notifyListeners();
    }
  }

  void editSubTask(
      {required SubTaskModel toEditedSubTask, required String id}) async {
    var subBox = await Hive.openBox<SubTaskModel>('subTask');
    _subTaskList = subBox.values.toList();
    SubTaskModel toEditTask = _subTaskList.firstWhere((it) => it.id == id);
    int editItemIndex = _subTaskList.indexOf(toEditTask);
    // print('Old task: $toEditTask');
    // print('Replace index: $editItemIndex');

    await subBox.putAt(editItemIndex, toEditedSubTask);
    _subTaskList = subBox.values.toList();
    updateAppWidget();
    notifyListeners();
  }

  void toggleSubTask(BuildContext context,
      {required String id,
      required String title,
      required bool newValue}) async {
    var subBox = await Hive.openBox<SubTaskModel>('subTask');
    _subTaskList = subBox.values.toList();
    SubTaskModel toModifyTask = _subTaskList.firstWhere(
      (it) => it.id == id && it.title == title,
    );
    toModifyTask.isCompleted = newValue;
    int toModifyTaskIndex = _subTaskList.indexOf(toModifyTask);
    await subBox.putAt(toModifyTaskIndex, toModifyTask);
    _subTaskList = subBox.values.toList();
    updateAppWidget();
    final taskProvider = Provider.of<TaskDataProvider>(context, listen: false);
    TaskModel parentTask = taskProvider.getTaskList
        .firstWhere((it) => it.id == toModifyTask.parent);
    taskProvider.markTaskCompleted(context, parentTask);
    notifyListeners();
  }

  List<SubTaskModel> get getSubTasksListBySort {
    List<SubTaskModel> subTasksListBySort = _subTaskList.toList();
    subTasksListBySort.sort((a, b) {
      if (a.isCompleted && !b.isCompleted) {
        return 1;
      } else if (!a.isCompleted && b.isCompleted) {
        return -1;
      } else {
        return a.title.compareTo(b.title);
      }
    });
    return subTasksListBySort;
  }

  int get totalSubTasks => _subTaskList.length;

  int get completedSubTasks {
    final completedSubTasks =
        _subTaskList.where((it) => it.isCompleted).toList();
    return completedSubTasks.length;
  }

  int get unCompletedSubTasks {
    final unCompletedSubTasks =
        _subTaskList.where((it) => !it.isCompleted).toList();
    return unCompletedSubTasks.length;
  }

  int getTotalSubTasLeft(TaskModel task) => getSubTaskList
      .where((it) => it.parent == task.id && !it.isCompleted)
      .length;

  int currentFinishedTaskCount(TaskModel task) {
    List<SubTaskModel> newList = getSubTaskList
        .where((it) => it.parent == task.id && it.isCompleted == true)
        .toList();
    return newList.length;
  }

  int subTaskCount(TaskModel task) {
    List<SubTaskModel> newList =
        getSubTaskList.where((it) => it.parent == task.id).toList();
    return newList.length;
  }

  int currentTotalTaskCount(List<SubTaskModel> _subTaskList) {
    return _subTaskList.length;
  }

  int get getTotalTaskCount {
    return _subTaskList.length;
  }

  List<SubTaskModel> getSubtasksForTask(String taskId) {
    List<SubTaskModel> subtasksForTask =
        _subTaskList.where((subtask) => subtask.parent == taskId).toList();
    return subtasksForTask;
  }

  List<SubTaskModel> get getCompletedTasksList {
    List<SubTaskModel> completedTasks = _subTaskList
        .where((it) => it.parent == it.id && it.isCompleted == true)
        .toList();
    return [...completedTasks];
  }

  int get getTotalDoneTaskCount {
    return getCompletedTasksList.length;
  }

//search subtask

  String _enteredKeyword = '';

  List<SubTaskModel> get searchSubTaskList => _enteredKeyword.isEmpty
      ? []
      : getSubTaskList.where((it) {
          // print('Subtask title: ${it.title}');
          return it.title.contains(_enteredKeyword);
        }).toList();

  void searchSubTasksByTitle(String enteredKeyword) {
    _enteredKeyword = enteredKeyword;
    // print('_enteredKeyword : $_enteredKeyword');
    searchSubTaskList.clear();

    notifyListeners();
  }

// calendar

  Map<String, List<SubTaskModel>> getTasksWithSubtasksForDay(DateTime day) {
    final tasksForSubtasks = getSubTaskList
        .where((it) =>
            it.date.year == day.year &&
            it.date.month == day.month &&
            it.date.day == day.day)
        .toList();

    Map<String, List<SubTaskModel>> tasksWithSubtasks = {};

// get subtasks in task list
    tasksForSubtasks.forEach((subtask) {
      if (tasksWithSubtasks.containsKey(subtask.parent)) {
        tasksWithSubtasks[subtask.parent]!.add(subtask);
      } else {
        tasksWithSubtasks[subtask.parent] = [subtask];
      }
    });

    return tasksWithSubtasks;
  }

  int getAllTasksCountForDay(DateTime day) {
    final tasksForSubtasks = getSubTaskList
        .where((it) =>
            it.date.year == day.year &&
            it.date.month == day.month &&
            it.date.day == day.day)
        .toList();
    return tasksForSubtasks.length;
  }

  int getCompletedTasksCountForDay(DateTime day) {
    final tasksForSubtasks = getSubTaskList
        .where((it) =>
            it.date.year == day.year &&
            it.date.month == day.month &&
            it.date.day == day.day &&
            it.isCompleted)
        .toList();
    return tasksForSubtasks.length;
  }

  int getUncompletedTasksCountForDay(DateTime day) {
    final tasksForSubtasks = getSubTaskList
        .where((it) =>
            it.date.year == day.year &&
            it.date.month == day.month &&
            it.date.day == day.day &&
            !it.isCompleted)
        .toList();
    return tasksForSubtasks.length;
  }

  List<SubTaskModel> getSubtasksForTaskForToday(String taskId) {
    DateTime today = DateTime.now();
    //  DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);
    List<SubTaskModel> subtasksToday = getSubTasksListBySort
        .where((subtask) =>
            // !subtask.isCompleted &&
            subtask.parent == taskId &&
            subtask.date.year == today.year &&
            subtask.date.month == today.month &&
            subtask.date.day == today.day)
        .toList();
    return subtasksToday;
  }

  List<SubTaskModel> getSubtasksForTaskForTomorrow(String taskId) {
    DateTime today = DateTime.now();
    DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);
    List<SubTaskModel> subtasksToday = getSubTasksListBySort
        .where((subtask) =>
            // !subtask.isCompleted &&
            subtask.parent == taskId &&
            subtask.date.year == tomorrow.year &&
            subtask.date.month == tomorrow.month &&
            subtask.date.day == tomorrow.day)
        .toList();
    return subtasksToday;
  }

  int getTodayUncompletedSubtasksCount() {
    DateTime today = DateTime.now();
    String todayStr = DateFormat('yyyyMMdd').format(today);

    int count = _subTaskList.where((subtask) {
      DateTime subtaskDate = subtask.date;
      String subtaskDateStr = DateFormat('yyyyMMdd').format(subtaskDate);

      return subtaskDateStr == todayStr && !subtask.isCompleted;
    }).length;

    return count;
  }

  Future<void> updateSubTask(SubTaskModel subTask) async {
    var subBox = await Hive.openBox<SubTaskModel>('subTask');
    int indexToUpdate = _subTaskList.indexWhere((it) => it.id == subTask.id);
    if (indexToUpdate >= 0) {
      await subBox.putAt(indexToUpdate, subTask);
      _subTaskList[indexToUpdate] = subTask;
      notifyListeners();
    }
  }

  void createSubTaskNotification(
    SubTaskModel subTask,
    TaskModel task,
    String payload,
  ) async {
    NotificationManager notificationManager = NotificationManager();
    subTask.notificationType = NotificationType.Custom;
    subTask.isNotificationActive = true;
    await updateSubTask(subTask);
    notificationManager.scheduleNotification(
      subTask.id.hashCode, // id
      task.title,
      subTask.title, // body
      subTask, // subTask
      task,
      subTask.eventDate!, // eventDate
      subTask.eventTime!, // eventTime
      payload, // payload
    );
    notifyListeners();
  }

  void createDailyNotification(
    SubTaskModel subTask,
    TaskModel task,
    String payload,
  ) async {
    NotificationManager notificationManager = NotificationManager();
    subTask.notificationType = NotificationType.Daily;
    subTask.isNotificationActive = true;
    await updateSubTask(subTask);
    notificationManager.scheduleDailyNotification(
      subTask.id.hashCode, // id
      task.title, // title
      subTask.title, // body
      subTask, // subTask
      task, // task
      subTask.eventTime!, // eventTime
      payload, // payload
    );
  }

  void createWeeklyNotification(
    SubTaskModel subTask,
    TaskModel task,
    int weekday, // weekday as integer (1: Monday, 7: Sunday)
    String payload,
  ) async {
    NotificationManager notificationManager = NotificationManager();
    subTask.notificationType = NotificationType.Weekly;
    subTask.isNotificationActive = true;
    await updateSubTask(subTask);
    notificationManager.scheduleWeeklyNotification(
      subTask.id.hashCode, // id
      task.title, // title
      subTask.title, // body
      subTask, // subTask
      task, // task
      weekday, // weekday
      subTask.eventTime!, // eventTime
      payload, // payload
    );
  }

  void createMonthlyNotification(
    SubTaskModel subTask,
    TaskModel task,
    int dayOfMonth, // Day of the month as integer (1 to 31)
    String payload,
  ) async {
    NotificationManager notificationManager = NotificationManager();
    subTask.notificationType = NotificationType.Monthly;
    subTask.isNotificationActive = true;
    await updateSubTask(subTask);
    notificationManager.scheduleMonthlyNotification(
      subTask.id.hashCode, // id
      task.title, // title
      subTask.title, // body
      subTask, // subTask
      task, // task
      dayOfMonth, // dayOfMonth;
      subTask.eventTime!, // eventTime
      payload, // payload
    );
  }

  void cancelSubTaskNotification(SubTaskModel subTask) async {
    NotificationManager notificationManager = NotificationManager();

    // Cancel the notification with the specific ID
    notificationManager.cancelNotification(subTask.id.hashCode);
    subTask.isNotificationActive = false;
    await updateSubTask(subTask);
    notifyListeners();
  }

  // Add Image
  final picker = ImagePicker();
  List<String> _imagePaths = [];

  Future<File?> downloadImage(String url) async {
    try {
      if (!(url.startsWith('http://') || url.startsWith('https://'))) {
        url = 'http://' + url;
      }
      var uri = Uri.parse(url);
      var fileName = uri.pathSegments.last;
      final response = await http.get(uri);
      // Attempt to instantiate an image codec from the data
      final codec = await PaintingBinding.instance
          .instantiateImageCodec(response.bodyBytes);
      // ignore: unnecessary_null_comparison
      if (codec == null) {
        throw Exception('No image');
      }
      final documentDirectory = await getApplicationDocumentsDirectory();
      final file = File(path.join(documentDirectory.path, fileName));
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (e) {
      print('No image at this URL');
      return null;
    }
  }
  // Future<File?> downloadImage(String url) async {
  //   var uri = Uri.parse(url);
  //   var fileName = uri.pathSegments.last;
  //   final response = await http.get(uri);
  //   final documentDirectory = await getApplicationDocumentsDirectory();
  //   final file = File(path.join(documentDirectory.path, fileName));
  //   await file.writeAsBytes(response.bodyBytes);
  //   return file;
  // }

  Future<String?> addImage(BuildContext context) async {
    ExtendedImageSource? imageSource = await showImageOptions(context);

    if (imageSource == null) {
      return null; // The user didn't select an option, do nothing
    }

    if (imageSource == ExtendedImageSource.internet) {
      String? imageUrl = await showUrlInputBox(context);
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final file = await downloadImage(imageUrl);
        return file?.path;
      }
      return null;
    }

    // The picker only accepts ImageSource values, so we need to convert our ExtendedImageSource value back to ImageSource
    ImageSource? pickerSource;
    if (imageSource == ExtendedImageSource.gallery) {
      pickerSource = ImageSource.gallery;
    } else if (imageSource == ExtendedImageSource.camera) {
      pickerSource = ImageSource.camera;
    }

    if (pickerSource != null) {
      final pickedFile = await ImagePicker().pickImage(source: pickerSource);

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(pickedFile.path);
        final File savedImage =
            await File(pickedFile.path).copy('${appDir.path}/$fileName');
        return savedImage.path;
      } else {
        print('No image selected.');
        return null;
      }
    }

    // Return null if the image source is not expected
    return null;
  }
  // Future<String?> addImage(BuildContext context) async {
  //   ImageSource? imageSource = await showImageOptions(context);

  //   if (imageSource == null) {
  //     return null; // The user didn't select an option, do nothing
  //   }
  //   final pickedFile = await ImagePicker().pickImage(source: imageSource);
  //   if (pickedFile != null) {
  //     final appDir = await getApplicationDocumentsDirectory();
  //     final fileName = p.basename(pickedFile.path);
  //     final File savedImage =
  //         await File(pickedFile.path).copy('${appDir.path}/$fileName');

  //     return savedImage.path;
  //   } else {
  //     print('No image selected.');
  //     return null;
  //   }
  // }

  List<String> getImagePaths() {
    return _imagePaths;
  }

  Future<void> deleteImage(int imageIndex, SubTaskModel subTask) async {
    try {
      String imagePath = subTask.imagePaths[imageIndex];
      final imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      subTask.imagePaths.removeAt(imageIndex);
      await updateSubTask(subTask);
      notifyListeners();
    } catch (error) {
      print('Error deleting image: $error');
    }
  }

  Future<void> shareSubtask({
    required String subtaskTitle,
    required String subtaskDetail,
    required List<String> imagePaths,
  }) async {
    try {
      if (imagePaths.isEmpty) {
        await Share.share(
          '${'Title'.tr()}: $subtaskTitle\n${'Detail'.tr()}: $subtaskDetail',
        );
      } else {
        final String tempPath = (await getTemporaryDirectory()).path;
        List<String> tempImagePaths = [];

        for (int i = 0; i < imagePaths.length; i++) {
          final String fileName = 'subtask_image_$i.png';
          final File originalImage = File(imagePaths[i]);
          final File tempImage =
              await originalImage.copy('$tempPath/$fileName');
          tempImagePaths.add(tempImage.path);
        }

        await Share.shareFiles(
          tempImagePaths,
          text:
              '${'Title'.tr()}: $subtaskTitle\n${'Detail'.tr()}: $subtaskDetail',
        );
      }
    } catch (e) {
      print('Error sharing subtask: $e');
    }
  }

  SubTaskModel? getSubtaskById(String id) {
    try {
      // _taskList
      //     .forEach((task) => print("Task Id from getTaskById: ${task.id}"));
      return _subTaskList.firstWhere((subtask) => subtask.id == id);
    } catch (e) {
      print("Error: Task not found for id: $id");
      return null;
    }
  }

  // Future<void> updateAppWidget() async {
  //   // Load the existing count from the widget data
  //   int? previousCount = await HomeWidget.getWidgetData<int>('count');

  //   int currentCount = getTodayUncompletedSubtasksCount();
  //   print('Task count: $currentCount');
  //   // If the current count is different from the previous count, update the widget
  //   if (previousCount != currentCount) {
  //     await HomeWidget.saveWidgetData<int>('count', currentCount);
  //     await HomeWidget.updateWidget(
  //         name: 'HomeScreenWidgetProvider',
  //         androidName: 'HomeScreenWidgetProvider',
  //         iOSName: 'HomeScreenWidgetProvider');
  //   }
  // }
  Future<void> updateAppWidget() async {
    int count = getTodayUncompletedSubtasksCount();
    print('Count: $count');
    await HomeWidget.saveWidgetData<int>('count', count);
    await HomeWidget.updateWidget(
        name: 'HomeScreenWidgetProvider',
        androidName: 'HomeScreenWidgetProvider',
        iOSName: 'HomeScreenWidgetProvider');
  }
}
