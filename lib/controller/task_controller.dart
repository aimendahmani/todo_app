import 'package:get/get.dart';
import 'package:todoapp2/db/db_helper.dart';
import 'package:todoapp2/models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;
  Future<int> addTask(Task task) {
    return DbHelper.insert(task);
  }

  void deleteTask(Task task) async {
    print('task controller delete');
    await DbHelper.delete(task);
    getTask();
  }

  void markAsCompleted(int id) async {
    await DbHelper.update(id);
    getTask();
  }

  getTask() async {
    final tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }
}
