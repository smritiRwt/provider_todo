// student_provider.dart
import 'package:flutter/material.dart';

import 'package:provider_app/models/student.dart';
import 'package:provider_app/services/database_helper.dart';

class StudentProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  List<Student> _students = [];

  List<Student> get students => _students;

  Future<void> fetchStudents() async {
    _students = await _dbHelper.getStudents();
    notifyListeners();
  }

  Future<void> addStudent(String name) async {
    await _dbHelper.add(Student(null, name));
    await fetchStudents();
  }

  Future<void> updateStudent(int id, String name) async {
    await _dbHelper.update(Student(id, name));
    await fetchStudents();
  }

  Future<void> deleteStudent(int id) async {
    await _dbHelper.delete(id);
    await fetchStudents();
  }
}
