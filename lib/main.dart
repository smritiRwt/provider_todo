// // // main.dart

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:provider_app/views/task_list_screen.dart';
// // import 'providers/task_provider.dart';

// // void main() {
// //   runApp(
// //     MultiProvider(
// //       providers: [
// //         ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),
// //       ],
// //       child: MyApp(),
// //     ),
// //   );
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: TaskListScreen(),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:provider_app/models/student.dart';
// import 'package:provider_app/services/database_helper.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: const StudentPage(),
//     );
//   }
// }

// class StudentPage extends StatefulWidget {
//   const StudentPage({super.key});

//   @override
//   _StudentPageState createState() => _StudentPageState();
// }

// class _StudentPageState extends State<StudentPage> {
//   final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
//   late Future<List<Student>> students; // Added null safety
//   String? _studentName; // Made nullable for null safety
//   bool isUpdate = false;
//   int? studentIdForUpdate; // Made nullable for null safety
//   late DBHelper dbHelper;
//   final _studentNameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     dbHelper = DBHelper();
//     refreshStudentList();
//   }

//   void refreshStudentList() {
//     setState(() {
//       students = dbHelper.getStudents();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SQLite CRUD in Flutter'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Form(
//             key: _formStateKey,
//             autovalidateMode: AutovalidateMode.onUserInteraction, // Updated autovalidateMode
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                   child: TextFormField(
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please Enter Student Name';
//                       }
//                       if (value.trim().isEmpty) {
//                         return "Only Space is Not Valid!!!";
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _studentName = value;
//                     },
//                     controller: _studentNameController,
//                     decoration: const InputDecoration(
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.purple,
//                           width: 2,
//                           style: BorderStyle.solid,
//                         ),
//                       ),
//                       labelText: "Student Name",
//                       icon: Icon(
//                         Icons.business_center,
//                         color: Colors.purple,
//                       ),
//                       fillColor: Colors.white,
//                       labelStyle: TextStyle(
//                         color: Colors.purple,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                 ),
//                 child: Text(
//                   (isUpdate ? 'UPDATE' : 'ADD'),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   if (_formStateKey.currentState!.validate()) {
//                     _formStateKey.currentState!.save();
//                     if (isUpdate) {
//                       dbHelper.update(Student(studentIdForUpdate!, _studentName!)).then((data) {
//                         setState(() {
//                           isUpdate = false;
//                         });
//                         refreshStudentList();
//                       });
//                     } else {
//                       dbHelper.add(Student(null, _studentName!)).then((_) {
//                         refreshStudentList();
//                       });
//                     }
//                     _studentNameController.clear();
//                   }
//                 },
//               ),
//              const SizedBox(width: 10), // Added spacing between buttons
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                 ),
//                 child: Text(
//                   (isUpdate ? 'CANCEL UPDATE' : 'CLEAR'),
//                   style:const TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   _studentNameController.clear();
//                   setState(() {
//                     isUpdate = false;
//                     studentIdForUpdate = null;
//                   });
//                 },
//               ),
//             ],
//           ),
//           const Divider(
//             height: 5.0,
//           ),
//           Expanded(
//             child: FutureBuilder<List<Student>>(
//               future: students,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasData) {
//                   return generateList(snapshot.data!);
//                 } else {
//                   return const Text('No Data Found');
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   SingleChildScrollView generateList(List<Student> students) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: DataTable(
//           columns:const [
//             DataColumn(
//               label: Text('NAME'),
//             ),
//             DataColumn(
//               label: Text('DELETE'),
//             ),
//           ],
//           rows: students.map((student) {
//             return DataRow(
//               cells: [
//                 DataCell(
//                   Text(student.name ?? 'Unknown'), // Handle possible null value
//                   onTap: () {
//                     setState(() {
//                       isUpdate = true;
//                       studentIdForUpdate = student.id;
//                     });
//                     _studentNameController.text = student.name ?? '';
//                   },
//                 ),
//                 DataCell(
//                   IconButton(
//                     icon:const Icon(Icons.delete),
//                     onPressed: () {
//                       dbHelper.delete(student.id!);
//                       refreshStudentList();
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/models/student.dart';
import 'package:provider_app/providers/student_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: StudentPage(),
    );
  }
}
// student_page.dart
class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _studentNameController = TextEditingController();
  bool isUpdate = false;
  int? studentIdForUpdate;

  @override
  void initState() {
    super.initState();
    Provider.of<StudentProvider>(context, listen: false).fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite CRUD in Flutter'),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    controller: _studentNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Student Name';
                      }
                      if (value.trim().isEmpty) {
                        return "Only Space is Not Valid!!!";
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      labelText: "Student Name",
                      icon: Icon(
                        Icons.business_center,
                        color: Colors.purple,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                child: Text(
                  (isUpdate ? 'UPDATE' : 'ADD'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_formStateKey.currentState!.validate()) {
                    _formStateKey.currentState!.save();
                    if (isUpdate) {
                      studentProvider.updateStudent(studentIdForUpdate!, _studentNameController.text);
                      setState(() {
                        isUpdate = false;
                      });
                    } else {
                      studentProvider.addStudent(_studentNameController.text);
                    }
                    _studentNameController.clear();
                  }
                },
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  (isUpdate ? 'CANCEL UPDATE' : 'CLEAR'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _studentNameController.clear();
                  setState(() {
                    isUpdate = false;
                    studentIdForUpdate = null;
                  });
                },
              ),
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, provider, child) {
                if (provider.students.isEmpty) {
                  return Center(child: Text('No Data Found'));
                } else {
                  return generateList(provider.students);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<Student> students) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('NAME'),
            ),
            DataColumn(
              label: Text('DELETE'),
            ),
          ],
          rows: students.map((student) {
            return DataRow(
              cells: [
                DataCell(
                  Text(student.name ?? 'Unknown'),
                  onTap: () {
                    setState(() {
                      isUpdate = true;
                      studentIdForUpdate = student.id;
                    });
                    _studentNameController.text = student.name ?? '';
                  },
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<StudentProvider>(context, listen: false).deleteStudent(student.id!);
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
