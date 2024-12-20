// // screens/task_list_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:provider_app/models/note_model.dart';
// import '../providers/task_provider.dart';

// class TaskListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Task List')),
//       body: ListView.builder(
//         itemCount: taskProvider.tasks.length,
//         itemBuilder: (context, index) {
//           final task = taskProvider.tasks[index];
//           return ListTile(
//             title: Text(task.title),
//             trailing: Checkbox(
//               value: task.isCompleted,
//               onChanged: (value) {
//                 final updatedTask = Task(
//                   id: task.id,
//                   title: task.title,
//                   isCompleted: value!,
//                 );
//                 // taskProvider.updateTask(updatedTask);
//               },
//             ),
//             onLongPress: () => taskProvider.deleteTask(task.id!),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           taskProvider.addTask(Task(title: 'New Task'));
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
