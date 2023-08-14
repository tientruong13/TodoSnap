import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_app/Model/subtask_model.dart';
import 'package:task_app/Model/task_model.dart';
import 'package:task_app/Provider/subtask_data_provider.dart';

class TaskDataProvider extends ChangeNotifier {
  List<TaskModel> _taskList = [];

  List<TaskModel> get getTaskList => _taskList;

  TaskDataProvider() {
    _init();
  }

  Future<void> _init() async {
    var box = await Hive.openBox<TaskModel>('task');
    _taskList = box.values.toList();
    // _taskList.sort((a, b) => a.indexId.compareTo(b.indexId));
    notifyListeners();
  }

  void getAllTask() async {
    var box = await Hive.openBox<TaskModel>('task');
    _taskList = box.values.toList();
    _taskList.sort((a, b) => a.indexId.compareTo(b.indexId));
    notifyListeners();
  }

  // Future<void> updateTask(TaskModel task, int indexId) async {
  //   var box = await Hive.openBox<TaskModel>('task');
  //   TaskModel taskWithOrder = task.copyWith(indexId: indexId);
  //   await box.put(task.id, taskWithOrder);
  //   getAllTask();
  //   notifyListeners();
  // }
  // Future<void> updateTask(TaskModel task) async {
  //   var box = await Hive.openBox<TaskModel>('task');
  //   await box.put(task.id, task);
  //   getAllTask();
  //   notifyListeners();
  // }

  Future<void> addNewIndexId(TaskModel task, int indexId) async {
    var box = await Hive.openBox<TaskModel>('task');
    _taskList = box.values.toList();
    TaskModel newTask = task.copyWith(indexId: indexId);
    print('New Task: $newTask'); // Add print statement here to debug
    await box.put(task.id, newTask);
    _taskList[indexId] = newTask;
    notifyListeners(); // Notify listeners here to ensure the UI updates.
  }
  // void addNewIndexI({required TaskModel toEditedTask, required String id}) async {
  //   var box = await Hive.openBox<TaskModel>('task');
  //   _taskList = box.values.toList();
  //   TaskModel toEditTask = _taskList.firstWhere((it) => it.id == id);
  //   int editItemIndex = _taskList.indexOf(toEditTask);
  //   // print('Old task: $toEditTask');
  //   // print('Replace index: $editItemIndex');

  //   await box.putAt(editItemIndex, toEditedTask);
  //   _taskList = box.values.toList();
  //   notifyListeners();
  // }

  void addTask(TaskModel task) async {
    var box = await Hive.openBox<TaskModel>('task');
    await box.add(task);
    _taskList = box.values.toList();
    notifyListeners();
  }

// Import your SubTaskDataProvider

  Future<void> deleteTask(
      TaskModel task, SubTaskDataProvider subTaskProvider) async {
    // Get all subtasks associated with the task to delete.
    List<SubTaskModel> subTasksToDelete = subTaskProvider.getSubTaskList
        .where((subTask) => subTask.parent == task.id)
        .toList();

    // Print the subtasks to be deleted.
    print("Subtasks to delete: $subTasksToDelete");

    // Delete each subtask.
    for (var subTask in subTasksToDelete) {
      await subTaskProvider.deleteSubTask(subTask);
    }

    // Print the remaining subtasks after deletion.
    List<SubTaskModel> remainingSubTasks = subTaskProvider.getSubTaskList
        .where((subTask) => subTask.parent == task.id)
        .toList();
    print("Remaining subtasks: $remainingSubTasks");

    var box = await Hive.openBox<TaskModel>('task');
    List<TaskModel> filteredTasks = _taskList
        .where((it) => it.id == task.id && it.title == task.title)
        .toList();
    if (filteredTasks.isNotEmpty) {
      TaskModel toDeleteTask = filteredTasks.first;
      int toDeleteItemIndex = _taskList.indexOf(toDeleteTask);
      await box.deleteAt(toDeleteItemIndex);
      _taskList = box.values.toList();
      notifyListeners();
    }
  }

  void deleteAllTask() async {
    var box = await Hive.openBox<TaskModel>('task');
    _taskList = box.values.toList();
    List<TaskModel> toDeleteTasks =
        _taskList.where((it) => it.isCompleted == true).toList();
    for (TaskModel task in toDeleteTasks) {
      if (toDeleteTasks.isNotEmpty) {
        await box.deleteAt(_taskList.indexOf(task));
        _taskList = box.values.toList();
      } else {
        return;
      }
    }
    notifyListeners();
  }

  void editTask({required TaskModel toEditedTask, required String id}) async {
    var box = await Hive.openBox<TaskModel>('task');
    _taskList = box.values.toList();
    TaskModel toEditTask = _taskList.firstWhere((it) => it.id == id);
    int editItemIndex = _taskList.indexOf(toEditTask);
    // print('Old task: $toEditTask');
    // print('Replace index: $editItemIndex');

    await box.putAt(editItemIndex, toEditedTask);
    _taskList = box.values.toList();
    notifyListeners();
  }

  // get task completion

  void markTaskCompleted(BuildContext context, TaskModel task) async {
    final subTaskProvider =
        Provider.of<SubTaskDataProvider>(context, listen: false);
    List<SubTaskModel> subTasks = subTaskProvider.getSubTaskList
        .where((subtask) => subtask.parent == task.id)
        .toList();

    TaskModel updatedTask;

    if (subTasks.isNotEmpty &&
        subTasks.every((subtask) => subtask.isCompleted)) {
      updatedTask = task.copyWith(isCompleted: true);
    } else {
      updatedTask = task.copyWith(isCompleted: false);
    }
    // print('Task before update: ${task.isCompleted}');
    print('Task after update: ${updatedTask.isCompleted}');

    final box = await Hive.openBox<TaskModel>('task');
    int taskIndex = _taskList.indexWhere((t) => t.id == task.id);
    await box.putAt(taskIndex, updatedTask);
    _taskList = box.values.toList();

    // print('Subtasks for task ${task.title}:');
    // subTasks.forEach((subtask) {
    //   print('- ${subtask.title}: ${subtask.isCompleted}');
    // });

    // print('Updated task:${task.isCompleted}');
    print('Notifying listeners of task list change');

    notifyListeners();
  }

  List<TaskModel> get getCompletedTasksList {
    List<TaskModel> completedTasks =
        _taskList.where((task) => task.isCompleted).toList();
    return [...completedTasks];
  }

  List<TaskModel> get getNotCompletedTasksList {
    List<TaskModel> notCompletedTasks =
        _taskList.where((task) => !task.isCompleted).toList();
    notCompletedTasks.sort((a, b) => a.indexId.compareTo(b.indexId));
    return [...notCompletedTasks];
  }

  int get totalTasks => _taskList.length;

  int get completedTasks {
    final completedTasks = _taskList.where((task) => task.isCompleted).toList();
    return completedTasks.length;
  }

  int get unCompletedTasks {
    final unCompletedTasks =
        _taskList.where((task) => !task.isCompleted).toList();
    return unCompletedTasks.length;
  }

  List<TaskModel> tasksBySubTasks(List<String> taskIds) {
    return _taskList.where((task) => taskIds.contains(task.id)).toList();
  }

  //get parent id of subtask
  // TaskModel getTaskById(String taskId) {
  //   // Assuming you have a list of TaskModel objects called 'tasks'
  //   return _taskList.firstWhere((task) => task.id == taskId);
  // }
  TaskModel? getTaskById(String id) {
    try {
      // _taskList
      //     .forEach((task) => print("Task Id from getTaskById: ${task.id}"));
      return _taskList.firstWhere((task) => task.id == id);
    } catch (e) {
      print("Error: Task not found for id: $id");
      return null;
    }
  }
}
