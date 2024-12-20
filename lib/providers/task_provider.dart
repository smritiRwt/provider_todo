// // providers/task_provider.dart

// import 'package:flutter/material.dart';
// import 'package:provider_app/models/note_model.dart';
// import '../services/database_helper.dart';

// class TaskProvider extends ChangeNotifier {
//   List<Task> _tasks = [];

//   List<Task> get tasks => _tasks;

//   Future<void> loadTasks() async {
//     _tasks = await DatabaseHelper.instance.readAllTasks();
//     notifyListeners();
//   }

//   Future<void> addTask(Task task) async {
//     await DatabaseHelper.instance.createTask(task);
//     await loadTasks(); // Refresh the task list
//   }

//   Future<void> updateTask(Task task) async {
//     await DatabaseHelper.instance.updateTask(task);
//     await loadTasks(); // Refresh the task list
//   }

//   Future<void> deleteTask(int id) async {
//     await DatabaseHelper.instance.deleteTask(id);
//     await loadTasks(); // Refresh the task list
//   }
// }
